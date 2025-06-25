import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogger_frontend/providers/auth_provider.dart'; // Corrected path
import 'package:blogger_frontend/screens/login_screen.dart';
import 'package:blogger_frontend/screens/register_screen.dart';
import 'package:blogger_frontend/screens/post_list_screen.dart';
import 'package:blogger_frontend/screens/post_detail_screen.dart';
import 'package:blogger_frontend/screens/create_post_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider()..tryAutoLogin(),
      child: MaterialApp(
        title: 'Blogger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => PostListScreen(),
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),
          '/post-detail': (ctx) => PostDetailScreen(),
          '/create-post': (ctx) => CreatePostScreen(),
        },
      ),
    );
  }
}