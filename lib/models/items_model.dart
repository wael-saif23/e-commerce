class Item {
  final double price;
  final String imgPath;
  final String location;

  Item({required this.price, required this.imgPath, this.location = "Flower Shop"});
}

final List<Item> items = [
  Item(price: 12.99, imgPath: "assets/img/1.webp" , location:"Mansora" ),
  Item(price: 12.99, imgPath: "assets/img/2.webp", location:"Cairo"),
  Item(price: 12.99, imgPath: "assets/img/3.webp"),
  Item(price: 12.99, imgPath: "assets/img/4.webp"),
  Item(price: 12.99, imgPath: "assets/img/5.webp"),
  Item(price: 12.99, imgPath: "assets/img/6.webp"),
  Item(price: 12.99, imgPath: "assets/img/7.webp"),
  Item(price: 12.99, imgPath: "assets/img/8.webp"),
];
