import 'package:flutter/material.dart';

class FavItem extends StatelessWidget{
  const FavItem({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Item"),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_outlined))
      ),
      // body: Text("this is Favorite Item Page"),
    );
  }

}