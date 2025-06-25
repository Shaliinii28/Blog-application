import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogger_frontend/providers/auth_provider.dart'; // Corrected path
import 'package:blogger_frontend/services/api_service.dart';   // Corrected path
import 'package:blogger_frontend/models/post.dart';           // Corrected path
import 'package:intl/intl.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts'),
        actions: [
          if (auth.isAuthenticated)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          else
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final posts = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 2 : 1,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: posts.length,
              itemBuilder: (ctx, i) => Card(
                elevation: 4,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/post-detail',
                    arguments: posts[i],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          posts[i].title,
                          style: Theme.of(context).textTheme.titleLarge, // Updated from headline6
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          posts[i].summary ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          'By ${posts[i].author} on ${DateFormat.yMMMd().format(posts[i].createdAt)}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: auth.isAuthenticated
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/create-post'),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}