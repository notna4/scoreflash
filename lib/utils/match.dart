

class Match {
  final int matchID;
  final String matchDateTime; // standard europe time

  final String homeTeam;
  final String awayTeam;

  final String homeTeamLogo;
  final String awayTeamLogo;

  const Match({
    required this.matchID,
    required this.matchDateTime,

    required this.homeTeam,
    required this.awayTeam,

    required this.homeTeamLogo,
    required this.awayTeamLogo,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchID: json['matchID'],
      matchDateTime: json['matchDateTimeUTC'],

      homeTeam: json['team1']['shortName'],
      awayTeam: json['team2']['shortName'],

      homeTeamLogo: json['team1']['teamIconUrl'],
      awayTeamLogo: json['team2']['teamIconUrl']
    );
  }
}