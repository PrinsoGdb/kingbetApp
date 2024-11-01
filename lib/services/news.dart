import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news.dart'; // Import the News model
import 'dart:developer' as developer;

class NewsService {
  static final String apiKey = 'cccdd3c7ca963226a3bf12ade44654ac';
  static final String apiUrl ='https://gnews.io/api/v4/top-headlines?topic=sports&lang=fr&country=fr&token=';
  static final String cacheKey = 'cachedGnewsArticles';
  static final Duration cacheExpiry = const Duration(hours: 4); 

  // Main function to get news, checking cache first
  static Future<List<News>> getNews() async {
    List<News>? cachedNews = await _getCachedNews();

    if (cachedNews != null) {
      // If cache exists and is valid, return cached news
      return cachedNews;
    } else {
      // If cache is expired or doesn't exist, fetch from API
      return await _fetchNewsFromApi();
    }
  }

  // Function to retrieve news from the cache
  static Future<List<News>?> _getCachedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      final Map<String, dynamic> decodedCache = jsonDecode(cachedData);
      final DateTime cachedTime = DateTime.parse(decodedCache['timestamp']);

      // Check if the cache is still valid
      if (DateTime.now().difference(cachedTime) < cacheExpiry) {
        final List<dynamic> cachedNewsJson = decodedCache['news'];
        // Convert JSON back to a list of News objects
        return cachedNewsJson.map((json) => News.fromJson(json)).toList();
      } else {
        // Cache expired, remove it
        await prefs.remove(cacheKey);
      }
    }
    return null;
  }

  // Function to save news to the cache
  static Future<void> _setCachedNews(List<News> newsList) async {
    final prefs = await SharedPreferences.getInstance();
    // Prepare the data to cache
    final Map<String, dynamic> dataToCache = {
      'timestamp': DateTime.now().toIso8601String(),
      'news': newsList.map((n) => n.toJson()).toList(),
    };
    prefs.setString(cacheKey, jsonEncode(dataToCache));
  }

  // Function to fetch news from the API
  static Future<List<News>> _fetchNewsFromApi() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl$apiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> articles = data['articles'];

        if (articles.isNotEmpty) {
          // Convert the API response into a list of News objects
          List<News> newsList =
              articles.map((json) => News.fromJson(json)).toList();

          // Cache the news articles
          await _setCachedNews(newsList);
          return newsList;
        }
      } else {
        throw Exception('Impossible de charger les actualités depuis l\'API');
      }
    } catch (error) {
      developer.log('Error fetching news: $error');
      return [];
    }
    return [];
  }
}
