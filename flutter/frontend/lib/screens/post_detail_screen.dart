import 'package:flutter/material.dart';
import 'package:blogger_frontend/models/post.dart'; // Corrected path
import 'package:intl/intl.dart';

class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: SingleChildScrollView( // Removed square brackets
        child: Container(
          width: isWide ? 600 : double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineMedium, // Updated from headline
              ),
              SizedBox(height: 8),
              Text(
                'By ${post.author} on ${DateFormat.yMMMd().format(post.createdAt)}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(post.content ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}