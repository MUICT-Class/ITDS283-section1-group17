import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectphrase2/models/product.dart';
import 'package:projectphrase2/pages/product_detail_page.dart';

class ProductDisplay extends StatefulWidget {
  final ProductModel product;
  const ProductDisplay({super.key, required this.product});

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.product.id == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.product.id);

    final doc = await favRef.get();
    setState(() {
      isFavorite = doc.exists;
    });
  }

  void toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.product.id); // ต้องมี id ใน ProductModel

    if (isFavorite) {
      await favRef.delete();
      print('unlike');
    } else {
      await favRef.set({'favorite': true});
      print('liked');
    }

    setState(() {
      isFavorite = !isFavorite;
    });

    print('Product ID: ${widget.product.id}');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ProductDetailPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: product.photoURL != null
                        ? Image.network(product.photoURL!, fit: BoxFit.cover)
                        : Image.asset('assets/images/Softcover-Book-Mockup.jpg',
                            fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: toggleFavorite,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 0),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text('\$${product.price}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 127, 85),
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
