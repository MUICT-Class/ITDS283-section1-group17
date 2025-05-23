import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import '../models/product_model.dart';
import '../widgets/product_display.dart';

class FavItem extends StatefulWidget {
  const FavItem({super.key});

  @override
  State<FavItem> createState() => _FavItemState();
}

class _FavItemState extends State<FavItem> {
  Future<List<ProductModel>> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final favSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    final productIds = favSnap.docs.map((doc) => doc.id).toList();

    if (productIds.isEmpty) return [];

    final productSnap = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();

    return productSnap.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      print('📦 Favorite Product : $id'); // สำหรับ debug
      return ProductModel.fromJson(data, id: id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow_left_icon.svg',
            width: 30,
            height: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Favorite Items"),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(child: Text("No favorites found."));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: products
                    .map((product) => ProductDisplay(product: product))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
