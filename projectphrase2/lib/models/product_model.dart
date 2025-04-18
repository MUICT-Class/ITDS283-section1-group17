class ProductModel {
  final String name;
  final int price;
  final String description;
  final String? photoURL;
  final String? userId;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    this.photoURL,
    this.userId
  });

  // Convert Firestore data -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      photoURL: json['photoURL'],
      userId: json['userId'],
    );
  }

  // Convert ProductModel -> Firestore data
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'photoURL': photoURL,
      'userId': userId,
    };
  }
}