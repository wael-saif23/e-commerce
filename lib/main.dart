import 'package:e_commerce_app/pages/homr.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return CartProvider();
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
