import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  // ----------------- PRIVATE STORAGE HELPERS -----------------
  Future<void> _saveUserToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', _isAuthenticated);
    await prefs.setString('userId', _userId ?? '');
    await prefs.setString('userEmail', _userEmail ?? '');
    await prefs.setString('userName', _userName ?? '');
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userId = prefs.getString('userId');
    _userEmail = prefs.getString('userEmail');
    _userName = prefs.getString('userName');
    notifyListeners();
  }

  // ----------------- AUTH METHODS -----------------

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email.contains('@') && password.length >= 6) {
        _isAuthenticated = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        _userName = email.split('@').first;
        await _saveUserToStorage();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUp(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = name;
      await _saveUserToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    await _clearStorage();
    notifyListeners();
  }

  // Social login (mock)
  Future<bool> signInWithSocial(String provider) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      _userId = 'social_${provider}_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = 'user@$provider.com';
      _userName = 'Social User ($provider)';
      await _saveUserToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      print('$provider sign-in error: $e');
      return false;
    }
  }

  // Check auth status on app start
  Future<bool> checkAuthStatus() async {
    await loadUserFromStorage();
    return _isAuthenticated;
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return email.contains('@');
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }
}
