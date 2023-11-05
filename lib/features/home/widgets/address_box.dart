import 'package:amazon/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  bool showFullAddress = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      height: showFullAddress ? 105 : 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 162, 236, 233),
          ],
          stops: [0.5, 1.0], 
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Delivery to ${user.name} - Plot No:- 452 ,Swayamsiddha CHSL, Charkop, Sector 7, RDP 8, Sector 4 Charkop, Kandivali West, Mumbai, Maharashtra',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: showFullAddress ? null : TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showFullAddress = !showFullAddress;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 2,
              ),
              child: Icon(
                showFullAddress
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
