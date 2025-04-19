import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:projectphrase2/pages/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProductdetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductdetailPage({super.key, required this.product});

  @override
  _DisplayproductState createState() => _DisplayproductState();
}

class _DisplayproductState extends State<ProductdetailPage> {
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
        .doc(widget.product.id);

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat()),
              ),
              icon: Icon(
                Icons.mail,
                color: Color(0xFF389B72),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 900,
            width: 900,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: SizedBox(
                        height: 350,
                        width: 350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              product.photoURL ??
                                  'assets/images/default.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 500,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: toggleFavorite,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 30,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 530,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(product.description),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 25,
            right: 25,
            child: SizedBox(
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF389B72),
                  borderRadius: BorderRadius.circular(90),
                ),
                padding: EdgeInsets.only(left: 40, right: 140),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\฿${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 46,
            left: 200,
            right: 33,
            child: SizedBox(
              height: 48,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90)),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Chat now  ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.forward_to_inbox),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
