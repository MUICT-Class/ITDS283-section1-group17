import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/widgets/productItem.dart';
import 'package:projectphrase2/models/product.dart';

final List<ProductModel> products = [
  demoProduct,
  demoProduct,
  demoProduct,

];

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Management")),
      body: Stack(
        children: [
          // main list view
          ListView.separated(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 100), // leave bottom space for buttons
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Productitem(product: products[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: 12),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                // go back to home
              },
              child: Icon(Icons.home, color: Color(0xFF389B72)),
              shape: CircleBorder(
                side: BorderSide(color: Color(0xFF389B72)),
              ),
            ),
            )
          ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Additem()));
                  // add new product
                },
                child: Icon(Icons.add, color: Colors.white, size: 32),
                shape: const CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
