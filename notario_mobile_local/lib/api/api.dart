import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:notario_mobile/login/connexion_page.dart';
import 'package:http/http.dart';
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

    print(response.statusCode);
    print(response.body);
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
    print(response.body);
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
    print(response.statusCode);
    chats_list = json_map;
    print("json_map of chats");
    print(json_map);
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
  print(chatId);
  var endPoint = Uri.http(ip, '/chat/$chatId');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    print(response.statusCode);
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

Future<num> api_add_message(
    {required int receiver, required String message}) async {
  var endPoint = Uri.http(ip, '/chat/add/');
  Map data = {};
  data['receiver'] = receiver;
  data['text'] = message;
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
      print("here is the status code");
      print(response.statusCode);
      print(json_map);
      return json_map;
    } else if (response.statusCode == 404) {
      print('You do not have a notary: ${response.statusCode}');
      //showNoNotaryPopup(context);
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
    print(response.body);
    print(response.statusCode);
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
    print(TokenUser);
    print(response.statusCode);
    print(json_list);
    return json_list;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> api_link_notary({required dynamic notary_id}) async {
  var endPoint = Uri.http(ip, '/clients/invite/');
  Map data = {};
  data['notary_id'] = notary_id;
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
    print(json_map);
    print(response.statusCode);
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
    print(response.statusCode);
    print(json_map);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}

Future<List<String>> api_get_chat_id() async {
  var endPoint = Uri.http(ip, '/chat/');
  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + TokenUser,
    });
    var json_response = response.body;
    var decode = utf8.decode(json_response.runes.toList());
    var json_map = json.decode(decode);
    print(response.statusCode);
    print("chat ici");
    print(json_map);
    return await json_map;
  } catch (e) {
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
    print(response.statusCode);
    print(json_map);
    return await json_map;
  } catch (e) {
    throw (e.toString());
  }
}
