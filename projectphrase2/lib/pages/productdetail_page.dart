import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/chathistory_page.dart';
import 'package:flutter_svg/svg.dart';

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

    HapticFeedback.lightImpact();
    setState(() {
      isFavorite = !isFavorite;
    });

    print('Product ID: ${widget.product.id}');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHistory()),
              ),
              icon: SvgPicture.asset(
                'assets/icons/mail_icon.svg',
                width: 30,
                height: 30,
                color: Color(0xFF389B72),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 35, 20, 20),
                    child: SizedBox(
                      height: 350,
                      width: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                            product.photoURL ??
                                'assets/images/Softcover-Book-Mockup.jpg',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleFavorite,
                        child: SvgPicture.asset(
                          isFavorite
                              ? 'assets/icons/solid_heart_icon.svg'
                              : 'assets/icons/heart_icon.svg',
                          width: 30,
                          height: 30,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 40),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Color(0xFF389B72),
                  borderRadius: BorderRadius.circular(90),
                ),
                padding: EdgeInsets.fromLTRB(35, 0, 6, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '฿${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final sellerId = product.userId;
                        final currentUserId =
                            FirebaseAuth.instance.currentUser?.uid;
                        print(sellerId);

                        if (sellerId != null && currentUserId != sellerId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(receiverId: sellerId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("You are the owner of this product.")),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        child: Row(
                          children: [
                            Text(
                              "Chat now",
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.forward_to_inbox),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
