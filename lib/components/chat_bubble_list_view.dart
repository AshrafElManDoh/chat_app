import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubbleListView extends StatelessWidget {
  ChatBubbleListView({super.key, required this.email});
  final String email;
  TextEditingController controller = TextEditingController();

  CollectionReference message =
      FirebaseFirestore.instance.collection('messages');

  final scontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: message.orderBy("createdAt",descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                    controller: scontroller,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return messageList[index].id == email? ChatBubble(
                        message: messageList[index],
                      ) :ChatBubbleForFriend(message: messageList[index]) ;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Send message",
                      suffixIcon: IconButton(
                        onPressed: () {
                          message.add({
                            "message": controller.text,
                            "createdAt": DateTime.now(),
                            "id":email 
                          });
                          controller.clear();
                          scontroller.animateTo(
                              0,
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
