import 'package:flutter/material.dart';

class TextFieldInLog extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData icon;

  const TextFieldInLog({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      obscureText: isPass,
      controller: textEditingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 170, 170, 170)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 0, 127, 85)))),
    );
  }
}

class TextFieldInSign extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;

  const TextFieldInSign({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      obscureText: isPass,
      controller: textEditingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 170, 170, 170)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 0, 127, 85)))),
    );
  }
}
