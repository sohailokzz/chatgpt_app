import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_app/constants/api_constant.dart';
import 'package:chatgpt_app/models/models_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/models'),
          headers: {'Authorization': ' Bearer $apiKey'});

      Map jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        log('Json response: $jsonResponse');
      }
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log('Error $error');
      rethrow;
    }
  }
}
