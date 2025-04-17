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
    required bool obscureText,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      obscureText: isPass,
      controller: textEditingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Icon(icon),
          labelText: hintText,
          // hintText: hintText,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          labelText: hintText,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
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

class TextFieldSearch extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final VoidCallback? onSearchPressed;

  const TextFieldSearch({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: onSearchPressed ??
                () {
                  print('Search icon pressed but no callback assigned');
                },
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 170, 170, 170)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 0, 127, 85)))),
    );
  }
}
