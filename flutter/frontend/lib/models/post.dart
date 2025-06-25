class Post {
  final int id;
  final String title;
  final String? summary;
  final String? content;
  final String author;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    required this.author,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      author: json['author']['username'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}