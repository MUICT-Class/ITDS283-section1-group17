import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/chathistory_page.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/pages/product.dart';
import 'package:projectphrase2/services/auth_service.dart';
import 'package:projectphrase2/services/database_service.dart';
import 'package:projectphrase2/widgets/navbar.dart';
import 'package:projectphrase2/widgets/profilecard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectphrase2/pages/editprofile_page.dart';

class UsermanagePage extends StatefulWidget {
  const UsermanagePage({super.key});

  @override
  State<UsermanagePage> createState() => _UsermanagePageState();
}

class _UsermanagePageState extends State<UsermanagePage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final user = UserModel.fromMap(userData, uid: uid);

        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/arrow_left_icon.svg',
                  width: 30,
                  height: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0,
            ),
            body: Container(
                color: Color(0xFF389B72),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 900,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 200,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30))),
                                  padding: const EdgeInsets.only(
                                    top: 100,
                                    left: 30,
                                    right: 30,
                                  ),
                                  child: Column(
                                    children: [
                                      Profilecard(
                                        userModel: user,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Itembar(
                                        text: "Favorite Item",
                                        icon: SvgPicture.asset(
                                          'assets/icons/heart_icon.svg',
                                          width: 25,
                                          height: 25,
                                          color: Color(0xFF007F55),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FavItem()));
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Itembar(
                                        text: "Product Management",
                                        icon: SvgPicture.asset(
                                          'assets/icons/product_manage.svg',
                                          width: 25,
                                          height: 25,
                                          color: Color(0xFF007F55),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Product()));
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Itembar(
                                        text: "Chat History",
                                        icon: SvgPicture.asset(
                                          'assets/icons/chat_icon.svg',
                                          width: 25,
                                          height: 25,
                                          color: Color(0xFF007F55),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatHistory()));
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Itembar(
                                        text: "Sign out",
                                        color: Colors.red,
                                        onTap: () async {
                                          await AuthService().signOut();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()),
                                            (route) =>
                                                false, // ลบ route เก่าทิ้งทั้งหมด
                                          );
                                        },
                                        none: true,
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              top: 120,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 165,
                                  height: 165,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: user.imageUrl != null
                                          ? NetworkImage(user.imageUrl!)
                                          : AssetImage(
                                                  'assets/images/Softcover-Book-Mockup.jpg')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
      },
    );
  }
}

class Itembar extends StatelessWidget {
  final String text;
  final Color? color;
  final Widget? icon;
  final VoidCallback onTap;
  final bool? none;

  const Itembar(
      {super.key,
      required this.text,
      this.color,
      this.icon,
      required this.onTap,
      this.none});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon ?? Text("  "),
                        Text(
                          "  ${text}   ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: color ?? Colors.black,
                          ),
                        ),
                      ],
                    ),
                    none == true
                        ? SizedBox.shrink() // hides the icon when none is true
                        : SvgPicture.asset(
                            'assets/icons/arrow_right_icon.svg',
                            width: 25,
                            height: 25,
                            color: Color(0xFF007F55),
                          ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
