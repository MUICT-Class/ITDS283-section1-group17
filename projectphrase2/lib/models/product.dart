class ProductModel {
  final String name;
  final int price;
  final String description;
  final String? photoURL;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    this.photoURL
  });
}

final demoProduct = ProductModel(name: "Book", price: 10000, description: "This is book eiei",photoURL: 'assets/images/Softcover-Book-Mockup.jpg');
