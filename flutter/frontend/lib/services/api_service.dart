import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogger_frontend/models/post.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8000/api/';
  final String? token;

  ApiService({this.token});

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('${baseUrl}posts/'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPost(int id) async {
    final response = await http.get(Uri.parse('${baseUrl}posts/$id/'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> createPost(String title, String content, String summary) async {
    final response = await http.post(
      Uri.parse('${baseUrl}posts/create/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUwODUzOTA1LCJpYXQiOjE3NTA4NTAz
MDUsImp0aSI6ImMzN2NmNTNiOTdmNjQ4YTg4ZmJjN2E2M2Q1N2E4MzA2IiwidXNlcl9pZCI6Mn0.EUnvHXaixOSAR39oUZ5CdJ4Uymje1lqpFgB1JOK2kT0',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'summary': summary,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create post: ${response.body}');
    }
  }
}