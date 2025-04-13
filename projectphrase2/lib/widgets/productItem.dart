import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product.dart';

class Productitem extends StatelessWidget{
  final ProductModel product;
  const Productitem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            
            child: SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                child: Image.asset(product.photoURL ?? 'assets/images/default.jpg',
                fit: BoxFit.cover ,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${product.name}'),
                Text('Price: ${product.price}'),
                Text('Description: ${product.description}')
              ],
            )

          )
          
        ],
      ),

    );
  }
}