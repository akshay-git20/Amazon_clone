// ignore_for_file: use_build_context_synchronously

import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
}
