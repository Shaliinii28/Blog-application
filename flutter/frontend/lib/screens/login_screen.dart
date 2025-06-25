import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogger_frontend/providers/auth_provider.dart'; // Corrected path

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  void _login() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_usernameController.text, _passwordController.text);
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Container(
          width: isWide ? 400 : double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(_error!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}