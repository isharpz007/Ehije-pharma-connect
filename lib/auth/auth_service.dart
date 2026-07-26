import 'dart:convert';
import 'package:http/http.dart' as http;

/// Result of a login/sign-up attempt.
class AuthResult {
  final bool success;
  final String? errorMessage;
  const AuthResult({required this.success, this.errorMessage});
}

/// Talks to your backend for authentication — OR simulates one, while
/// [useMockAuth] is true.
///
/// ── RIGHT NOW: MOCK MODE ──────────────────────────────────────────
/// There's no real backend yet, so [useMockAuth] is true. Every
/// login/sign-up just waits ~800ms (to feel like a real network call)
/// and then succeeds, EXCEPT for two deliberately-wired test cases so
/// you can see the error banner working:
///   • Login fails if the password is exactly "wrong"
///   • Sign up fails if the email is exactly "taken@example.com"
/// Try those to confirm error handling works, and anything else to
/// see the success path (navigates to HomeScreen).
///
/// ── WHEN YOUR REAL API IS READY ───────────────────────────────────
/// 1. Set [useMockAuth] to false.
/// 2. Set [baseUrl] to your actual API.
/// 3. Update the endpoint paths in [login] / [signUp] ('/auth/login',
///    '/auth/register') to match your API.
/// 4. Update the request body field names ('email', 'password',
///    'name') to match what your API expects.
/// 5. Update the response field names ('token', 'message', 'user') to
///    match what your API actually returns. Right now this assumes:
///      { "token": "...", "user": { ... } }         on success
///      { "message": "Invalid credentials" }         on failure
/// Nothing else in the app needs to change — every screen calls
/// AuthService.instance.login(...) / .signUp(...) the same way either
/// way.
/// ────────────────────────────────────────────────────────────────
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  /// Flip this to false once your real backend is ready.
  static const bool useMockAuth = false;

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  String? _token;
  Map<String, dynamic>? _currentUser;

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;

  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) {
    if (useMockAuth) {
      return _mockLogin(emailOrPhone: emailOrPhone, password: password);
    }
    return _realLogin(emailOrPhone: emailOrPhone, password: password);
  }

  Future<AuthResult> signUp({
    required String name,
    required String emailOrPhone,
    required String password,
  }) {
    if (useMockAuth) {
      return _mockSignUp(name: name, emailOrPhone: emailOrPhone, password: password);
    }
    return _realSignUp(name: name, emailOrPhone: emailOrPhone, password: password);
  }

  void logOut() {
    _token = null;
    _currentUser = null;
  }

  // ── MOCK IMPLEMENTATION ──────────────────────────────────────────

  Future<AuthResult> _mockLogin({
    required String emailOrPhone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (password == 'wrong') {
      return const AuthResult(success: false, errorMessage: 'Invalid email or password');
    }

    _token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    _currentUser = {'name': 'Test User', 'email': emailOrPhone};
    return const AuthResult(success: true);
  }

  Future<AuthResult> _mockSignUp({
    required String name,
    required String emailOrPhone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (emailOrPhone == 'taken@example.com') {
      return const AuthResult(success: false, errorMessage: 'An account with this email already exists');
    }

    _token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
    _currentUser = {'name': name, 'email': emailOrPhone};
    return const AuthResult(success: true);
  }

  // ── REAL IMPLEMENTATION (used once useMockAuth = false) ──────────

  Future<AuthResult> _realLogin({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailOrPhone,
          'password': password,
        }),
      );

      final body = _tryDecode(response.body);

      if (response.statusCode == 200) {
        _token = body?['token'] as String?;
        _currentUser = body?['user'] as Map<String, dynamic>?;
        return const AuthResult(success: true);
      }

      return AuthResult(
        success: false,
        errorMessage: body?['message'] as String? ?? 'Invalid email or password',
      );
    } catch (e) {
      return const AuthResult(
        success: false,
        errorMessage: 'Could not connect to the server. Please try again.',
      );
    }
  }

  Future<AuthResult> _realSignUp({
    required String name,
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': emailOrPhone,
          'password': password,
        }),
      );

      final body = _tryDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = body?['token'] as String?;
        _currentUser = body?['user'] as Map<String, dynamic>?;
        return const AuthResult(success: true);
      }

      return AuthResult(
        success: false,
        errorMessage: body?['message'] as String? ?? 'Could not create your account',
      );
    } catch (e) {
      return const AuthResult(
        success: false,
        errorMessage: 'Could not connect to the server. Please try again.',
      );
    }
  }

  Map<String, dynamic>? _tryDecode(String source) {
    if (source.isEmpty) return null;
    try {
      return jsonDecode(source) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}