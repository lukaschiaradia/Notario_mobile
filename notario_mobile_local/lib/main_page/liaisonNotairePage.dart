import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'notaires_page.dart';

class LiaisonNotairePage extends StatefulWidget {
  final List<dynamic> notaires;

  LiaisonNotairePage({required this.notaires});

  @override
  _LiaisonNotairePageState createState() => _LiaisonNotairePageState();
}

class _LiaisonNotairePageState extends State<LiaisonNotairePage> {
  // Liste filtrée des notaires
  late List<dynamic> filteredNotaires;

  // Controller pour le TextField de recherche
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation de la liste filtrée avec la liste complète des notaires
    filteredNotaires = widget.notaires;

    // Ajouter un listener pour mettre à jour la recherche à chaque saisie
    searchController.addListener(_filterNotaires);
  }

  @override
  void dispose() {
    // Ne pas oublier de supprimer le listener quand la page est détruite
    searchController.removeListener(_filterNotaires);
    super.dispose();
  }

  // Fonction qui filtre la liste des notaires en fonction du texte recherché
  void _filterNotaires() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotaires = widget.notaires.where((notaire) {
        // Comparer le prénom et le nom (insensible à la casse)
        return (notaire['first_name'].toLowerCase().contains(query) ||
                notaire['last_name'].toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des notaires'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou prénom',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Bouton d'ajout
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.add),
                iconSize: 24.0,
                onPressed: () {
                  api_get_invite_requests();
                },
              ),
            ),
          ),
          
          // Liste des notaires filtrée
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotaires.length,
              itemBuilder: (context, index) {
                var notaire = filteredNotaires[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(notaire['first_name'][0]),
                      backgroundColor: const Color.fromARGB(255, 143, 183, 202),
                    ),
                    title: Text(
                      notaire['first_name'] +
                          ' ' +
                          notaire['last_name'] +
                          ' - ' +
                          'City: ' +
                          notaire['city'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        api_link_notary(notary_id: notaire['email']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Vous êtes maintenant affilié avec ce notaire"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        typeUser = 'Client';
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notaires()),
                        );
                      },
                      child: Text('Lier'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
