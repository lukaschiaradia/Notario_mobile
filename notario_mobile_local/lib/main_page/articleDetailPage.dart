import 'package:flutter/material.dart';
import 'package:notario_mobile/models/utilisateur_article.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article articleData;

  ArticleDetailPage(this.articleData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Detail'),
        backgroundColor: Color.fromARGB(255, 104, 158, 194),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (articleData.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(articleData.image!, fit: BoxFit.cover),
              ),
            SizedBox(height: 20),
            Text(
              articleData.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By ${articleData.author['first_name']} ${articleData.author['last_name']}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              articleData.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              articleData.content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              'Comments:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            for (var comment in articleData.comments) _buildCommentCard(comment),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              comment['text'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'By ${comment['author']} - ${comment['datetime']}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
