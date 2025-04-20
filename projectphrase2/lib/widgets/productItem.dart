import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    // Debug log to help check if it's loading correctly
    print("Rendering product: ${product.name}, photoURL: ${product.photoURL}");

    // Choose image source
    Widget imageWidget;

    if (product.photoURL != null && product.photoURL!.startsWith('assets/')) {
      imageWidget = Image.asset(
        product.photoURL!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    } else if (product.photoURL != null) {
      imageWidget = Image.network(
        product.photoURL!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    } else {
      imageWidget = Image.asset(
        'assets/images/Softcover-Book-Mockup.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    }

    print('🧩 Productitem: ${product.name} | ID: ${product.id}');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 160),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: product.photoURL != null
                        ? Image.network(product.photoURL!, fit: BoxFit.cover)
                        : Image.asset('assets/images/Softcover-Book-Mockup.jpg',
                            fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Name: ${product.name}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Price: ${product.price}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Description: ${product.description}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          'ID: ${product.id ?? "null"}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
