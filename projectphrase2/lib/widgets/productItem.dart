import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product.dart';

class Productitem extends StatelessWidget {
  final ProductModel product;
  const Productitem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    print('🧩 Productitem: ${product.name} | ID: ${product.id}');
    return Card(
      color: Color.fromARGB(255, 213, 213, 213),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      product.photoURL ?? 'assets/images/default.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Name: ${product.name}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Price: ${product.price}'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Description: ${product.description}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text('ID: ${product.id ?? "null"}',
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
