//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  bool isLoading = false;
  bool isLoggingOut = false;
  String? errorMessage;

  AuthController(this._authService);

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        return true;
      } else {
        errorMessage = 'Login failed';
        return false;
      }
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('email not confirmed')) {
        errorMessage = 'Email not confirmed. Please check your inbox.';
      } else {
        errorMessage = 'Login failed: ${e.toString()}';
      }
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> signup(String email, String password) async {
    _setLoading(true);
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signup(email, password);
      if (user != null) {
        return true;
      } else {
        errorMessage = 'Signup failed';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
  }

  Future<void> logout(BuildContext context) async {
    isLoggingOut = true;
    notifyListeners();

    try {
      await _authService.logout();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      isLoggingOut = false;
      notifyListeners();
    }
  }
}
