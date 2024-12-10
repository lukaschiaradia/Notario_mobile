import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';
import '../utils/constants/contants_url.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Notification>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = fetchNotifications();
  }

  Future<List<Notification>> fetchNotifications() async {
    try {
      var response = await api_get_requests(); // Appel à l'API.
      List<dynamic> data = response['data']; // Accès à la clé 'data'.
      List<Notification> notifications = data.map((notif) {
        return Notification.fromMap(notif);
      }).toList();
      return notifications;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications : $e');
    }
  }

  void acceptNotary(String id) { 
    api_acceptNotary(id: id);
    setState(() {
      // Supprimer la notification après acceptation
      _notifications = _notifications.then(
        (notifications) => notifications.where((notif) => notif.id != id).toList(),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation acceptée')),
    );
  }

  void rejectNotary(String id) { 
    api_rejectNotary(id: id);
    setState(() {
      // Supprimer la notification après refus
      _notifications = _notifications.then(
        (notifications) => notifications.where((notif) => notif.id != id).toList(),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation refusée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Notifications'),
      ),
      body: FutureBuilder<List<Notification>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erreur lors du chargement des notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Aucune notification',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notification = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(notification.userName),
                    subtitle: Text(notification.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            typeUser = 'Client';
                            acceptNotary(notification.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Accepter'),
                        ),

                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => rejectNotary(notification.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Refuser'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Notification {
  final String id; 
  final String userName;
  final String email;

  Notification({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      userName: map['user_name'] ?? 'Inconnu',
      email: map['email'] ?? 'Non spécifié',
    );
  }
}
