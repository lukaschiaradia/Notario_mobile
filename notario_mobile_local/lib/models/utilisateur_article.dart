class Author {
  final String firstName;
  final String lastName;

  Author({
    required this.firstName,
    required this.lastName,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

class Article {
  final int? id;
  final String title;
  final String description;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String? image;
  final Author author;
  final List<dynamic> comments;

  Article({
    this.id,
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
      id: json['id'] as int?,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      image: json['image'],
      author: Author.fromJson(json['author'] ?? {}),
      comments: json['comments'] ?? [],
    );
  }
}
