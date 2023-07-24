import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RobertaGoEmotionsApi {
  static const int emotionCountConst = 5;
  final Uri apiUri = Uri(
      scheme: 'https',
      host: 'api-inference.huggingface.co',
      pathSegments: ['models', 'SamLowe', 'roberta-base-go_emotions']);
  Map<String, String> headers = {};

  Future checkToken() async {
    if (headers['token'] != null) return;

    String rawJson =
        await rootBundle.loadString('assets/secrets/hugging_face.json');
    Map<String, dynamic> json = jsonDecode(rawJson);
    headers['Authorization'] = 'Bearer ${json['token']}';
  }

  Future<String> query(String userInput) async {
    await checkToken();

    http.Response res =
        await http.post(apiUri, headers: headers, body: {'inputs': userInput});

    if (res.statusCode == 200) {
      return parseInference(res.body);
    } else {
      print(res);
      return parseInference('');
    }
  }

  dynamic parseInference(String inference) {
    List<dynamic>? json = jsonDecode(inference)[0];
    if (json == null) return [];
    List<dynamic> topScores = json.sublist(0, emotionCountConst);
    List<String> topLabels =
        topScores.map((value) => value['label'] as String).toList();

    return topLabels.join(' ');
  }
}
