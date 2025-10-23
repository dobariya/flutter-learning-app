import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import 'storage_service.dart';

class ApiService {
  // Change this to your local IP or deployed API URL
  // For Android Emulator: http://10.0.2.2:5000
  // For iOS Simulator: http://localhost:5000
  // For Physical Device: http://YOUR_LOCAL_IP:5000
  static const String baseUrl = 'http://localhost:5000/api/auth';

  final StorageService _storageService = StorageService();

  // Register user
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(responseData);

      // Save token if successful
      if (authResponse.success && authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  // Login user
  Future<AuthResponse> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usernameOrEmail': usernameOrEmail,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(responseData);

      // Save token if successful
      if (authResponse.success && authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  // Validate token
  Future<AuthResponse> validateToken() async {
    try {
      final token = await _storageService.getToken();

      if (token == null || token.isEmpty) {
        return AuthResponse(
          success: false,
          message: 'No token found',
        );
      }

      final response = await http.post(
        Uri.parse('$baseUrl/validate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(responseData);

      // Delete token if invalid
      if (!authResponse.success) {
        await _storageService.deleteToken();
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Validation error: ${e.toString()}',
      );
    }
  }

  // Login with existing token (auto-login)
  Future<AuthResponse> loginWithToken() async {
    try {
      final token = await _storageService.getToken();

      if (token == null || token.isEmpty) {
        return AuthResponse(
          success: false,
          message: 'No token found',
        );
      }

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(responseData);

      // Delete token if invalid
      if (!authResponse.success) {
        await _storageService.deleteToken();
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Auto-login error: ${e.toString()}',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  // Get protected profile data (example)
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storageService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('${baseUrl.replaceAll('/auth', '')}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Profile error: ${e.toString()}');
    }
  }
}
