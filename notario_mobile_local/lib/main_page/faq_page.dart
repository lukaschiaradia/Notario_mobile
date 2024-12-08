import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';
import 'bottomNavBar.dart';
import '../api/api.dart';

Future<List<dynamic>> get_faq_list() async {
  var questionsAndAnswers = await api_get_questions();
  try {
    return questionsAndAnswers.map((item) {
      return {
        'question': item['title'],
        'answer': item['description'],
        'category': item['category'],
      };
    }).toList();
  } catch (e) {
    print('Erreur lors de la récupération des questions et réponses : $e');
    return [];
  }
}

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController searchTextController = TextEditingController();
  String categorySelectorController = 'Toutes les catégories';
  final List<dynamic> questionsAndAnswers = [];
  final List<dynamic> questionsAndAnswersToShow = [];

  final List<dynamic> categories = ["ACCOUNT", "DOCUMENT", "MEETING", "ARTICLE", "CHAT", "AUTRES"];
  final List<dynamic> categoriesName = ["Compte", "Documents", "Rendez-vous", "Article", "Chat", "Autres questions"];

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    try {
      var fetchedQuestionsAndAnswers = await api_get_questions();
      setState(() {
        questionsAndAnswersToShow.addAll(fetchedQuestionsAndAnswers.map((item) {
          return {
            'question': item['title'],
            'answer': item['description'],
            'category': item['category'],
          };
        }).toList());
        questionsAndAnswers.addAll(fetchedQuestionsAndAnswers.map((item) {
          return {
            'question': item['title'],
            'answer': item['description'],
            'category': item['category'],
          };
        }).toList());
      });
    } catch (e) {
      print('Erreur lors de la récupération des questions et réponses : $e');
      return;
    }
  }

  List<String> categoryThatHaveQuestions() {
    final List<String> categoriesThatHaveQuestions = [];
    for (var i = 0; i < categories.length; i++) {
        bool present = false;
        for (var j = 0; j < questionsAndAnswersToShow.length; j++) {
          if (questionsAndAnswersToShow[j]['category'] == categories[i]) {
            present = true;
            break;
          }
        }
        if (present) {
          categoriesThatHaveQuestions.add(categories[i]);
        }
    }
    return categoriesThatHaveQuestions;
  }

  void filterQuestions() {
    questionsAndAnswersToShow.clear();
    if (categorySelectorController == 'Toutes les catégories') {
      questionsAndAnswersToShow.addAll(questionsAndAnswers);
    } else {
      questionsAndAnswersToShow.addAll(questionsAndAnswers.where((item) => item['category'] == categorySelectorController).toList());
    }
    if (searchTextController.text.isNotEmpty) {
      questionsAndAnswersToShow.removeWhere((item) => !item['question'].toLowerCase().contains(searchTextController.text.toLowerCase()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0Xff6949FF)),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Color(0xFF351EA4),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            'Questions / Réponses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
                          child: Text(
                            'Recherchez ici les réponses aux questions fréquentes des utilisateurs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container (
                          padding: EdgeInsets.all(25),
                          child: TextField(
                            controller: searchTextController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45)),
                                  borderSide: BorderSide.none),
                              hintText:
                                  "Ex: Mot de passe oublié",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  filterQuestions();
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButton<String>(
                            value: categorySelectorController,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            dropdownColor: Colors.white,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                categorySelectorController = newValue!;
                                filterQuestions();
                              });
                            },
                            items: ['Toutes les catégories', 'ACCOUNT', 'DOCUMENT', 'MEETING', 'ARTICLE', 'CHAT', 'AUTRES']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value == 'Toutes les catégories' ? value : categoriesName[categories.indexOf(value)], 
                                style: TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          ), 
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  if (questionsAndAnswersToShow.isEmpty)
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: Text(
                        'Aucune question ne correspond à votre recherche',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  if (questionsAndAnswersToShow.isNotEmpty)
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryThatHaveQuestions().length,
                      itemBuilder: (context, index) {
                        final String categoryName = categoryThatHaveQuestions()[index];

                        return DisplayCategory(
                          categoryName: categoriesName[categories.indexOf(categoryName)],
                          questionsAndAnswers: questionsAndAnswersToShow.where((item) => item['category'] == categoryName).toList(),
                        );
                      },
                    ),
                  ),

                ],
              ),   
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}

class DisplayCategory extends StatefulWidget {
  final String categoryName;
  final List<dynamic> questionsAndAnswers;

  DisplayCategory({required this.categoryName, required this.questionsAndAnswers});

  @override
  _DisplayCategoryState createState() => _DisplayCategoryState();
}

class _DisplayCategoryState extends State<DisplayCategory> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
            children: [
              Text(
                widget.categoryName,
                style: TextStyle(
                  color: Color(0xFF351EA4),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Color(0xFF351EA4),
              ),
            ],
          ),
          ),
          SizedBox(height: 10),
          if (isExpanded)
            DisplayQuestionsAndAnswers(
              questionsAndAnswers: widget.questionsAndAnswers,
            ),
        ],
      ),
    );
  }
}


class DisplayQuestionsAndAnswers extends StatefulWidget {
  final List<dynamic> questionsAndAnswers;

  DisplayQuestionsAndAnswers({required this.questionsAndAnswers});

  @override
  _DisplayQuestionsAndAnswersState createState() =>
      _DisplayQuestionsAndAnswersState();
}

class _DisplayQuestionsAndAnswersState
    extends State<DisplayQuestionsAndAnswers> {
  late List<bool> isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded =
        List.filled(widget.questionsAndAnswers.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: SingleChildScrollView(
        child: Column(
          children: widget.questionsAndAnswers.map<Widget>((questionAndAnswer) {
            final title = questionAndAnswer['question'];
            final description = questionAndAnswer['answer'];
            final index = widget.questionsAndAnswers.indexOf(questionAndAnswer);

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    setState(() {
                      isExpanded[index] = !isExpanded[index];
                    });
                  },
                  subtitle: isExpanded[index]
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              description,
                            ),
                          ],
                        )
                      : null,
                  trailing: Icon(
                    isExpanded[index]
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}