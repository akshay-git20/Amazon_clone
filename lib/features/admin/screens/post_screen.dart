import 'package:amazon/common/widgets/loader.dart';
import 'package:amazon/features/account/widgets/single_product.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:amazon/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;
  @override
  void initState() {
    super.initState();
    fetchAllProduct();
  }

  void fetchAllProduct() async {
    products = await adminServices.fetchAllProducts(context: context);
    setState(() {
      products = products;
    });
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void deleteproduct(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          setState(() {
            products!.removeAt(index);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return products == null
        ? const Loader()
        : Scaffold(
            body: products!.isEmpty
                ? const Center(
                    child: Text('Products'),
                  )
                : GridView.builder(
                    itemCount: products!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: ((context, index) {
                      final productData = products![index];
                      return Column(
                        children: [
                          SizedBox(
                            height: size.width/3,
                            child: SingleProduct(image: productData.images[0]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                productData.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              IconButton(
                                  onPressed: (() =>
                                      deleteproduct(productData, index)),
                                  icon: const Icon(Icons.delete_outline))
                            ],
                          )
                        ],
                      );
                    })),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add Product',
              onPressed: () {
                navigateToAddProduct();
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
