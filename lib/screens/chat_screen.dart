import 'package:chat_app/components/chat_bubble_list_view.dart';
import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static String id = "ChatScreen";

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text(
              "Chat",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: ChatBubbleListView(
        email: email,
      ),
    );
  }
}
