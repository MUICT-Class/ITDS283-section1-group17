class ProductModel {
  final String name;
  final int price;
  final String description;
  final String? photoURL;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    this.photoURL,
  });

  // Convert Firestore data -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      photoURL: json['photoURL'],
    );
  }

  // Convert ProductModel -> Firestore data
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'photoURL': photoURL,
    };
  }
}

final demoProduct = ProductModel(
  name: "Book",
  price: 360,
  description: "Default product for demo.",
  photoURL: 'assets/images/default.jpg',
);
