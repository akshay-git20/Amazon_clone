import 'package:amazon/common/widgets/bottom_bar.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routname:
      return MaterialPageRoute(
          settings: routeSettings, builder: ((context) => const AuthScreen()));
    case HomeScreen.routName:
      return MaterialPageRoute(
          settings: routeSettings, builder: ((context) => const HomeScreen()));
    case BottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: ((context) => const BottomBar()));
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: ((context) => const AddProductScreen()));
    default:
      return MaterialPageRoute(
          builder: ((context) => const Scaffold(
                body: Center(
                  child: Text('Screen does not exist'),
                ),
              )));
  }
}
