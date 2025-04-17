import 'package:flutter/material.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/pages/product.dart';
import 'package:projectphrase2/services/auth_service.dart';
import 'package:projectphrase2/services/database_service.dart';
import 'package:projectphrase2/widgets/navbar.dart';
import 'package:projectphrase2/widgets/profilecard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsermanagePage extends StatefulWidget {
  const UsermanagePage({super.key});

  @override
  State<UsermanagePage> createState() => _UsermanagePageState();
}

class _UsermanagePageState extends State<UsermanagePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DatabaseService().loadUser(uid).then((fetchedUser) {
        if (fetchedUser != null) {
          setState(() {
            user = UserModel.fromMap(fetchedUser);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
<<<<<<< HEAD
                                    user: user ??
                                        UserModel(
                                          name: 'No name',
                                          email: FirebaseAuth.instance
                                                  .currentUser?.email ??
                                              'No email',
                                          mobile: FirebaseAuth.instance
                                                  .currentUser?.phoneNumber ??
                                              '',
                                        ),
=======
                                    user: demoUser,
>>>>>>> origin/usermanage
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Itembar(
                                    text: "Favorite Item",
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Color(0xFF007F55),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FavItem()));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Itembar(
                                    text: "Product Management",
                                    icon: Icon(
                                      Icons.inventory_2_outlined,
                                      color: Color(0xFF007F55),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Product()));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Itembar(
                                    text: "Chat",
                                    icon: Icon(Icons.chat_bubble_outline,
                                        color: Color(0xFF007F55)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chat()));
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
                                            builder: (context) => LoginPage()),
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
                            child: CircleAvatar(
                              radius: 90,
                              backgroundColor: Color(0xFFD9D9D9),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

class Itembar extends StatelessWidget {
  final String text;
  final Color? color;
  final Icon? icon;
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
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                            fontSize: 18,
                            color: color ?? Colors.black,
                          ),
                        ),
                      ],
                    ),
                    none == true
                        ? SizedBox.shrink() // hides the icon when none is true
                        : Icon(
                            Icons.arrow_forward_ios,
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
