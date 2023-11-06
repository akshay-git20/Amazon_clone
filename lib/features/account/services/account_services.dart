// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/order.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
              orders.add(
                  Order.fromJson(jsonEncode(jsonDecode(response.body)[i])));
            }
          }));
    // } catch (e) {
    //   showSnackbar(context, e.toString());
    // }

    return orders;
  }
}
