class Article {
  final int id;
  final String title;
  final String description;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String? image;
  final Map<String, dynamic> author;
  final List<dynamic> comments;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.image,
    required this.author,
    required this.comments,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      author: json['author'],
      comments: json['comments'],
    );
  }
}
