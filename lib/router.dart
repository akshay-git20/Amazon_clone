import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routname:
      return MaterialPageRoute(
          settings: routeSettings, builder: ((context) => const AuthScreen()));

    default:
      return MaterialPageRoute(
          builder: ((context) => const Scaffold(
                body: Center(
                  child: Text('Screen does not exist'),
                ),
              )));
  }
}
