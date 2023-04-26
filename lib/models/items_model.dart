class Item {
  final double price;
  final String imgPath;
  final String location;
  final String name;

  Item({required this.price,required this.name, required this.imgPath, this.location = "Flower Shop"});
}

final List<Item> items = [
  Item(name: "product name",price: 12.99, imgPath: "assets/img/1.webp" , location:"Mansora" ),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/2.webp", location:"Cairo"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/3.webp"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/4.webp"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/5.webp"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/6.webp"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/7.webp"),
  Item(name: "product name",price: 12.99, imgPath: "assets/img/8.webp"),
];
