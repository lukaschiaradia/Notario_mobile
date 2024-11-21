import 'package:flutter/material.dart';

const accountsRegister = '/accounts/register/';
const accountsLogin = '/accounts/login/';
const accountsModifs = '/accounts/update/';
const clientGet = '/clients/';
const deleteClient = '/accounts/delete/';
const faqRoute = '/faq/';
const planningRoute = '/planning/';
const filesGet = '/files/list/';
//const changeInfo
//local host emulator
//const ip = '10.0.2.2:8000';
//localhost
//const ip = '127.0.0.1:8000';
//prod
const ip = '92.113.25.24:8000';
String TokenUser = '';
String myId = '';
String typeUser = '';
String stateUser = '';
bool isDarkMode = false;


class AppColors {
  static const primaryColor = Color(0xFF351EA4);
  static const backgroundDark = Color(0xFF1A1B25);
}

class AppTextStyles {
  static const titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}