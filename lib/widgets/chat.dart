import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/widgets/messages.dart';

import '../utils/controllers.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final AppController controller = Get.put(AppController());

  // final Stream<QuerySnapshot>  _messagesStream = FirebaseFirestore.instance.collection("messages").where("id", isEqualTo: "${controller.getCurrentHomeTeam()}-${controller.getCurrentAwayTeam()}").snapshots();

  @override
  void initState() {
    super.initState();
  }

  


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getMessageStream(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          shrinkWrap: true,
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  var data = document.data()! as Map<String, dynamic>;
                  return Messages(messages: data['messages']);
                })
                .toList()
                .cast());
      },
    );
  }
}
