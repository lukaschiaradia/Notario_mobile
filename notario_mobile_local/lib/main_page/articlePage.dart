import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/main_page/articleDetailPage.dart';
import 'package:notario_mobile/models/utilisateur_article.dart';
import '../utils/constants/contants_url.dart';

Future<List<Article>> fetchArticles() async {
  dynamic result = await api_get_articles();
  return List<Article>.from(result.map((item) => Article.fromJson(item)));
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
                child: Text("Erreur: ${snapshot.error}",
                    style: TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Article articleData = snapshot.data![index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: articleData.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network('http://' +ip + articleData.image!,
                                  fit: BoxFit.cover),
                            )
                          : Container(color: Colors.transparent),
                    ),
                    title: Text(articleData.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(articleData.description,
                        style: TextStyle(color: Colors.grey[600])),
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
              },
            );
          } else {
            return Center(
                child: Text("Aucun article trouvé",
                    style: TextStyle(fontSize: 16)));
          }
        },
      ),
    );
  }
}
