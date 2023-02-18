import 'dart:developer';
import 'package:chatgpt_app/constants/constants.dart';
import 'package:chatgpt_app/models/chat_model.dart';
import 'package:chatgpt_app/providers/chat_provider.dart';
import 'package:chatgpt_app/services/assets_manager.dart';
import 'package:chatgpt_app/services/services.dart';
import 'package:chatgpt_app/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/model_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;

  late TextEditingController chatController;
  late FocusNode focusNode;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    chatController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.ailogo,
          ),
        ),
        elevation: 2,
        title: const Text('ChatGPT'),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showBottomSheet(context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    msg: chatProvider.getChatList[index].msg.toString(),
                  );
                },
              ),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController,
                        focusNode: focusNode,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'How I can help you?',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    try {
      setState(() {
        isTyping = true;
        chatProvider.addUserMessage(
          msg: chatController.text,
        );
        chatController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetUser(
        msg: chatController.text,
        chosenModel: modelsProvider.getCurrentModel,
      );

      setState(() {});
    } catch (e) {
      log('Error $e');
    } finally {
      scrollListToEnd();
      setState(() {
        isTyping = false;
      });
    }
  }
}
