import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  int? _userId;
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  int? get userId => _userId;

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access'];
      _userId = data['user_id'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setInt('userId', _userId!);
      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> register(String username, String email, String password) async {
	  final response = await http.post(
		Uri.parse('http://localhost:8000/api/register/'),
		headers: {'Content-Type': 'application/json'},
		body: jsonEncode({'username': username, 'email': email, 'password': password}),
	  );
	  print('Register response: ${response.statusCode} ${response.body}'); // Debug
	  if (response.statusCode == 201) {
		final data = jsonDecode(response.body);
		_token = data['access'];
		_userId = data['user_id'];
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString('token', _token!);
		await prefs.setInt('userId', _userId!);
		notifyListeners();
	  } else {
		throw Exception('Registration failed: ${response.body}');
	  }
	}

  Future<void> logout() async {
    _token = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      _token = prefs.getString('token');
      _userId = prefs.getInt('userId');
      notifyListeners();
    }
  }
}