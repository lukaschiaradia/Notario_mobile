import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/login/connexion_page.dart';
import 'package:http/http.dart';
import 'package:notario_mobile/models/utilisateur_create_rdv.dart';
import 'package:notario_mobile/models/utilisateur_message.dart';
import '../utils/constants/contants_url.dart';

var user_id = 0;
var receiver_id = 0;
var firstName = '';
var phone = '';
var LastName = '';
var email = '';
var password = '';
var password_confirm = '';
var age = '';
var token = '';
dynamic rdv_list = [];
dynamic faq_list = [];
dynamic chats_list = [];
dynamic chat_List = [];
dynamic chat_id = [];
dynamic chat_with_messages = [];
dynamic all_messages = [];
dynamic files_list = [];

Future<dynamic> api_get_planning() async {
  var endPoint = Uri.http(ip, '/planning/get/');
  print('yes');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);

    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_get_questions() async {
  var endPoint = Uri.http(ip, '/faq/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    rdv_list = json_map;
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_get_chats() async {
  var endPoint = Uri.http(ip, '/chat/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    chats_list = json_map;
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

List<dynamic> create_chat_list(List chats_list) {
  List<dynamic> chat_List = [];
  for (int x = 0; x < chats_list.length; x++) {
    chat_List = [
      ...chat_List,
      {
        'chat_id': chats_list[x]['id'],
        'receiver': chats_list[x]['user_name'],
        'id_receiver': chats_list[x]['user_id'],
      }
    ];
  }
  return chat_List;
}

Future<dynamic> api_get_chat(chatId) async {
  var endPoint = Uri.http(ip, '/chat/$chatId');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    chat_with_messages = json_map;
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

List<dynamic> create_messages_list(List chat_with_messages) {
  List<dynamic> messages = [];
  for (int x = 0; x < chat_with_messages.length; x++) {
    messages = [
      ...messages,
      {
        'sender': chat_with_messages[x]['sender'],
        'receiver': chat_with_messages[x]['receiver'],
        'message': chat_with_messages[x]['text'],
      }
    ];
  }
  return messages;
}

Future<void> api_add_message(AddMessage message) async {
  var endPoint = Uri.http(ip, '/chat/message/add/');

  try {
    final response = await Client().post(
      endPoint,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + '$TokenUser',
      },
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 200) {
      // Message envoyé avec succès
      print('Message envoyé avec succès: ${response.body}');
    } else if (response.statusCode == 401) {
      // Utilisateur non valide
      print('Utilisateur non valide : ${response.body}');
    } else if (response.statusCode == 404) {
      // Utilisateur non trouvé
      print('Utilisateur non trouvé : ${response.body}');
    } else {
      // Autres erreurs
      print('Erreur lors de l\'envoi du message: ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur de connexion: $e');
  }
}

Future<dynamic> api_ask_rdv(
    {required String Date, required String reason}) async {
  var endPoint = Uri.http(ip, '/planning/ask/');

  Map data = {};
  data['available_dates'] = Date;
  data['reason'] = reason;
  try {
    var response = await Client().post(endPoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenUser,
        },
        body: convert.json.encode(data));
    return await (response.statusCode);
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_get_files({required String token}) async {
  var endPoint = Uri.http(ip, '/files/list/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });

    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    files_list = json_map['files'];
    return files_list;
  } catch (e) {
    throw (e.toString());
  }
}

Future<Map<String, dynamic>> api_get_notary() async {
  var endPoint = Uri.http(ip, '/clients/get-notary/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    if (response.statusCode == 200) {
      var json_response = response.body;
      var decode = utf8.decode(json_response.runes.toList());
      var json_map = json.decode(decode);
      return json_map;
    } else if (response.statusCode == 404) {
      print('You do not have a notary: ${response.statusCode}');
      throw Exception('You do not have a notary');
    } else {
      print(
          'Error while retrieving notary information: ${response.statusCode}');
      throw Exception('Failed to load notary information');
    }
  } catch (e) {
    print('Error occurred: $e');
    throw e;
  }
}

Future<dynamic> api_get_articles() async {
  var endPoint = Uri.http(ip, '/articles/get/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<List<dynamic>> api_get_notaires() async {
  var endPoint = Uri.http(ip, '/clients/get-notaries/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_list = json.decode(decode) as List;
    return json_list;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_link_notary({required dynamic notary_id}) async {
  var endPoint = Uri.http(ip, '/clients/invite/');
  Map data = {};
  data['email'] = notary_id;
  try {
    var response = await Client().post(endPoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenUser,
        },
        body: convert.json.encode(data));
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    return await (response.statusCode);
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_get_invite_requests() async {
  var endPoint = Uri.http(ip, '/clients/get-invite/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<String> api_get_chat_id() async {
  var endPoint = Uri.http(ip, '/chat/get/all/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });

    // Décodage du corps de la réponse
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);

    print(json_map); // Affiche la réponse JSON complète pour vérification

    // Vérifier si la clé 'data' existe et contient une liste
    if (json_map.containsKey('data')) {
      List<dynamic> chatsData =
          json_map['data']; // Récupération de la liste des chats

      // Extraire le premier 'uid' trouvé
      if (chatsData.isNotEmpty) {
        String chatId =
            chatsData[0]['uid'].toString(); // Récupère le premier UID
        print('chat id = $chatId');
        return chatId;
      } else {
        print('Erreur: liste "data" vide');
        return '';
      }
    } else {
      // Si la clé 'data' n'existe pas
      print('Erreur: clé "data" non trouvée dans la réponse');
      return '';
    }
  } catch (e) {
    print('Erreur lors du chargement de l\'identifiant du chat: $e');
    throw (e.toString());
  }
}

Future<Map<String, dynamic>> api_get_chat_details(String uid) async {
  var endPoint = Uri.http(ip, '/chat/get/$uid');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });

    if (response.statusCode == 200) {
      var json_response = response.body;
      var json_map = json.decode(json_response);
      print('Détails du chat pour UID $uid: $json_map');
      print(json_map['sender']);
      return json_map;
    } else {
      print('Erreur: statut ${response.statusCode} pour UID $uid');
      throw Exception('Erreur lors du chargement des détails du chat');
    }
  } catch (e) {
    print('Erreur lors de la récupération des détails du chat: $e');
    throw (e.toString());
  }
}

Future<List<dynamic>> api_get_chat_with_notaire(
    {required dynamic idChat}) async {
  var endPoint = Uri.http(ip, '/chat/$idChat');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<void> apiDissociateNotary() async {
  var endPoint = Uri.http(ip, '/clients/dissociate/');
  try {
    var response = await Client().delete(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    if (response.statusCode == 200) {
      print("Dissociation réussie.");
    } else {
      print("Erreur lors de la dissociation : ${response.body}");
    }
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_get_requests() async {
  var endPoint = Uri.http(ip, '/clients/get-requests/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_acceptNotary({required int id}) async {
  var endPoint = Uri.http(ip, '/clients/accept-request/');
  Map data = {};
  data['notary_id'] = id;
  try {
    var response = await Client().post(endPoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenUser,
        },
        body: convert.json.encode(data));
    return await (response.statusCode);
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_rejectNotary({required int id}) async {
  var endPoint = Uri.http(ip, '/clients/refuse-request/');
  Map data = {};
  data['notary'] = id;
  try {
    var response = await Client().delete(endPoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + TokenUser,
        },
        body: convert.json.encode(data));
    return await (response.statusCode);
  } catch (e) {
    throw (e.toString());
  }
}
