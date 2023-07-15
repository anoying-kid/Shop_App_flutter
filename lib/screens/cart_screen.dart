import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                OrderButton(cart: cart)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, i) => CartItem(
              cart.items.values.toList()[i].id,
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].price,
              cart.items.values.toList()[i].quantity,
              cart.items.values.toList()[i].title),
          itemCount: cart.items.length,
        )),
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: Center(
        child: (_isLoading)
            ? CircularProgressIndicator.adaptive()
            : Text('ORDER NOW',
                style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
