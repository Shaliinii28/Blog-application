import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogger_frontend/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  void _register() async {
	try {
		await Provider.of<AuthProvider>(context, listen: false)
			.register(
				_usernameController.text,
				_emailController.text,
				_passwordController.text);
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
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Container(
          width: isWide ? 400 : double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController, // Fixed: Changed 'suffrage' to 'controller'
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
                onPressed: _register,
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}