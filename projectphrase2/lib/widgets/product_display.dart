// ProductDisplay widget on HomePage
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:projectphrase2/pages/productdetail_page.dart';
import 'package:flutter_svg/svg.dart';

// Import Displayproduct page
class ProductDisplay extends StatefulWidget {
  final ProductModel product;
  const ProductDisplay({super.key, required this.product});

  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductdetailPage(product: widget.product)),
        );
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
                    child: widget.product.photoURL != null
                        ? Image.network(widget.product.photoURL!,
                            fit: BoxFit.cover)
                        : Image.asset('assets/images/Softcover-Book-Mockup.jpg',
                            fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('favorites')
                        .doc(widget.product.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final isFavorite =
                          snapshot.hasData && snapshot.data?.exists == true;

                      return GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          final favRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .collection('favorites')
                              .doc(widget.product.id);

                          if (isFavorite) {
                            await favRef.delete();
                          } else {
                            await favRef.set({'favorite': true});
                          }
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                            isFavorite
                                ? 'assets/icons/solid_heart_icon.svg'
                                : 'assets/icons/heart_icon.svg',
                            width: 18,
                            height: 18,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 0),
            Text(
              widget.product.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '\$${widget.product.price}',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 0, 127, 85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
