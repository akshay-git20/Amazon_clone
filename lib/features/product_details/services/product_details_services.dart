// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/product.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailServices {
  void rateProduct(
      {required BuildContext context,
      required Product product,
      required num rating}) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
          Uri.parse(
            "$uri/api/rate-product",
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userprovider.user.token
          },
          body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),);

      httpErrorHandle(response: response, context: context, onSuccess: (() {}));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
