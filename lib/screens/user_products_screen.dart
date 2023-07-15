import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: FutureBuilder(
          future:  _refreshProducts(context),
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.waiting)
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder:(context, productsData, _) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (context, i) => Column(
                                      children: [
                                        UserProductItem(
                                            productsData.items[i].id,
                                            productsData.items[i].title,
                                            productsData.items[i].imageUrl),
                                        const Divider()
                                      ],
                                    )),
                          ),
                      ),
                  ),
        ),
      ),
    );
  }
}
