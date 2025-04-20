import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:projectphrase2/pages/editproduct_page.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onDelete; // Callback for delete action

  const ProductItem({required this.product, this.onDelete, super.key});
  

  @override
  Widget build(BuildContext context) {
    // Debug log to help check if it's loading correctly
    debugPrint("Rendering product: ${product.name}, photoURL: ${product.photoURL}");

    // Choose image source
    Widget imageWidget = _buildImageWidget();
    

    return Slidable(
      key: ValueKey(product.id ?? UniqueKey()), // Ensure null safety for the key
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          if (onDelete != null) {
            onDelete!(); // Call the delete callback if provided
          }
        }),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductPage(productId: product.id?? 'no id'),
              ),
            ),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              if (onDelete != null) {
                onDelete!(); // Call the delete callback if provided
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Card(
        color: const Color.fromARGB(255, 213, 213, 213),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: imageWidget,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                      const SizedBox(height: 5),
                      Text(
                        'Price: ${product.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Description: ${product.description}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        'ID: ${product.id ?? "null"}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (product.photoURL != null && product.photoURL!.startsWith('assets/')) {
      return Image.asset(
        product.photoURL!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    } else if (product.photoURL != null) {
      return Image.network(
        product.photoURL!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    } else {
      return Image.asset(
        'assets/images/Softcover-Book-Mockup.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    }
  }
}