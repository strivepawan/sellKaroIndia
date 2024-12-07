import 'package:flutter/material.dart';
import 'package:sell_karo_india/pages/login.dart';

import 'register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show Login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage =! showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePages
      );
    }else {
      return RegisterOrLogin(
        onTap: togglePages,
      );
    }

  }
}