class ProductModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final String? photoURL;
  final String? userId;
  final String? username; // Add username field

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.photoURL,
    this.userId,
    this.username, // Initialize username in constructor
  });

  ProductModel copyWith({String? id, String? username}) {
    return ProductModel(
      id: id ?? this.id,
      name: this.name,
      price: this.price,
      description: this.description,
      photoURL: this.photoURL,
      userId: userId ?? this.userId,
      username: username ?? this.username, // Allow overriding the username
    );
  }

  // Convert Firestore data -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ProductModel(
      id: id, // Pass Firestore ID
      name: json['name'],
      price: json['price'],
      description: json['description'],
      photoURL: json['photoURL'],
      userId: json['userId'],
      username: json['username'], // Include username field
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
      'username': username, // Include username field
    };
  }
}
