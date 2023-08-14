import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {

  var homeTeam;
  var awayTeam;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var db = FirebaseFirestore.instance;

    db.collection("games").doc("$homeTeam-$awayTeam");

    final docRef = db.collection("games").doc("$homeTeam-$awayTeam");

    docRef.snapshots().listen(
      (event) => print("current games: ${event.data()}"),
      onError: (error) => print("Listen failed: $error"),
    );
  }

  ChatController(String this.homeTeam, String this.awayTeam);
}