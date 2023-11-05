// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon/common/widgets/custom_textfield.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/constants/payment_configuration.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address-screen";
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController realAddress = TextEditingController();
  List<PaymentItem> paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  String addressTobeUsed = "";

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void onGooglePayResult(paymentResult) {}

  void payPressed(String addressFromProvider) {
    addressTobeUsed = " ";
    bool formPress = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        cityController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty;

    if (formPress) {
      if (_addressFormKey.currentState!.validate()) {
        addressTobeUsed =
            "${flatBuildingController.text}, ${areaController.text}, ${cityController.text}, ${pincodeController.text}";
      }
    } else if (addressFromProvider.isNotEmpty) {
      _addressFormKey.currentState!.reset();
      addressTobeUsed = addressFromProvider;
    } else {
      showSnackbar(context, "Error");
    }
  }

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        amount: widget.totalAmount,
        label: "Total Amount",
        status: PaymentItemStatus.final_price));
  }

  @override
  Widget build(BuildContext context) {
    final userAddress =
        Provider.of<UserProvider>(context, listen: false).user.address;
    realAddress.text = userAddress;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _addressFormKey,
              child: Column(
                children: [
                  userAddress.isNotEmpty
                      ? Column(
                          children: [
                            CustomTextField(
                              controller: realAddress,
                              hintText: "Flat, House no.Building",
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  CustomTextField(
                      controller: flatBuildingController,
                      hintText: "Flat, House no.Building"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: areaController, hintText: "Area, Street"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: pincodeController, hintText: "Pincode"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: cityController, hintText: "Town/City"),
                  const SizedBox(
                    height: 10,
                  ),
                  RawGooglePayButton(
                    onPressed: () => payPressed(userAddress),
                    type: GooglePayButtonType.buy,
                  )
                  // GooglePayButton(
                  //     width: double.infinity,
                  //     paymentConfiguration:
                  //         PaymentConfiguration.fromJsonString(defaultGooglePay),
                  //     paymentItems: paymentItems,
                  //     type: GooglePayButtonType.buy,
                  //     margin: const EdgeInsets.only(top: 15.0),
                  //     onPaymentResult: (result) =>
                  //         debugPrint('Payment Result $result'),
                  //     loadingIndicator: const Center(
                  //       child: CircularProgressIndicator(),
                  //     ))
                ],
              )),
        ),
      ),
    );
  }
}
