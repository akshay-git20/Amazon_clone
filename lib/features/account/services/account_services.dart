// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/models/order.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orders = [];
    // try {
    http.Response response = await http.get(
      Uri.parse(
        "$uri/api/orders/me",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userprovider.user.token
      },
    );
    // orders.add(Order.fromJson(jsonEncode(jsonDecode(response.body)[0])));
    // print(orders);

    httpErrorHandle(
        response: response,
        context: context,
        onSuccess: (() {
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            orders
                .add(Order.fromJson(jsonEncode(jsonDecode(response.body)[i])));
          }
        }));
    // } catch (e) {
    //   showSnackbar(context, e.toString());
    // }

    return orders;
  }

  void logout({required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove('x-auth-token');

      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routname, (Route<dynamic> route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
