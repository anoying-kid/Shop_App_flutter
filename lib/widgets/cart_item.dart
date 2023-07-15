import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  const CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => (Platform.isIOS || Platform.isMacOS)
                ? CupertinoAlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to remove item from the cart?'),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          isDestructiveAction: false,
                          child: const Text('Yes')),
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          isDestructiveAction: true,
                          child: const Text('No')),
                    ],
                  )
                : AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to remove item from the cart?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'))
                    ],
                  ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('\$$price'),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
