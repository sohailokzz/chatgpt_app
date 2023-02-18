import 'package:chatgpt_app/models/chat_model.dart';
import 'package:chatgpt_app/services/api_services.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(
      ChatModel(
        msg: msg,
        chatIndex: 0,
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessageAndGetUser({
    required String msg,
    required String chosenModel,
  }) async {
    chatList.addAll(
      await ApiService.sendMessage(
        msg,
        chosenModel,
      ),
    );
    notifyListeners();
  }
}
