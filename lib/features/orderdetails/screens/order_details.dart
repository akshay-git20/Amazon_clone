// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon/common/widgets/custom_button.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/models/order.dart';
import 'package:amazon/models/product.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = "/order-detail-screen";
  final Order order;

  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: (() {
          setState(() {
            currentStep = status + 1;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: ((value) {
                        navigateToSearchScreen(value);
                      }),
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View Order Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Order Date:          ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt.toInt()))}"),
                    Text("Order ID:              ${widget.order.id}"),
                    Text("Order Total:          \$${widget.order.totalPrice}"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Purchase Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.order.products.length,
                    itemBuilder: (context, index) {
                      Product product = Product.fromMap(
                          widget.order.products[index]['product']);

                      int quantity = widget.order.products[index]['quantity'];

                      return Row(
                        children: [
                          Image.network(product.images[0],
                              height: 120, width: 120, fit: BoxFit.contain),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("Qty: $quantity")
                            ],
                          ))
                        ],
                      );
                    }),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tracking",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Stepper(
                    currentStep: currentStep,
                    type: StepperType.vertical,
                    controlsBuilder: (context, details) {
                      if (user.type == "admin") {
                        return SizedBox(
                            width: 100,
                            height: 30,
                            child: CustomButton(
                              text: "Done",
                              onTap: (() =>
                                  changeOrderStatus(details.currentStep)),
                              color: GlobalVariables.secondaryColor,
                            ));
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                          title: const Text("Pending"),
                          content:
                              const Text("Your order is yet to be delivered."),
                          isActive: currentStep > 0,
                          state: currentStep > 0
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Completed"),
                          content: const Text(
                              "Your Order is delivered, you are yet to sign."),
                          isActive: currentStep > 1,
                          state: currentStep > 1
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Recieved"),
                          content: const Text(
                              "Your order has been delivered and signed by you."),
                          isActive: currentStep > 2,
                          state: currentStep > 2
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const Text("Delivered"),
                          content: const Text(
                              "Your order has been delivered and signed by you."),
                          isActive: currentStep >= 3,
                          state: currentStep >= 3
                              ? StepState.complete
                              : StepState.indexed),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
