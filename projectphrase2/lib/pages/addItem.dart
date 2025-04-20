import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectphrase2/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectphrase2/pages/loading_page.dart';

class Additem extends StatefulWidget {
  const Additem({super.key});

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String? priceError;
  String? imageUrl;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  // Pick image from Camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageUrl = null; // Reset URL if new image is selected
      });
    }
  }

  // Pick image from Gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageUrl = null; // Reset URL if new image is selected
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

  void _showUrlInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Enter Image URL'),
        content: TextField(
          controller: imageUrlController,
          decoration: InputDecoration(hintText: 'https://...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  imageUrl = imageUrlController.text.trim();
                  _selectedImage = null; // Reset image selection if URL is used
                });
                Navigator.pop(context);
              },
              child: Text('OK',
                  style: TextStyle(color: Color.fromARGB(255, 0, 127, 85)))),
        ],
      ),
    );
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

  // Save the product to Firestore
  void _onSave() async {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final description = descriptionController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    // Ensure price is valid
    final parsedPrice = int.tryParse(price);
    if (parsedPrice == null) {
      print("Invalid price input");
      return; // Exit early if the price is invalid
    }

    setState(() {
      _isLoading = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingPage(),
    );

    String? finalImageUrl;
    if (_selectedImage != null) {
      try {
        print(_selectedImage);
        print("Uploading image to Firebase...");
        finalImageUrl = await uploadImageToFirebase(_selectedImage!);
        print("Image uploaded: $finalImageUrl");
      } catch (e) {
        print("Image upload error: $e");
        finalImageUrl = null; // Handle error by not setting an image URL
      }
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      finalImageUrl = imageUrl;
    }

    if (name.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        priceError != null) {
      print("Missing fields or invalid price");
      Navigator.of(context).pop(); // ปิดหน้า Loading
      setState(() {
        _isLoading = false;
      });
      return; // Exit early if any field is empty or price is invalid
    }

    final product = ProductModel(
      name: name,
      price: parsedPrice,
      description: description,
      userId: user?.uid,
      photoURL: finalImageUrl,
    );

    try {
      final ref = await FirebaseFirestore.instance.collection('products').add({
        ...product.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'id': '',
      });

      await ref.update({'id': ref.id});
      final productId = ref.id;
      print("Product created with ID: $productId");

      final newProduct = product.copyWith(id: productId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item added to Firebase!"),
          backgroundColor: Color.fromARGB(255, 0, 127, 85),
        ),
      );
      Navigator.of(context).pop(); // ปิดหน้า Loading
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context); // กลับไปหน้าก่อนหน้า

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
    } catch (e) {
      print("Firebase error: $e");
      Navigator.of(context).pop(); // ปิดหน้า Loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow_left_icon.svg',
            width: 30,
            height: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _showUrlInputDialog();
                          },
                          child: Text('🔗 image link'),
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
            maxLength: inputname == "Name"
                ? 25
                : null, // Limit to 25 chars for Name only
            keyboardType:
                labelname == "THB" ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: labelname,
              hintStyle: TextStyle(color: Colors.grey),
              errorText: errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
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
