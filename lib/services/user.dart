import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:developer' as developer;

class UserService {
  static const String baseUrl = 'https://king-power-recharges.com/api';

  // Login method (POST /login)
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Store the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  // Register method (POST /register)
  static Future<http.Response> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'tel_user': user.telUser,
          'password':
              user.password, // Include password in the registration body
          'statut_user': 'Client'
        }),
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Fetch user profile (GET /getMyProfil)
  static Future<User?> getMyProfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Veuillez vous connecter");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/getMyProfilApi'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        developer.log(data.toString());
        throw Exception('Impossible de charger le profil utilisateur');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Update user profile (PATCH /updateClientProfile)
  static Future<http.Response> updateClientProfile(User updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("token_not_found");
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/updateClientProfileApi'),
        headers: {
          'Authorization': 'Bearer $token', // Set the Authorization header
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedUser.toJson()), // Convert updated user to JSON
      );
      return response;
    } catch (error) {
      developer.log('Error updating user profile: $error');
      rethrow;
    }
  }

  // Logout method (optional - clears token)
  static Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      developer.log(response.body.toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', '');
    } catch (e) {
      rethrow;
    }
  }
}
