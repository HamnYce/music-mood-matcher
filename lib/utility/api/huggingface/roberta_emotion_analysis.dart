import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RobertaGoEmotionsApi {
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

    return parseInference(res.body);
  }

  dynamic parseInference(String inference) {
    List<dynamic> json = jsonDecode(inference)[0];
    List<dynamic> top3Scores = json.sublist(0, 3);
    List<String> top3Labels =
        top3Scores.map((value) => value['label'] as String).toList();

    print(top3Labels);
    return top3Labels.join(' ');
  }
}