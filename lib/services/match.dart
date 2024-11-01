import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../models/match.dart';

class MatchService {
  static final String apiKey = '45c83592e7f04467191a0e8ce02ac7a7';
  static String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  static final String apiUrl = 'https://v3.football.api-sports.io/fixtures?date=$todayDate';
  static final String cacheKey = 'cachedFootballMatches';
  static final Duration cacheExpiry = const Duration(hours: 4);

  // Main function to get matches, checking cache first
  static Future<List<Match>> getMatches() async {
    List<Match>? cachedMatches = await _getCachedMatches();

    if (cachedMatches != null) {
      // If cache exists and is valid, return cached matches
      return cachedMatches;
    } else {
      // If cache is expired or doesn't exist, fetch from API
      return await _fetchMatchesFromApi();
    }
  }

  // Function to retrieve matches from the cache
  static Future<List<Match>?> _getCachedMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(cacheKey);


    if (cachedData != null) {      
      final Map<String, dynamic> decodedCache = jsonDecode(cachedData);
      final DateTime cachedTime = DateTime.parse(decodedCache['timestamp']);

      // Check if the cache is still valid
      if (DateTime.now().difference(cachedTime) < cacheExpiry) {
        final List<dynamic> cachedMatchesJson = decodedCache['matches'];
        // Convert JSON back to a list of Match objects
        return cachedMatchesJson.map((json) => Match.fromJson(json)).toList();
      } else {
        // Cache expired, remove it
        await prefs.remove(cacheKey);
      }
    }
    return null;
  }

  // Function to save matches to the cache
  static Future<void> _setCachedMatches(List<Match> matches) async {
    final prefs = await SharedPreferences.getInstance();
    // Prepare the data to cache
    final Map<String, dynamic> dataToCache = {
      'timestamp': DateTime.now().toIso8601String(),
      'matches': matches.map((m) => m.toJson()).toList(),
    };
    prefs.setString(cacheKey, jsonEncode(dataToCache));
  }

  // Function to fetch matches from the API
  static Future<List<Match>> _fetchMatchesFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'v3.football.api-sports.io',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> fixtures = data['response'];

        if (fixtures.isNotEmpty) {
          // Convert the API response into a list of Match objects
          List<Match> matches =
              fixtures.map((json) => Match.fromJson(json)).toList();

          // Cache the important matches
          await _setCachedMatches(matches);
          return matches;
        }
      } else {
        throw Exception('Une erreur s\'est produite. Veuillez réessayer plus tard.');
      }
    } catch (error) {
      developer.log('Error fetching matches: $error');
      return [];
    }
    return [];
  }
}
