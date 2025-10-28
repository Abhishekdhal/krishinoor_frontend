// lib/services/api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart'; // For kBaseUrl

// --- TOKEN MANAGEMENT ---
const _storage = FlutterSecureStorage();
const String _kTokenKey = 'jwt_token';
const String _kUserEmailKey = 'user_email';

Future<String?> _getToken() => _storage.read(key: _kTokenKey);
Future<void> _saveToken(String token) => _storage.write(key: _kTokenKey, value: token);
Future<void> _deleteToken() => _storage.delete(key: _kTokenKey);

// --- API ENDPOINTS ---
const String _kRegisterEndpoint = '/api/auth/register';
const String _kLoginEndpoint = '/api/auth/login';
const String _kLogoutEndpoint = '/api/auth/logout';
const String _kUserProfileEndpoint = '/api/auth/me';
const String _kUpdateProfileEndpoint = '/api/auth/update';
const String _kAddFeedbackEndpoint = '/api/feedback';
const String _kGetFeedbackEndpoint = '/api/feedback/list';
const String _kReportProblemEndpoint = '/api/problem'; // ✅ Correct route

class ApiService {
  final String _baseUrl = kBaseUrl ?? 'https://krishinoor-backend.vercel.app';

  // --- PRIVATE HELPERS ---
  Future<http.Response> _authenticatedGet(String endpoint) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthenticated: No token found.');

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      await _deleteToken();
      await _storage.delete(key: _kUserEmailKey);
      throw Exception('Session expired. Please log in again.');
    }
    return response;
  }

  Future<http.Response> _authenticatedPost(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthenticated: No token found.');

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      await _deleteToken();
      await _storage.delete(key: _kUserEmailKey);
      throw Exception('Session expired. Please log in again.');
    }
    return response;
  }

  Future<http.Response> _authenticatedPut(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthenticated: No token found.');

    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      await _deleteToken();
      await _storage.delete(key: _kUserEmailKey);
      throw Exception('Session expired. Please log in again.');
    }
    return response;
  }

  // --- AUTH ---
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String language,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_kRegisterEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'language': language,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final token = data['token'] as String?;
      final userEmail = data['user']?['email'] as String?;
      if (token != null && userEmail != null) {
        await _saveToken(token);
        await _storage.write(key: _kUserEmailKey, value: userEmail);
      } else {
        throw Exception('Registration failed: No token received.');
      }
    } else {
      throw Exception(data['message'] ?? 'Registration failed.');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_kLoginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'] as String?;
        final userEmail = data['user']?['email'] as String?;
        if (token != null && userEmail != null) {
          await _saveToken(token);
          await _storage.write(key: _kUserEmailKey, value: userEmail);
        } else {
          throw Exception('Login failed: No token received.');
        }
      } else {
        throw Exception(data['message'] ?? 'Login failed.');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _authenticatedPost(_kLogoutEndpoint, {});
    } catch (_) {}
    await _deleteToken();
    await _storage.delete(key: _kUserEmailKey);
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final response = await _authenticatedGet(_kUserProfileEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] is Map<String, dynamic>) {
        return data['user'];
      } else {
        throw const FormatException('Invalid profile data format.');
      }
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch profile.');
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String language,
  }) async {
    final body = {'name': name, 'phone': phone, 'language': language};

    final response = await _authenticatedPut(_kUpdateProfileEndpoint, body);
    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to update profile.');
    }
  }

  // --- UPLOAD ---
  Future<String> uploadImage(File imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthenticated: No token found.');

    // This endpoint is a reasonable guess. The backend needs a matching route.
    const String uploadEndpoint = '/api/upload';

    final uri = Uri.parse('$_baseUrl$uploadEndpoint');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      final imageUrl = data['url'] as String?;
      if (imageUrl != null) {
        return imageUrl;
      } else {
        throw Exception('Image upload failed: URL not found in response.');
      }
    } else {
      debugPrint('❌ Failed to upload image: ${response.statusCode} ${response.body}');
      throw Exception('Failed to upload image (Status: ${response.statusCode})');
    }
  }

  // --- PROBLEM REPORTING (File or URL) ---
  Future<void> reportProblem({
    required String description,
    File? imageFile,
    String? imageUrl,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Unauthenticated: No token found.');

      final uri = Uri.parse('$_baseUrl$_kReportProblemEndpoint');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['text'] = description;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        request.fields['imageUrl'] = imageUrl;
      } else {
        throw Exception('Please provide an image file or a valid image URL.');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        debugPrint('✅ Problem submitted successfully');
      } else {
        debugPrint('❌ Failed: ${response.statusCode} ${response.body}');
        throw Exception('Failed to submit problem');
      }
    } catch (e) {
      throw Exception('Error reporting problem: $e');
    }
  }

  // --- FEEDBACK ---
  Future<void> addFeedback(String name, String message, {String? imageUrl}) async {
    final body = {
      'name': name,
      'message': message,
      if (imageUrl != null) 'image_url': imageUrl,
    };

    final response = await _authenticatedPost(_kAddFeedbackEndpoint, body);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Server Error: ${response.body}");
    }
  }

  Stream<List<Map<String, dynamic>>> getFeedbackStream() {
    late StreamController<List<Map<String, dynamic>>> controller;
    Timer? timer;

    void fetchFeedback() async {
      try {
        final feedbackList = await getFeedbackOnce();
        if (!controller.isClosed) controller.add(feedbackList);
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    controller = StreamController<List<Map<String, dynamic>>>(
      onListen: () {
        fetchFeedback();
        timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchFeedback());
      },
      onCancel: () => timer?.cancel(),
    );

    return controller.stream;
  }

  Future<List<Map<String, dynamic>>> getFeedbackOnce() async {
    final response = await _authenticatedGet(_kGetFeedbackEndpoint);

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is List) {
        return List<Map<String, dynamic>>.from(decodedBody);
      } else {
        throw const FormatException("Invalid data format from server.");
      }
    } else {
      throw Exception("Server Error: ${response.statusCode} - ${response.body}");
    }
  }
}
