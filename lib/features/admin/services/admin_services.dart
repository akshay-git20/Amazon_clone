// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:amazon/constants/error_handing.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/admin/models/sales.dart';
import 'package:amazon/models/order.dart';
import 'package:amazon/models/product.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required num price,
    required num quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dz9vkbxto', 'jqtoycmm');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          category: category,
          images: imageUrls);

      http.Response response =
          await http.post(Uri.parse("$uri/admin/add-product"),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: product.toJson());

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, 'Product Added Successfully');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(
      {required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse("$uri/admin/get-products"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList
                  .add(Product.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    return productList;
  }

  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res =
          await http.delete(Uri.parse("$uri/admin/delete-product"),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'id': product.id}));

      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  // get all the orders
  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse("$uri/admin/get-orders"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList
                  .add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    return orderList;
  }

  void changeOrderStatus(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSuccess}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res =
          await http.post(Uri.parse("$uri/admin/change-order-status"),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode({'id': order.id, 'status': status}));

      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(
      {required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarnigs = 0;
    try {
      http.Response res =
          await http.get(Uri.parse("$uri/admin/analytics"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarnigs = response['totalEarnings'];
            sales = [
              Sales(label: 'Mobiles', earnings: response['mobilesEarnings']),
              Sales(
                  label: 'Essentials',
                  earnings: response['essentialsEarnings']),
              Sales(
                  label: 'Appliances',
                  earnings: response['appliancesEarnings']),
              Sales(label: 'Books', earnings: response['booksEarnings']),
              Sales(label: 'Fashion', earnings: response['fashionEarnings']),
            ];
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    return {
      'totalEarnings':totalEarnigs,
      'sales':sales
    };
  }
}
