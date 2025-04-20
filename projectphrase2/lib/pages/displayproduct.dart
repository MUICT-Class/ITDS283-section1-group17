import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/chathistory_page.dart';

class Displayproduct extends StatelessWidget {
  final ProductModel product;
  const Displayproduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatHistory())),
              icon: Icon(
                Icons.mail,
                color: Color(0xFF389B72),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                height: 350,
                width: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                      product.photoURL ?? 'assets/images/default.jpg',
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.favorite_border_outlined,
                      size: 30,
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 40), // Add some left/right padding
                child: Align(
                    alignment:
                        Alignment.centerLeft, // Aligns the text to the left
                    child: Text(product.description))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Color(0xFF389B72),
                      borderRadius: BorderRadius.circular(90),
                    ),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chat()),
                      ),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90),
                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
