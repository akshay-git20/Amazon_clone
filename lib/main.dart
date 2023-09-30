import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:amazon/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context) => UserProvider())],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (setting) => generateRoute(setting),
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(),
          primaryColor: GlobalVariables.secondaryColor),
      home: AuthScreen()
    );
  }
}
