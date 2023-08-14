import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/screens/fav_screen.dart';
import 'package:scoreflash/screens/register_screen.dart';
import 'package:scoreflash/utils/match.dart';
import 'package:scoreflash/utils/matches_api.dart';
import 'package:scoreflash/widgets/list_of_matches.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/controllers.dart';

int _round = 1;

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final _api = MatchesAPI();

  final AppController controller = Get.put(AppController());

  Route _routeToRegisterScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();
  }

  int _round = 1;

  getShared() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _round = prefs.getInt('round') ?? 1;
    });
  }

  goToFavorites() {
    print('go to favorites screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games for Round $_round'),
        // centerTitle: true,
        // leading: IconButton(onPressed: (){}, icon:const Icon(Icons.favorite_rounded)),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(_routeToRegisterScreen());
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 50,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                for (int i = 1; i <= 34; i++)
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt("round", i);
                        int round = (prefs.getInt('round') ?? 1);
                        _api.fetchMatches(http.Client());
                        setState(() {
                          _round = round;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: (_round == i)
                            ? MaterialStateProperty.all(
                                const Color.fromARGB(255, 39, 39, 39))
                            : MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        'Round ${i.toString()}',
                        style: TextStyle(
                            color: (_round == i)
                                ? Colors.white
                                : Colors.deepPurple),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.favMatches.isNotEmpty
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const FavScreen()),
                  );
                },
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_outline_rounded,
                          color: Colors.white),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          "${controller.favMatches.length} games ",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Text(''),
      ),
      body: FutureBuilder<List<Match>>(
        future: _api.fetchMatches(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return MatchesList(matches: snapshot.data!, round: _round);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
