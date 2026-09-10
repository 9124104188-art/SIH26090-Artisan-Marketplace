import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  /// Login with email + password. Saves JWT on success.
  /// Returns the user map: { id, name, email, role, artisanId }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post('/api/auth/login', {
      'email': email.trim(),
      'password': password,
    });
    final token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;
    await _api.saveSession(token, user);
    return user;
  }

  /// Register a new user. Saves JWT on success.
  /// [craftType] and [location] are required when role == 'artisan'.
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? craftType,
    String? location,
  }) async {
    final body = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'role': role,
    };
    if (craftType != null && craftType.isNotEmpty) body['craftType'] = craftType.trim();
    if (location != null && location.isNotEmpty) body['location'] = location.trim();

    final data = await _api.post('/api/auth/register', body);
    final token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;
    await _api.saveSession(token, user);
    return user;
  }

  Future<void> logout() => _api.clearSession();

  bool get isLoggedIn => _api.isAuthenticated;
  Map<String, dynamic>? get currentUser => _api.currentUser;
  String? get userRole => _api.currentUser?['role'] as String?;
}
