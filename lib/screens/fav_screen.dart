import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/utils/controllers.dart';
import 'package:scoreflash/widgets/match_item.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final AppController controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.favMatches.length,
            itemBuilder: (context, index) {
              String key = controller.favMatches.keys.elementAt(index);
              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                direction: DismissDirection.endToStart,
                key: Key(key),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {

                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        controller.addToRemovedMatch(
                          controller.removedMatch[key]['homeTeam'],
                          controller.removedMatch[key]['awayTeam'],
                          controller.removedMatch[key]['dateTime'],
                        );
                      });
                    });

                    controller.addToRemovedMatch(
                      controller.favMatches[key]['homeTeam'],
                      controller.favMatches[key]['awayTeam'],
                      controller.favMatches[key]['dateTime'],
                    );
                    controller.favMatches.remove(key);
                  });


                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Row(
                        children: [
                          const Text('Match removed from favorites.'),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                controller.addToFavMatches(
                                    controller.removedMatch[key]['homeTeam'],
                                    controller.removedMatch[key]['awayTeam'],
                                    controller.removedMatch[key]['dateTime']);
                              });
                            },
                            child: const Text("Undo"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                // Show a red background as the item is swiped away.
                background: Container(
                  height: 20,
                  alignment: AlignmentDirectional.centerEnd,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: ListTile(
                  title: MatchItem(
                    homeTeam: controller.favMatches[key]['homeTeam'],
                    awayTeam: controller.favMatches[key]['awayTeam'],
                    dateTime: controller.favMatches[key]['dateTime'],
                    homeLogo: "",
                    awayLogo: "",
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
