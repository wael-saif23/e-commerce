import 'package:e_commerce_app/models/items_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Item> selectedProducts = [];
  double price = 0;
  add(Item product) {
    selectedProducts.add(product);
    price += product.price.round();

    notifyListeners();
  }
}
