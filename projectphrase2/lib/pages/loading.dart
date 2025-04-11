import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.waveDots(
          color: Color.fromARGB(178, 0, 127, 85),
          size: 150,
        ),
      ),
    );
  }
}
