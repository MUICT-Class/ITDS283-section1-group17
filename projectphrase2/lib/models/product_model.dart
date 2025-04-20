class ProductModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final String? photoURL;
  final String? userId;

  ProductModel(
      {this.id,
      required this.name,
      required this.price,
      required this.description,
      this.photoURL,
      this.userId});

  ProductModel copyWith({String? id}) {
    return ProductModel(
      id: id ?? this.id,
      name: this.name,
      price: this.price,
      description: this.description,
      photoURL: this.photoURL,
    );
  }

  // Convert Firestore data -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      price: json['price'] is int
          ? json['price']
          : (json['price'] is String
              ? int.tryParse(json['price']) ?? 0
              : (json['price'] as num).toInt()), // Convert double to int
      description: json['description'] ?? '',
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
