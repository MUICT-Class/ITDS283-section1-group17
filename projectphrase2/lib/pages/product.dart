import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/widgets/productItem.dart';
import 'package:projectphrase2/models/product_model.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Management"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No products yet."));
              }

              final docs = snapshot.data!.docs;
              final productList = docs
                  .map((doc) => ProductModel.fromJson(
                      doc.data() as Map<String, dynamic>,
                      id: doc.id))
                  .toList();

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return ProductItem(product: productList[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 40),
              );
            },
          ),

          // floating buttons
          Positioned(
              bottom: 30,
              left: 30,
              child: SizedBox(
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  heroTag: "home",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                    // go back to home
                  },
                  child: Icon(Icons.home, color: Color(0xFF389B72)),
                ),
              )),
          Positioned(
            bottom: 30,
            right: 30,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                heroTag: "add",
                backgroundColor: Color(0xFF389B72),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Additem()));
                  // add new product
                },
                shape: const CircleBorder(),
                child: SvgPicture.asset(
                  'assets/icons/add_icon.svg',
                  color: Colors.white,
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
