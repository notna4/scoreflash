import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoreflash/screens/game_screen.dart';
import 'package:scoreflash/utils/controllers.dart';

class MatchItem extends StatelessWidget {
  MatchItem({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    required this.homeLogo,
    required this.awayLogo,
  });

  final String homeTeam;
  final String awayTeam;

  final String dateTime;

  // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse();

  final String homeLogo;
  final String awayLogo;

  final AppController controller = Get.put(AppController());

  convertToHourMin(String time) {
    String convertedTime;
    convertedTime = DateTime.parse(time).toLocal().toString();

    return convertedTime.split(" ")[1].substring(0, 5);
  }

  convertToDate(String time) {
    String convertedTime;
    convertedTime = DateTime.parse(time).toLocal().toString();

    String aux = convertedTime.split(" ")[0].substring(0, 10);

    return "${aux.split("-")[2]}.${aux.split("-")[1]}.${aux.split("-")[0].substring(2, 4)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 100,
      child: ElevatedButton(
        onPressed: () {
          controller.addCurrentMatch(homeTeam, awayTeam, dateTime);
          // controller.initFirebase();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Obx(
                    () => IconButton(
                      onPressed: () {
                        controller.addToFavMatches(
                            homeTeam, awayTeam, dateTime);
                      },
                      icon: controller.isMatchFavM(homeTeam, awayTeam)
                          ? const Icon(Icons.favorite_rounded)
                          : const Icon(Icons.favorite_outline_rounded),
                      // icon: const Icon(Icons.favorite_rounded),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            homeTeam,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            awayTeam,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    convertToHourMin(dateTime),
                  ),
                  Text(
                    convertToDate(dateTime),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
