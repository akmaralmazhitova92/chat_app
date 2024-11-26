import 'dart:developer';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_text_styles.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/views/landing_view.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final String email;
  final String userId;
  const ChatView({super.key, required this.email, required this.userId});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.amberAccent,
        title: const Text('Chats'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const LandingView()),
                  );
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<List<ChatModel>>(
              stream: streamChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred'),
                  );
                }

                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ChatModel chat = snapshot.data![index];
                        bool isMe = chat.senderId == widget.userId;
                        return _messages(chat, isMe);
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text('No chats yet'),
                );
              }),
          Align(
            widthFactor: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 12, bottom: 32),
              decoration: const BoxDecoration(
                color: AppColors.amberAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      hintText: 'your message',
                      controller: controller,
                      onChanged: (val) {
                        log('val $val');
                      },
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await send();
                    },
                    label: const Icon(
                      Icons.send,
                      size: 34,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messages(ChatModel chat, bool isMe) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 4, bottom: 4, right: isMe ? 8 : 0, left: isMe ? 0 : 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.black.withOpacity(0.5) : AppColors.orangeDark,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Text(
              chat.message,
              style: AppTextStyles.font18,
            ),
          ),
        ),
      ],
    );
  }
    Future<void> send() async {
    log('controller.text ${controller.text}');
    ChatModel chat = ChatModel(
        id: widget.userId,
        message: controller.text,
        senderEmail: widget.email,
        senderId: widget.userId,
        time: Timestamp.now());

    await FirebaseFirestore.instance.collection('chats').add(chat.toJson());

    controller.clear();
  }

  Stream<List<ChatModel>> streamChats() {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots();

      return snapshots.map(
        (event) => event.docs
            .map(
              (data) => ChatModel.fromJson(data.data()),
            )
            .toList(),
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}

  ////Future danniydi bir jolu alip kelet; with get
  ////Stream bolso kayra kayra danniy alip kelet; with snapshots