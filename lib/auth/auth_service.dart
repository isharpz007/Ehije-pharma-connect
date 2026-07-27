import 'package:supabase_flutter/supabase_flutter.dart';

/// Result of a login/sign-up attempt.
class AuthResult {
  final bool success;
  final String? errorMessage;
  const AuthResult({required this.success, this.errorMessage});
}

/// Talks to Supabase Auth for login/sign-up.
///
/// Supabase is initialized once in main.dart via Supabase.initialize(...).
/// This class just wraps the calls so the rest of the app (login_screen,
/// sign_up_screen, profile_screen) doesn't need to know anything about
/// Supabase directly — they only ever call AuthService.instance.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  bool get isLoggedIn => _client.auth.currentSession != null;

  /// Matches the shape the rest of the app expects: {name, email, phone}.
  /// name/phone come from the signup metadata (Supabase's built-in
  /// auth.users table only stores email/password natively).
  Map<String, dynamic>? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return {
      'id': user.id,
      'email': user.email ?? '',
      'name': user.userMetadata?['name'] as String? ?? '',
      'phone': user.userMetadata?['phone'] as String? ?? '',
    };
  }

  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(
        email: emailOrPhone,
        password: password,
      );
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (e) {
      return const AuthResult(
        success: false,
        errorMessage: 'Could not connect. Please check your internet connection and try again.',
      );
    }
  }

  Future<AuthResult> signUp({
    required String name,
    required String emailOrPhone,
    required String password,
    String? phone,
  }) async {
    try {
      await _client.auth.signUp(
        email: emailOrPhone,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (e) {
      return const AuthResult(
        success: false,
        errorMessage: 'Could not connect. Please check your internet connection and try again.',
      );
    }
  }

  Future<void> logOut() async {
    await _client.auth.signOut();
  }
}