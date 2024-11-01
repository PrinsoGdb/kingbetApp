import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/caisse.dart';
import 'dart:developer' as developer;

class CaisseService {
  static final String baseUrl = 'https://king-power-recharges.com/api';

  // Get caisse (GET /list_of_caisse)
  static Future<List<Caisse>> listOfCaisse() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("token_not_found");
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/list_of_caisse'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => Caisse.fromJson(json))
            .toList();
      } else {
        throw Exception('Une erreur s\'est produite. Veuillez réessayer plus tard.');
      }
    } catch (error) {
      developer.log('Error fetching caisses: $error');
      return [];
    }
  }
}
