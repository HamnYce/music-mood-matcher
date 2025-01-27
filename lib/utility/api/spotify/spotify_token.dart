import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyToken {
  String _token = 'Error Token';
  int _expireDate = 0;
  SharedPreferences? prefs;
  static const _tokenKey = 'token_key';
  static const _expireDateKey = 'expire_date_key';
  late String clientSecret;
  late String clientId;
  late String grantType;
  final Uri newTokenUri = Uri(
      scheme: 'https',
      host: 'accounts.spotify.com',
      pathSegments: ['api', 'token']);

  SpotifyToken() {
    rootBundle.loadString('assets/secrets/spotify_secrets.json').then((value) {
      Map<String, dynamic> json = jsonDecode(value);

      clientSecret = json['client_secret'];
      clientId = json['client_id'];
      grantType = json['grant_type'];

      SharedPreferences.getInstance().then((prefs) {
        this.prefs = prefs;

        if (this.prefs!.containsKey(_tokenKey)) {
          _token = this.prefs!.getString(_tokenKey)!;
          _expireDate = this.prefs!.getInt(_expireDateKey)!;
        } else {
          _refreshToken();
        }
      });
    });
  }

  Future<String> getToken() async {
    if (_isTokenExpired()) {
      return await _refreshToken();
    } else {
      return _token;
    }
  }

  bool _isTokenExpired() {
    return _expireDate == 0 ||
        DateTime.now().millisecondsSinceEpoch > _expireDate;
  }

  Future<String> _refreshToken() async {
    http.Response res = await http.post(newTokenUri, body: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': grantType
    });

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      await _saveToken(json['access_token']);
      return _token;
    }
    throw 'Could not refresh the token ${res.body}';
  }

  Future _saveToken(String token) async {
    int expireDate = DateTime.now()
        .add(const Duration(seconds: 3600))
        .millisecondsSinceEpoch;

    _token = token;
    _expireDate = expireDate;

    await prefs!.setString(_tokenKey, token);
    await prefs!.setInt(_expireDateKey, expireDate);
  }
}
