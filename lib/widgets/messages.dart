import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/widgets/message_item.dart';

import '../utils/controllers.dart';

class Messages extends StatefulWidget {
  Messages({super.key, required this.messages});

  final messages;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final user = FirebaseAuth.instance.currentUser;
  final AppController controller = Get.put(AppController());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(milliseconds: 500),
        () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    return SingleChildScrollView(
      child: Container(
        // margin: const EdgeInsets.only(bottom: 600),
        margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
        // height: MediaQuery.of(context).size.height * 0.3,
        child: ListTile(
          title: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              reverse: false,
              controller: _scrollController,
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                return MessageItem(
                  message: widget.messages[index]['message'],
                  sender: widget.messages[index]['sender'],
                  prevSender: index > 0 ? widget.messages[index-1]['sender'] : "null"
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
