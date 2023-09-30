// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/home/screens/home_screen.dart';
import 'package:amazon/models/user.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
          id: '',
          name: name,
          email: email,
          password: password,
          address: '',
          type: '',
          token: '');

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: user.toJson());

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackbar(context,
                "Account has been created ! Login with same crrendentials");
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  //Sign In User
  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      // body
      Map<String, dynamic> data = {"email": email, "password": password};
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routName, (route) => false);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  
}
