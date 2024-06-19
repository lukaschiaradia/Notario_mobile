import 'dart:convert' as convert;
import 'package:notario_mobile/api/api.dart';

import '../utils/constants/contants_url.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';
import 'package:notario_mobile/models/utilisateur_delete.dart';
import 'package:notario_mobile/models/utilisateur_modif.dart';
import 'package:notario_mobile/models/utilisateur_register.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';

var json_info = {};

class ApiAuth {
  const ApiAuth();

  Future<Response> apiLogin(
      {required UtilisateurLogin utilisateurLogin}) async {
    var endPoint = Uri.http(ip, accountsLogin);
    Map data = utilisateurLogin.toData();
    json_info = data;
    print(data.toString());
    try {
      var response = await Client().post(endPoint,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.json.encode(data));
      print(response.body);
      print("tesst");
      print(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      typeUser = responseData['user']['type'];
      print("usertype: $typeUser");
      Map<String, dynamic> jsonResponse = convert.json.decode(response.body);
      String token = jsonResponse['token'];
      TokenUser = token;
      print('Le token est : $TokenUser');
      return (response);
    } catch (e) {
      throw e;
    }
  }

  Future<Response> apiRegister({
    required UtilisateurRegister utilisateurRegister,
  }) async {
    var endPoint = Uri.http(ip, accountsRegister);
    Map data = utilisateurRegister.toData();
    print(data);
    if (!utilisateurRegister.passwordIsConfirm)
      throw Exception('password incorect');
    try {
      var response = await Client().post(endPoint,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.json.encode(data));
      return await (response);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Response> apiUpdate({
    required String first_name,
    required String last_name,
    required String email,
    required int age,
  }) async {
    var endPoint = Uri.http(ip, accountsModifs);
    Map data = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'age': age,
    };
    print(data);
    try {
      var response = await Client().put(endPoint,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-CSRF-Token': TokenUser,
            'Authorization': 'Bearer ' + TokenUser,
          },
          body: convert.json.encode(data));
      print(response.body);
      return await (response);
    } catch (e) {
      throw (e.toString());
    }
  }
}

Future<Map<String, dynamic>> getUserInfo() async {
  print(TokenUser);
  var endPoint = Uri.http(ip, '/accounts/user/');

  try {
    var response = await Client().get(endPoint, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-CSRF-Token': TokenUser,
      'Authorization': 'Bearer ' + TokenUser,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> userInfo = convert.json.decode(response.body);
      print(userInfo);
      return userInfo;
    } else {
      print(
          'Erreur lors de la récupération des informations de l\'utilisateur : ${response.statusCode}');
      return {};
    }
  } catch (e) {
    throw e;
  }
}

//call api pour le delete
Future<Response> apiDelete({
  required UtilisateurDelete accountsDeleteId,
}) async {
  var endPoint = Uri.http(ip, deleteClient.toString());
  try {
    var response = await Client().delete(
      endPoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-CSRF-Token': accountsDeleteId.idClient,
        'Authorization': 'Bearer ' + accountsDeleteId.idClient,
      },
    );
    print(accountsDeleteId.idClient);
    return response;
  } catch (e) {
    throw (e.toString());
  }
}

Future<dynamic> apiForgotPassword({required String email}) async {
  var endPoint = Uri.http(ip, 'accounts/forgotten/');
  try {
    var response = await Client().post(
      endPoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  } catch (e) {
    throw (e.toString());
  }
}
