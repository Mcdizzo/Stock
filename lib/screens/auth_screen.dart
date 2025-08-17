import 'package:flutter/material.dart';
import '../controllers/auth_contoller.dart';

class AuthScreen extends StatefulWidget {
  final AuthController authController;

  const AuthScreen({Key? key, required this.authController}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    bool success = false;
    if (_isLogin) {
      success = await widget.authController.login(_email, _password);
      if (success) {
        // Navigate to Home screen on login success
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _showError(widget.authController.errorMessage ?? 'Login failed');
      }
    } else {
      if (_password != _confirmPassword) {
        _showError('Passwords do not match');
        return;
      }
      success = await widget.authController.signup(_email, _password);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Signup successful! Please login after confirming email.',
          ),
        ),
      );
      // Switch to login mode after signup success
      setState(() {
        _isLogin = true;
      });
    } else {
      _showError(widget.authController.errorMessage ?? 'Signup failed');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(val)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (val) => _email = val ?? '',
                      ),
                      SizedBox(height: 16),
                      // Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter password';
                          }
                          if (val.length < 6) {
                            return 'Password must be at least 6 chars';
                          }
                          return null;
                        },
                        onChanged: (val) => _password = val,
                      ),
                      SizedBox(height: 16),
                      // Confirm password only for signup
                      if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (val) {
                            if (!_isLogin) {
                              if (val == null || val.isEmpty) {
                                return 'Confirm your password';
                              }
                              if (val != _password) {
                                return 'Passwords do not match';
                              }
                            }
                            return null;
                          },
                          onSaved: (val) => _confirmPassword = val ?? '',
                        ),
                      SizedBox(height: 24),

                      if (widget.authController.isLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submit,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 32,
                            ),
                            child: Text(
                              _isLogin ? 'Login' : 'Sign Up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),

                      TextButton(
                        onPressed: widget.authController.isLoading
                            ? null
                            : _toggleMode,
                        child: Text(
                          _isLogin
                              ? "Don't have an account? Sign up"
                              : "Already have an account? Login",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
