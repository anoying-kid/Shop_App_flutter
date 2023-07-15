import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occurred'),
                );
                // ... error handling
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: ((context, index) =>
                          OrderItem(orderData.orders[index]))),
                );
              }
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
