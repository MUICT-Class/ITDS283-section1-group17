class ProductModel {
  final String name;
  final int price;
  final String description;
  final String? photoURL;

  ProductModel(
      {required this.name,
      required this.price,
      required this.description,
      this.photoURL});
}

final demoProduct = ProductModel(
    name: "Book",
    price: 360,
    description: "In pharetra fermentum tortor ut accumsan. Nullam ac commodo lacus. Integer imperdiet nisi urna, tincidunt malesuada metus eleifend eget. Sed sed turpis ullamcorper, tristique justo id, mollis elit. Mauris faucibus quam urna, quis accumsan sem ullamcorper nec.",
    photoURL: 'assets/images/Softcover-Book-Mockup.jpg');
