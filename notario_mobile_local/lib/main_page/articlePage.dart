import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/main_page/articleDetailPage.dart';
import 'package:notario_mobile/models/utilisateur_article.dart';
import '../utils/constants/contants_url.dart';
import 'package:flutter/material.dart';

Future<List<Article>> fetchArticles() async {
  dynamic result = await api_get_articles();

  if (result is Map<String, dynamic> && result.containsKey('data')) {
    List<dynamic> articlesJson = result['data'];

    return List<Article>.from(
      articlesJson.map((item) => Article.fromJson(item as Map<String, dynamic>))
    );
  } else {
    throw Exception('Erreur: les données ne sont pas au bon format.');
  }
}


class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Articles'),
        backgroundColor: Color.fromARGB(255, 119, 140, 236),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final articles = snapshot.data!;
            return articles.isNotEmpty
                ? ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return ArticleCard(articleData: articles[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Aucun article trouvé",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
          } else {
            return Center(
              child: Text(
                "Erreur inconnue.",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article articleData;

  const ArticleCard({Key? key, required this.articleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: _buildArticleImage(),
        title: Text(
          articleData.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          articleData.description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(articleData),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: articleData.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                'http://$ip${articleData.image!}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.transparent);
                },
              ),
            )
          : Container(color: Colors.transparent),
    );
  }
}

