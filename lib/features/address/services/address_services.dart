// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/user.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  void saveAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse(
          "$uri/api/save-user-address",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: (() {
            User user = userprovider.user
                .copyWith(address: jsonDecode(response.body)['address']);
            userprovider.setUserByModel(user);
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required num totalSum,
  }) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse(
          "$uri/api/order",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'cart': userprovider.user.cart,
          'totalPrice': totalSum,
          'address': address,
        }),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: (() {
            showSnackbar(context, "Your Order Has Been Placed!");
            User user = userprovider.user.copyWith(
              cart: [],
            );
            userprovider.setUserByModel(user);
          }));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
