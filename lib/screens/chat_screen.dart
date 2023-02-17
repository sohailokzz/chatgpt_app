import 'package:chatgpt_app/constants/constants.dart';
import 'package:chatgpt_app/services/assets_manager.dart';
import 'package:chatgpt_app/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = true;

  late TextEditingController chatController;

  @override
  void initState() {
    chatController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    chatIndex: int.parse(
                      chatMessages[index]["chatIndex"].toString(),
                    ),
                    msg: chatMessages[index]["msg"].toString(),
                  );
                },
              ),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
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
                          onSubmitted: (value) {
                            // TODO here
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
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
