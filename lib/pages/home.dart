// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:e_commerce_app/models/items_model.dart';
import 'package:e_commerce_app/pages/check_out_screen.dart';
import 'package:e_commerce_app/pages/details-screen.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/requird_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProviderInstans = Provider.of<CartProvider>(context);
    final userAccount = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 22),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 33),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(product: items[index]),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Stack(children: [
                      Positioned(
                        top: -3,
                        bottom: -9,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Image.asset(items[index].imgPath)),
                      ),
                    ]),
                    footer: GridTileBar(
// backgroundColor: Color.fromARGB(66, 73, 127, 110),
                      trailing: IconButton(
                          color: Color.fromARGB(255, 62, 94, 70),
                          onPressed: () {
                            cartProviderInstans.add(items[index]);
                          },
                          icon: Icon(Icons.add)),

                      leading: Text(items[index].price.toString()),

                      title: Text(
                        "",
                      ),
                    ),
                  ),
                );
              }),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(userAccount.photoURL!),
                            fit: BoxFit.cover),
                      ),
                      currentAccountPicture: CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(userAccount.photoURL!)),
                      accountEmail: Text(userAccount.email!),
                      accountName: Text(userAccount.displayName!,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          )),
                    ),
                    ListTile(
                        title: Text("Home"),
                        leading: Icon(Icons.home),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        }),
                    ListTile(
                        title: Text("My products"),
                        leading: Icon(Icons.add_shopping_cart),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckOutScreen(),
                              ));
                        }),
                    ListTile(
                        title: Text("About"),
                        leading: Icon(Icons.help_center),
                        onTap: () {}),
                    ListTile(
                        title: Text("Logout"),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                        }),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text("Developed by Wael Saif © 2023",
                      style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            RecuirdProducts(),
          ],
          backgroundColor: appbarGreen,
          title: Text("Home"),
        ));
  }
}
