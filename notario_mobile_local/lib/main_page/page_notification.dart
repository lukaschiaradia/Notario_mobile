import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart'; // Assurez-vous que ce chemin est correct

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
      var response = await api_get_requests();
      List<Notification> notifications = [];
      for (var notif in response) {
        notifications.add(Notification.fromMap(notif));
      }
      return notifications;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications : $e');
    }
  }

  void acceptNotary(int id) {
    api_acceptNotary(id: id);
    print("Notaire $id accepté");
    setState(() {
      _notifications = fetchNotifications();
    });
  }

  void rejectNotary(int id) {
    api_rejectNotary(id: id);
    print("Notaire $id refusé");
    setState(() {
      _notifications = fetchNotifications();
    });
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
            return Center(child: Text('Aucune notification'));
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
                          onPressed: () => acceptNotary(notification.id),
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
  final int id;
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
      userName: map['user_name'],
      email: map['email'],
    );
  }
}
