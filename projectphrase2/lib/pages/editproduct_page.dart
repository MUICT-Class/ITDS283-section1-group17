import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditproductPage extends StatefulWidget {
  const EditproductPage({super.key});

  @override
  State<EditproductPage> createState() => editproducteState();
}

class editproductState extends State<EditproductPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String? get uid => FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;
  File? _selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    imageUrlController.dispose();
    super.dispose();
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
          FirebaseStorage.instance.ref().child('user_images/$fileName.jpg');
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
                  _selectedImage = null;
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
  }

  void _onSave() async {
    print("Start saving user...");
    print("UID: $uid");

    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();

    String? finalImageUrl;
    if (_selectedImage != null) {
      print("Uploading selected image...");
      finalImageUrl = await uploadImageToFirebase(_selectedImage!);
      print("Image uploaded: $finalImageUrl");
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      finalImageUrl = imageUrl;
    }

    if (uid == null) return;

    Map<String, dynamic> updateData = {};
    if (name.isNotEmpty) updateData['name'] = name;
    if (mobile.isNotEmpty) updateData['mobile'] = mobile;
    if (finalImageUrl != null && finalImageUrl.isNotEmpty) {
      updateData['imageUrl'] = finalImageUrl;
    }

    // ไม่แตะต้อง email เด็ดขาด

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
      final ref = FirebaseFirestore.instance.collection('users').doc(uid);
      await ref.set(updateData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated!"),
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
        title: Text("Edit profile"),
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
              inputname: "Username",
              labelname: "username",
              controller: nameController,
            ),
            SizedBox(height: 5),
            InputBox(
              inputname: "Mobile",
              labelname: "Phone number",
              controller: mobileController,
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
