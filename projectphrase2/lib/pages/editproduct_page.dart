import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product_model.dart'; // Assuming you have a ProductModel
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String? imageUrl;
  File? _selectedImage;
  String? productId;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    productId = widget.productId;
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    try {
      final productRef =
          FirebaseFirestore.instance.collection('products').doc(productId);
      final productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        final product = productSnapshot.data();
        nameController.text = product?['name'] ?? '';
        priceController.text = product?['price'] ?? '';
        descriptionController.text = product?['description'] ?? '';
        imageUrl = product?['imageUrl'];
        setState(() {});
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageUrl = null;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageUrl = null;
      });
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('product_images/$fileName.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

  void _onSave() async {
    print("Start saving product...");
    print("Product ID: $productId");

    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final description = descriptionController.text.trim();

    String? finalImageUrl;
    if (_selectedImage != null) {
      print("Uploading selected image...");
      finalImageUrl = await uploadImageToFirebase(_selectedImage!);
      print("Image uploaded: $finalImageUrl");
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      finalImageUrl = imageUrl;
    }

    if (productId == null || productId!.isEmpty) {
      print("Error: Product ID is null or empty.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid product ID."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> updateData = {};
    if (name.isNotEmpty) updateData['name'] = name;
    if (price.isNotEmpty) {
      try {
        updateData['price'] =
            int.parse(price); // Ensure price is stored as an integer
      } catch (e) {
        print("Error parsing price: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid price format."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    if (description.isNotEmpty) updateData['description'] = description;
    if (finalImageUrl != null && finalImageUrl.isNotEmpty) {
      updateData['imageUrl'] = finalImageUrl;
    }

    if (updateData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No changes to save."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final ref =
          FirebaseFirestore.instance.collection('products').doc(productId);
      await ref.set(updateData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product updated!"),
          backgroundColor: Color.fromARGB(255, 0, 127, 85),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print("Firebase error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      backgroundColor: Colors.white,
                      title: Text('Upload Photo'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _pickImageFromCamera();
                          },
                          child: Text('📷 Camera'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _pickImageFromGallery();
                          },
                          child: Text('🖼️ Gallery'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(imageUrl!, fit: BoxFit.cover)
                          : Center(
                              child: Icon(Icons.image,
                                  size: 60, color: Colors.grey)),
                ),
              ),
            ),
            SizedBox(height: 20),
            InputBox(
              inputname: "Product Name",
              labelname: "Product name",
              controller: nameController,
            ),
            SizedBox(height: 5),
            InputBox(
              inputname: "Price",
              labelname: "Price",
              controller: priceController,
            ),
            SizedBox(height: 5),
            InputBox(
              inputname: "Description",
              labelname: "Product description",
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
      child:
          Text("Update", style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}

class InputBox extends StatelessWidget {
  final String inputname;
  final String labelname;
  final TextEditingController controller;
  final String? errorText;

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
