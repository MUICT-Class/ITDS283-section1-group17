import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/product_detail_page.dart';

class ProductDisplay extends StatelessWidget {
  const ProductDisplay({super.key});

  @override
  Widget build(BuildContext context) {
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
                  width: 180,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/Softcover-Book-Mockup.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite, color: Colors.red, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Books & Stationeries',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 0),
            const Text(
              'Book Test 1',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            const Text('\$360.00',
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
