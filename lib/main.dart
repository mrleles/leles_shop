import 'package:flutter/material.dart';
import 'package:leles_shop/providers/cart.dart';
import 'package:leles_shop/providers/orders.dart';
import 'package:leles_shop/providers/products.dart';
import 'package:leles_shop/screens/cart_screen.dart';
import 'package:leles_shop/screens/edit_product_screen.dart';
import 'package:leles_shop/screens/orders_screen.dart';
import 'package:leles_shop/screens/product_detail_screen.dart';
import 'package:leles_shop/screens/products_overview_screen.dart';
import 'package:leles_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Leles Shop',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
