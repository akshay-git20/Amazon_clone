import 'package:amazon/common/widgets/loader.dart';
import 'package:amazon/constants/global_varible.dart';
import 'package:amazon/features/account/widgets/single_product.dart';
import 'package:amazon/features/home/services/home_services.dart';
import 'package:amazon/features/product_details/screens/product_detail_screen.dart';
import 'package:amazon/models/product.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = "/category-deals";
  final String catergoryName;
  const CategoryDealsScreen({
    Key? key,
    required this.catergoryName,
  }) : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;

  @override
  void initState() {
    fetchCategoryProduct();
    super.initState();
  }

  void fetchCategoryProduct() async {
    productList = await HomeServices().fetchCategoryProducts(
        context: context, category: widget.catergoryName);
    setState(() {
      productList = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            elevation: 2,
            backgroundColor: const Color.fromARGB(255, 29, 201, 192),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Text(
              widget.catergoryName,
              style: const TextStyle(color: Colors.black),
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "Keep Shopping for ${widget.catergoryName}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 170,
            child: productList == null
                ? const Loader()
                : GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: productList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.4,
                            mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final productData = productList![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: productData,
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.width / 3,
                              child:
                                  SingleProduct(image: productData.images[0]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    productData.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
