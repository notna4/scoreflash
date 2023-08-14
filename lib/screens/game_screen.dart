// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/widgets/chat.dart';

import '../utils/controllers.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AppController controller = Get.put(AppController());

  late ConfettiController _controllerConfetti;

  @override
  void initState() {
    super.initState();
    _controllerConfetti =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _controllerConfetti.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  final TextEditingController _textController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final user = FirebaseAuth.instance.currentUser;
  var docId;

  sendMessage(int goal) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("messages")
        .where("id",
            isEqualTo:
                "${controller.currentMatch[0][0]}-${controller.currentMatch[0][1]}")
        .get();

    if (snap.size > 0) {
      DocumentSnapshot docSnap = snap.docs.first;
      String docId = docSnap.id;

      FirebaseFirestore.instance
          .collection("messages")
          .doc(docId)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        var matchId = data['id'];
        var messageList = [];
        for (var item in data['messages']) {
          messageList.add(item);
        }
        messageList.add({
          "sender": user?.displayName,
          "message": goal == 1 ? "⚽⚽⚽" : _textController.text
        });
        _textController.text = "";

        FirebaseFirestore.instance
            .collection("messages")
            .doc(docId)
            .set({"id": matchId, "messages": messageList});
      });
    } else {
      FirebaseFirestore.instance.collection("messages").doc().set({
        "id":
            "${controller.currentMatch[0][0]}-${controller.currentMatch[0][1]}",
        "messages": FieldValue.arrayUnion([
          {
            "sender": user?.displayName,
            "message": goal == 1 ? "⚽⚽⚽" : _textController.text
          }
        ])
      });
    }

    // _textController.text = "";
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${controller.currentMatch[0][0]}-${controller.currentMatch[0][1]}"),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerConfetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar,
              ),
            ),
            const Expanded(
              child: Chat(),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18.0),
                        hintText: "Write a message",
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.sports_soccer_rounded),
                          onPressed: () {
                            sendMessage(1);
                            // print("GOL");
                            _controllerConfetti.play();
                            _textController.text = "";
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 16, 13, 150))),
                          onPressed: () {
                            sendMessage(0);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: Container(
        //   padding: MediaQuery.of(context).viewInsets,
        //   color: Colors.blue,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 2),
        //     margin: EdgeInsets.symmetric(horizontal: 5),
        //     child: TextField(
        //       controller: _textController,
        //       focusNode: _focusNode,
        //       keyboardType: TextInputType.text,
        //       textInputAction: TextInputAction.done,
        //       textAlignVertical: TextAlignVertical.center,
        //       decoration: InputDecoration(
        //         contentPadding: const EdgeInsets.all(18.0),
        //         hintText: "Write a message",
        //         prefixIcon: IconButton(
        //           icon: const Icon(Icons.sports_soccer_rounded),
        //           onPressed: () {
        //             sendMessage(1);
        //             // print("GOL");
        //             _controllerConfetti.play();
        //             _textController.text = "";
        //           },
        //         ),
        //         suffixIcon: IconButton(
        //           icon: const Icon(Icons.send_rounded),
        //           style: ButtonStyle(
        //               foregroundColor: MaterialStateProperty.all(
        //                   Color.fromARGB(255, 16, 13, 150))),
        //           onPressed: () {
        //             sendMessage(0);
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
