import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product_model.dart';

class Productitem extends StatelessWidget {
  final ProductModel product;
  const Productitem({required this.product, super.key});

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

    return Card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${product.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Price: ${product.price} THB'),
                  Text(
                    'Description: ${product.description}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
