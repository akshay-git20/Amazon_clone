import 'package:amazon/common/widgets/bottom_bar.dart';
import 'package:amazon/features/address/screens/address_screen.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/home/screens/category_deals_screen.dart';
import 'package:amazon/features/home/screens/home_screen.dart';
import 'package:amazon/features/product_details/screens/product_detail_screen.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/models/product.dart';
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
    case CategoryDealsScreen.routeName:
      String category = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: ((context) => CategoryDealsScreen(catergoryName: category)));
    case SearchScreen.routeName:
      String searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: ((context) => SearchScreen(
                searchQuery: searchQuery,
              )));
    case ProductDetailScreen.routeName:
      Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: ((context) => ProductDetailScreen(product: product)));
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: ((context) =>  AddressScreen(totalAmount: totalAmount,)));
    default:
      return MaterialPageRoute(
          builder: ((context) => const Scaffold(
                body: Center(
                  child: Text('Screen does not exist'),
                ),
              )));
  }
}
