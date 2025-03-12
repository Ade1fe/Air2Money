import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      

      if (email.contains('@') && password.length >= 6) {
        _isAuthenticated = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        _userName = email.split('@').first;
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
      // TODO: Implement actual registration with your backend
      await Future.delayed(const Duration(seconds: 1)); // Simulate network request
      
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = name;
      notifyListeners();
      return true;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    // TODO: Implement actual sign out with your backend
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network request
    
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }
  
  // Check if user is authenticated (e.g., on app start)
  Future<bool> checkAuthStatus() async {
    // TODO: Implement actual auth check with your backend
    // This could involve checking for a valid token in secure storage
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate check
    
    // For demo purposes, we'll return the current auth state
    return _isAuthenticated;
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      // TODO: Implement actual password reset with your backend
      await Future.delayed(const Duration(seconds: 1)); // Simulate network request
      
      // For demo purposes, we'll accept any email with a valid format
      if (email.contains('@')) {
        return true;
      }
      return false;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }
}