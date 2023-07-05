import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      appBarTheme: AppBarTheme(color: Colors.deepOrange),
      fontFamily: 'Lato',
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.pink));
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Products()), ChangeNotifierProvider(create: (context) =>Cart())],
      child: MaterialApp(
        title: 'MyShop',
        theme: lightTheme,
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
        },
        home: ProductOverviewScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Shop')),
      body: Center(child: Text('lets build')),
    );
  }
}
