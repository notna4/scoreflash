import 'package:flutter/material.dart';
import 'package:scoreflash/utils/match.dart';
import 'package:scoreflash/widgets/match_item.dart';

class MatchesList extends StatelessWidget {
  const MatchesList({super.key, required this.matches, required this.round});

  final List<Match> matches;
  final int round;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return MatchItem(
                  homeTeam: matches[index].homeTeam,
                  awayTeam: matches[index].awayTeam,
                  dateTime: matches[index].matchDateTime,
                  homeLogo: matches[index].homeTeamLogo,
                  awayLogo: matches[index].awayTeamLogo,
                );
                // return Text(
                //     matches[index].homeTeam + ' - ' + matches[index].awayTeam);
              },
            ),
          ),
        ),
      ],
    );
  }
}
