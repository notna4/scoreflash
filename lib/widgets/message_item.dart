import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:emojis/emoji.dart';

import '../utils/controllers.dart';

class MessageItem extends StatefulWidget {
  MessageItem(
      {super.key,
      required this.message,
      required this.sender,
      required this.prevSender});
  final String message;
  final String sender;
  final String prevSender;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final user = FirebaseAuth.instance.currentUser;
  final AppController controller = Get.put(AppController());


  Color messageColor = Colors.blue;

  final emoji = Emoji.byKeyword(";)");

  String computeMessage(String message) {
    // "dap :)"
    // dap :
    String newMessage = message[0];
    for (int i = 1; i < message.length; i++) {
      if (message[i-1] == ":" || message[i-1] == ";") {
        final em = Emoji.byKeyword(message.substring(i-1, i+1)); 
        if (em.isNotEmpty) {
          newMessage = newMessage.substring(0, newMessage.length-1);
          newMessage += em.first.toString();
        }
        else {
          newMessage += message[i];
        }
      }
      else {
        newMessage += message[i];
      }
    }

    return newMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: widget.sender == user?.displayName
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (widget.prevSender != widget.sender)
          Padding(
            padding: const EdgeInsets.only(right: 14, bottom: 4, left: 14),
            child: Text(
              widget.sender,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          )
        else
          const Text("", style: TextStyle(fontSize: 1)),
        GestureDetector(
          onLongPress: () {
            setState(() {
              messageColor = Color.fromARGB(255, 17, 89, 148);
            });
            if (widget.sender == user?.displayName) {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Do you want to delete this message?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  controller.deleteThisMessage(widget.message);
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Color.fromARGB(255, 97, 97, 97)),
                                ),
                                child: const Text('No', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).whenComplete(() {
                setState(() {
                  messageColor = Colors.blue;
                });
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: !computeMessage(widget.message).contains(RegExp('^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+\$')) ? BoxDecoration(
              color: widget.sender == user?.displayName
                  ? messageColor
                  : Color.fromARGB(255, 161, 161, 161),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ) : null,
            child: Text(
              computeMessage(widget.message),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: !computeMessage(widget.message).contains(RegExp('^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+\$')) ? 16 : 26,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
