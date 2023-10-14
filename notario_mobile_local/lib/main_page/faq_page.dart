import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'delayed_animation.dart';
import '../main.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'profil_page.dart';
import 'bottomNavBar.dart';
import '../api/api.dart';
import 'chat_box.dart'; 

Future<List<dynamic>> get_faq_list() async {
  var questionsAndAnswers = await api_get_questions();
  try {
    return questionsAndAnswers.map((item) {
      return {
        'question': item['title'],
        'answer': item['description'],
      };
    }).toList();
  } catch (e) {
    print('Erreur lors de la récupération des questions et réponses : $e');
    return [];
  }
}

class FaqPage extends StatelessWidget {
  final TextEditingController searchTextController = TextEditingController();
  final List<dynamic> questionsAndAnswers = [];
  final List<dynamic> questionsAndAnswersToShow = [];

  FaqPage() {
    _loadQuestionsAndAnswers();
  }

  Future<void> _loadQuestionsAndAnswers() async {
    try {
      questionsAndAnswers.addAll(await get_faq_list());
    } catch (e) {
      print('Erreur lors du chargement des questions et réponses : $e');
    }
    questionsAndAnswersToShow ..addAll(questionsAndAnswers);
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
                      child: DisplayQuestionsAndAnswers(
                          questionsAndAnswers: questionsAndAnswersToShow)
                    )


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
    isExpanded = List.filled(widget.questionsAndAnswers.length, false);
    print(widget.questionsAndAnswers.length);
    print(widget.questionsAndAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.questionsAndAnswers.length,
        itemBuilder: (context, index) {
          final question = widget.questionsAndAnswers[index];
          final title = question['question'];
          final description = question['answer'];

          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                isExpanded[index] ? description : '',
                maxLines: isExpanded[index] ? null : 1,
              ),
              onTap: () {
                setState(() {
                    isExpanded[index] = !isExpanded[index];
                });
              },
            ),
          );
        },
      ),
    );
  }
}







