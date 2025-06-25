import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogger_frontend/providers/auth_provider.dart'; // Corrected path
import 'package:blogger_frontend/services/api_service.dart';   // Corrected path

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _summaryController = TextEditingController();
  String? _error;

  void _createPost() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await ApiService(token: auth.token).createPost(
        _titleController.text,
        _contentController.text,
        _summaryController.text,
      );
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
      appBar: AppBar(title: Text('Create Post')),
      body: SingleChildScrollView(
        child: Container(
          width: isWide ? 600 : double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _summaryController,
                decoration: InputDecoration(labelText: 'Summary'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 10,
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(_error!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPost,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}