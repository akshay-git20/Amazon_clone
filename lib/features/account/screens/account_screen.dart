import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/features/account/widgets/below_app_bar.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(50), child: AppBar(
        elevation: 2,
        backgroundColor: Color.fromARGB(255, 29, 201, 192), 

        flexibleSpace: Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset('assets/images/amazon_in.png',width: 120,height: 45,color: Colors.black,),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: Row(
              
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.notifications_active_outlined),
                ),
                Icon(Icons.search_outlined)
              ],
            ),
          )
        ],),
        ),
      ),
      
      body: Column(
        children: [
          BelowAppBar(),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}