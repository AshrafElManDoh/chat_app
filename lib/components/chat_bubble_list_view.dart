import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBubbleListView extends StatelessWidget {
  ChatBubbleListView({super.key, required this.email});
  final String email;
  TextEditingController controller = TextEditingController();
  final scontroller = ScrollController();
  List<MessageModel> messageList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatSuccess) {
                messageList = state.messageList;
              }
            },
            builder: (context, state) {
              return ListView.builder(
                  reverse: true,
                  controller: scontroller,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return messageList[index].id == email
                        ? ChatBubble(
                            message: messageList[index],
                          )
                        : ChatBubbleForFriend(message: messageList[index]);
                  });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: "Send message",
                suffixIcon: IconButton(
                  onPressed: () {
                    BlocProvider.of<ChatCubit>(context)
                        .sendMessage(message: controller.text, email: email);
                    controller.clear();
                    BlocProvider.of<ChatCubit>(context).receiveMessages();
                    scontroller.animateTo(0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: kPrimaryColor,
                    ))),
          ),
        )
      ],
    );
  }
}
