import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scoreflash/utils/match.dart';


class MatchesAPI {
  List<Match> parseMatches(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Match>((json) => Match.fromJson(json)).toList();
  }

  Future<List<Match>> fetchMatches(http.Client client) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('round');
    int round = (prefs.getInt('round') ?? 1);
    final response = await client
        .get(Uri.parse('https://api.openligadb.de/getmatchdata/bl1/2023/$round'));
    return parseMatches(response.body);
  }
}