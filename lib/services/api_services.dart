import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_app/constants/api_constant.dart';
import 'package:chatgpt_app/models/chat_model.dart';
import 'package:chatgpt_app/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
    String message,
    String modelId,
  ) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
          "max_tokens": 100,
        }),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        log('Json response ${jsonResponse["choices"][0]["text"]}');
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][0]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
