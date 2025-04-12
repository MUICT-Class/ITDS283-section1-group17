import 'package:flutter/material.dart';

class FavItem extends StatelessWidget {
  const FavItem({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Favorite Items"),
      ),
    );
  }
}
