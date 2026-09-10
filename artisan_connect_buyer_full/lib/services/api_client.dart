import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown when the API returns success:false or a non-2xx status.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

/// Centralized API client for all backend communication.
/// Reads base URL from the --dart-define API_BASE_URL compile flag
/// (default: http://10.0.2.2:3000 for Android emulator;
///           http://localhost:3000 for web/desktop).
class ApiClient {
  static const _baseUrlDefault = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://sih26090-artisan-marketplace.onrender.com',
  );

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final String baseUrl = _baseUrlDefault.replaceFirst(RegExp(r'/$'), '');
  final http.Client _http = http.Client();

  // ── Token storage ────────────────────────────────────────────────────────

  String? _token;
  Map<String, dynamic>? _currentUser;

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = jsonDecode(userJson) as Map<String, dynamic>;
    }
  }

  Future<void> saveSession(String token, Map<String, dynamic> user) async {
    _token = token;
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('current_user', jsonEncode(user));
  }

  Future<void> clearSession() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('current_user');
  }

  // ── HTTP helpers ─────────────────────────────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Map<String, String> get authHeaders => {
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Map<String, dynamic> _unwrap(http.Response response) {
    late Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Invalid response from server.',
          statusCode: response.statusCode);
    }
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw ApiException(
        body['message'] as String? ??
            'Request failed (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
    return body['data'] as Map<String, dynamic>? ?? body;
  }

  dynamic _unwrapList(http.Response response) {
    late Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Invalid response from server.',
          statusCode: response.statusCode);
    }
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw ApiException(
        body['message'] as String? ??
            'Request failed (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
    return body['data'];
  }

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await _http
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _unwrap(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server. Check your connection.');
    }
  }

  Future<dynamic> getList(String path) async {
    try {
      final response = await _http
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _unwrapList(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server. Check your connection.');
    }
  }

  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    try {
      final response = await _http
          .post(Uri.parse('$baseUrl$path'),
              headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
      return _unwrap(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server. Check your connection.');
    }
  }

  Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> body) async {
    try {
      final response = await _http
          .put(Uri.parse('$baseUrl$path'),
              headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
      return _unwrap(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server. Check your connection.');
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await _http
          .delete(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      _unwrap(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server. Check your connection.');
    }
  }
}
