import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product.dart';
import 'package:projectphrase2/pages/product.dart';

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  String? priceError;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    priceController.addListener(() {
      final text = priceController.text.trim();
      if (text.isEmpty || int.tryParse(text) != null) {
        setState(() {
          priceError = null;
        });
      } else {
        setState(() {
          priceError = "Price must be a number.";
        });
      }
    });
  }

  void _onSave() async {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        priceError != null) {
      return;
    }

    final product = ProductModel(
      name: name,
      price: int.parse(price),
      description: description,
      photoURL: null,
    );

    try {
      final ref = await FirebaseFirestore.instance.collection('products').add({
        ...product.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'id': '', // ชั่วคราว เพื่อให้ได้ ref.id ก่อน
      });

      await ref.update({'id': ref.id});

      // เก็บ productId ที่ได้จาก Firestore
      final productId = ref.id;
      print("Product created with ID: $productId");

      // ส่ง productId ไปยัง ProductModel
      final newProduct = product.copyWith(id: productId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item added to Firebase!"),
          backgroundColor: Colors.green,
        ),
      );

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
    } catch (e) {
      print("Firebase error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            InputBox(
              inputname: "Name",
              labelname: "Product Name",
              controller: nameController,
            ),
            SizedBox(height: 5),
            InputBox(
              inputname: "Price",
              labelname: "THB",
              controller: priceController,
              errorText: priceError,
            ),
            SizedBox(height: 5),
            InputBox(
              inputname: "Description",
              labelname: "Description",
              controller: descriptionController,
            ),
            SizedBox(height: 20),
            SaveButton(onPressed: _onSave),
          ],
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(178, 0, 127, 85),
        minimumSize: Size(double.infinity, 60),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text("Save", style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}

class InputBox extends StatelessWidget {
  final String inputname;
  final String labelname;
  final TextEditingController controller;
  final String? errorText; //

  const InputBox({
    super.key,
    required this.inputname,
    required this.labelname,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(inputname, style: TextStyle(fontSize: 15)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType:
                labelname == "THB" ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: labelname,
              hintStyle: TextStyle(color: Colors.grey),
              errorText: errorText, // 👈 show red error label here
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 0, 127, 85)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
