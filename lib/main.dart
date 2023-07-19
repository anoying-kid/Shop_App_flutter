import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      appBarTheme: const AppBarTheme(color: Colors.deepOrange),
      fontFamily: 'Lato',
      pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.iOS: CustomPageTransitionBuilder(), TargetPlatform.android: CustomPageTransitionBuilder()}),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.pink));
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', '', []),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                (previousProducts == null) ? [] : previousProducts.items)),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              (previousOrders == null) ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: lightTheme,
          routes: {
            ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) => const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResutlSnapshot) =>
                      (authResutlSnapshot.connectionState ==
                              ConnectionState.waiting)
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
        ),
      ),
    );
  }
}
