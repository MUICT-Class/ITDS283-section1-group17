class ProductModel {
  final String? id;
  final String name;
  final int price;
  final String description;
  final String? photoURL;
  final String? userId;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.photoURL,
    this.userId
  });

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
      id: id, // เพิ่มการรับค่า id จาก Firestore
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