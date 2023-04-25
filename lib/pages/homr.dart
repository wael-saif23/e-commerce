// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:e_commerce_app/models/items_model.dart';
import 'package:e_commerce_app/pages/details-screen.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> addSelectedproduct = [];
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
                      trailing: Consumer<CartProvider>(
                          builder: ((context, addcart, child) {
                        return IconButton(
                            color: Color.fromARGB(255, 62, 94, 70),
                            onPressed: () {
                              addcart.add(items[index]);
                            },
                            icon: Icon(Icons.add));
                      })),

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
                            image: AssetImage("assets/img/BG.jpg"),
                            fit: BoxFit.cover),
                      ),
                      currentAccountPicture: CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage("assets/img/1.jpg")),
                      accountEmail: Text("w.s_cg@gmail.com"),
                      accountName: Text("wael saif",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          )),
                    ),
                    ListTile(
                        title: Text("Home"),
                        leading: Icon(Icons.home),
                        onTap: () {}),
                    ListTile(
                        title: Text("My products"),
                        leading: Icon(Icons.add_shopping_cart),
                        onTap: () {}),
                    ListTile(
                        title: Text("About"),
                        leading: Icon(Icons.help_center),
                        onTap: () {}),
                    ListTile(
                        title: Text("Logout"),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () {}),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text("Developed by Wael saif © 2023",
                      style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            Consumer<CartProvider>(builder: ((context, cartInstant, child) {
              return Row(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        bottom: 24,
                        child: Container(
                            child: Text(
                              "${cartInstant.selectedProducts.length}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(211, 164, 255, 193),
                                shape: BoxShape.circle)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_shopping_cart),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      "\$ ${cartInstant.price}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              );
            }))
          ],
          backgroundColor: appbarGreen,
          title: Text("Home"),
        ));
  }
}
