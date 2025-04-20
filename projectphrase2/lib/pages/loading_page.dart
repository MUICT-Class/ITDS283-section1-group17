import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingAnimationWidget.waveDots(
          color: Color.fromARGB(255, 255, 255, 255),
          size: 150,
        ),
      ),
    );
  }
}
