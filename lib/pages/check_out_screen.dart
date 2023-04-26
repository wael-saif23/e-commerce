import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/requird_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProviderInstans = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text("CheckOut"),
        actions: const [
          RecuirdProducts(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProviderInstans.itemCount,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(cartProviderInstans
                            .selectedProducts[index].imgPath)),
                    title: Text(
                        cartProviderInstans.selectedProducts[index].name),
                    subtitle: Text(
                        "\$${cartProviderInstans.selectedProducts[index].price} - ${cartProviderInstans.selectedProducts[index].location}"),
                    trailing: IconButton(
                        onPressed: () {
                          cartProviderInstans.delet(
                              cartProviderInstans.selectedProducts[index]);
                        },
                        icon: const Icon(Icons.cancel)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(BTNpink),
                padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
              ),
              child: Text(
                "Pay \$${cartProviderInstans.price}",
                style: const TextStyle(fontSize: 19),
              ),),
          )
        ],
      ),
    );
  }
}
