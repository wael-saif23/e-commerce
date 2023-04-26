import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/requird_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProviderInstans = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title:const Text("CheckOut"),
        actions:const [
            RecuirdProducts(),
        ],
      ),

      body: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: Image.asset(cartProviderInstans.selectedProducts[index].imgPath),
                  title: Text(""),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}