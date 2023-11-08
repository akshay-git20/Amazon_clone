import 'package:amazon/common/widgets/loader.dart';
import 'package:amazon/features/account/widgets/single_product.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:amazon/features/orderdetails/screens/order_details.dart';
import 'package:amazon/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminServices adminServices = AdminServices();
  List<Order>? orderList = [];

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    orderList = await adminServices.fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orderList == null
        ? const Loader()
        : orderList!.isEmpty
            ? Text("No one made the order till Now")
            : GridView.builder(
                itemCount: orderList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: ((context, index) {
                  final orderData = orderList![index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(
                            context, OrderDetailScreen.routeName,
                            arguments: orderData);
                      }),
                      child: SizedBox(
                        height: 140,
                        child: SingleProduct(
                            image: orderData.products[0]['product']['images']
                                [0]),
                      ),
                    ),
                  );
                }));
  }
}
