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
  final List<dynamic> questionsAndAnswers = [];
  final List<dynamic> questionsAndAnswersToShow = [];

  final List<dynamic> categories = ["ACCOUNT", "DOCUMENT", "MEETING", "CHAT", "AUTRES"];
  final List<dynamic> categoriesName = ["Compte", "Documents", "Rendez-vous", "Chat", "Autres questions"];

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

  void searchQuestionsByInput(String input) {
    questionsAndAnswersToShow.clear();
    if (input.isEmpty) {
      questionsAndAnswersToShow.addAll(questionsAndAnswers);
      return;
    }
    for (var item in questionsAndAnswers) {
      String question = item['question'];
      String answer = item['answer'];
      if (question.toLowerCase().contains(input.toLowerCase()) ||
          answer.toLowerCase().contains(input.toLowerCase())) {
        questionsAndAnswersToShow.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0Xff6949FF)),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'NOTARIO',
          style: TextStyle(
            color: Color(0Xff6949FF),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: 1512,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: blue_color,
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
                                  searchQuestionsByInput(
                                      searchTextController.text);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                         if (questionsAndAnswersToShow.isEmpty)
                          Text(
                            'Aucun résultat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),      

                      ],
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
                  color: blue_color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: blue_color,
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
