import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  var favMatches = {}.obs;
  var removedMatch = {}.obs;
  var currentMatch = [].obs;
  var messages = [].obs;
  var docID = [].obs;
  var db;

  currentDocID(String id) {
    if (docID.isEmpty) {
      docID.add([id]);
    } else {
      docID[0] = [id];
    }
  }

  RxBool isBottomOpen = false.obs;

  late Stream<QuerySnapshot> _messagesStream;

  getCurrentHomeTeam() {
    return currentMatch[0][1];
  }

  getCurrentAwayTeam() {
    return currentMatch[0][1];
  }

  getMessageStream() {

    if (currentMatch.isNotEmpty) {
      _messagesStream = FirebaseFirestore.instance
          .collection("messages")
          .where("id", isEqualTo: "${currentMatch[0][0]}-${currentMatch[0][1]}")
          .snapshots();
    } else {
      _messagesStream =
          FirebaseFirestore.instance.collection("messages").snapshots();
    }

    return _messagesStream;
  }

  @override
  void onInit() {
    super.onInit();
    getSharedData();

    db = FirebaseFirestore.instance;
    initFirebase();
  }

  initFirebase() {
    if (currentMatch.isNotEmpty) {
      _messagesStream = FirebaseFirestore.instance
          .collection("messages")
          .where("id", isEqualTo: "${currentMatch[0][0]}-${currentMatch[0][1]}")
          .snapshots();
    } else {
      _messagesStream =
          FirebaseFirestore.instance.collection("messages").snapshots();
    }
  }

  deleteThisMessage(String themessage) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("messages")
        .where("id",
            isEqualTo:
                "${currentMatch[0][0]}-${currentMatch[0][1]}")
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
          if (item['message'] != themessage) {
            messageList.add(item);
          }
        }

        FirebaseFirestore.instance.collection("messages").doc(docId).set({
          "id": matchId,
          "messages": messageList
        });
      });
    }
  }

  getSharedData() async {
    final prefs = await SharedPreferences.getInstance();

    // prefs.remove("favMatches");

    if (prefs.getStringList("favMatches") != null) {
      List<String> matches = prefs.getStringList("favMatches")!;
      print(matches);
      for (var match in matches) {
        print(match);
        addToFavMatches(
            match.split(',')[0], match.split(',')[1], match.split(',')[2]);
      }
    }
  }

  savePrefs(String ht, String at, String date) async {
    final prefs = await SharedPreferences.getInstance();

    String s = "$ht,$at,$date";

    final oldList = prefs.getStringList("favMatches");

    if (oldList == null) {
      await prefs.setStringList("favMatches", [s]);
    } else {
      oldList.add(s);
      await prefs.setStringList("favMatches", oldList);
    }
    print(prefs.getStringList("favMatches"));
  }

  removePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("favMatches");

    List<String> newList = [];
    for (var match in favMatches.values) {
      // print(favMatches[key]);
      String s =
          match["homeTeam"] + "," + match["awayTeam"] + "," + match["dateTime"];
      newList.add(s);
    }
    // print("list");
    // print(newList);

    // if (newList.isEmpty) {
    //   print("removing");
    //   await prefs.remove("favMatches");
    // }
    // else {
    //   await prefs.remove("favMatches");
    // }
    await prefs.setStringList("favMatches", newList);
    print(prefs.getStringList("favMatches"));
  }

  addCurrentMatch(String homeTeam, String awayTeam, String dateTime) {
    if (currentMatch.isEmpty) {
      currentMatch.add([homeTeam, awayTeam, dateTime]);
    } else {
      currentMatch[0] = [homeTeam, awayTeam, dateTime];
    }
  }

  addToRemovedMatch(String homeTeam, String awayTeam, String dateTime) {
    if (removedMatch.containsKey("$homeTeam,$awayTeam")) {
      removedMatch.remove("$homeTeam,$awayTeam");
    } else {
      removedMatch["$homeTeam,$awayTeam"] = {
        "homeTeam": homeTeam,
        "awayTeam": awayTeam,
        "dateTime": dateTime
      };
    }
  }

  addToFavMatches(String homeTeam, String awayTeam, String dateTime) {
    if (favMatches.containsKey("$homeTeam,$awayTeam")) {
      favMatches.remove("$homeTeam,$awayTeam");
      removePrefs();
    } else {
      savePrefs(homeTeam, awayTeam, dateTime);
      favMatches["$homeTeam,$awayTeam"] = {
        "homeTeam": homeTeam,
        "awayTeam": awayTeam,
        "dateTime": dateTime
      };
    }
  }

  isMatchFavM(String homeTeam, String awayTeam) {
    if (favMatches.containsKey("$homeTeam,$awayTeam")) {
      return true;
    } else {
      return false;
    }
  }
}
