import 'package:e_commerce_app/pages/check_out_screen.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecuirdProducts extends StatelessWidget {
  const RecuirdProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProviderInstans = Provider.of<CartProvider>(context);
    return Row(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 24,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(211, 164, 255, 193),
                      shape: BoxShape.circle),
                  child: Text(
                    "${cartProviderInstans.selectedProducts.length}",
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  )),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const CheckOutScreen()));
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            "\$ ${cartProviderInstans.price}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
