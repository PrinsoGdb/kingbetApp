import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import 'dart:developer' as developer;

class TransactionService {
  static final String baseUrl = 'https://king-power-recharges.com/api';

  // Make a transaction operation (POST /make_operation_api)
  static Future<http.Response> makeOperation(Transaction transaction) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("token_not_found");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/make_operation_api'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(transaction.toJson()),
      );

      return response;
    } catch (error) {
      developer.log('Error during operation: $error');
      rethrow;
    }
  }

  // Get user's operations (GET /my_operations)
  static Future<List<Transaction>> myOperations(String bookmaker) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("token_not_found");
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/client_operations/${bookmaker.toLowerCase()}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      developer.log(response.body.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => Transaction.fromJson(json))
            .toList();
      } else {
        throw Exception('Une erreur s\'est produite. Veuillez réessayer plus tard.');
      }
    } catch (error) {
      developer.log('Error fetching operations: $error');
      return [];
    }
  }
}
