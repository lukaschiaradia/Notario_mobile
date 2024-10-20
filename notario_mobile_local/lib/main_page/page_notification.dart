import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notario_mobile/api/api.dart';

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
    checkForNewNotifications();
  }

  Future<void> checkForNewNotifications() async {
    List<Notification> notifications = await fetchNotifications();

    int? lastNotificationId = await getLastNotificationId();

    if (notifications.isNotEmpty &&
        notifications.last.id != lastNotificationId) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notifications.last.id,
          channelKey: 'basic_channel',
          title: 'Nouvelle demande de notaire',
          body: 'Un notaire nommé ${notifications.last.title} demande à se lier.',
        ),
      );

      await saveLastNotificationId(notifications.last.id);
    }
  }

  Future<int?> getLastNotificationId() async {
    return null;
  }

  Future<void> saveLastNotificationId(int id) async {
  }

  Future<List<Notification>> fetchNotifications() async {
    try {
      var responseRequests = await api_get_requests();
      List<Notification> notifications = [];

      print('Response Requests: $responseRequests');

      for (var notif in responseRequests) {
        print('Processing Notification: $notif');
        notifications.add(Notification.fromMap(notif));
      }

      var responseNewNotifications = await api_get_notifications();
      print('Response New Notifications: $responseNewNotifications');

      for (var notif in responseNewNotifications) {
        print('Processing New Notification: $notif');
        notifications.add(Notification.fromMap(notif));
      }

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Erreur lors de la récupération des notifications : $e');
    }
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
                    title: Text(notification.title),
                    subtitle: Text(notification.content),
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
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? 0,
      title: map['title'] ?? 'No title',
      content: map['content'] ?? 'No content',
      type: map['type'] ?? 'UNKNOWN',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}