import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/pages/product.dart';
import 'package:projectphrase2/widgets/navbar.dart';
import 'package:projectphrase2/widgets/profilecard.dart';
import 'package:projectphrase2/models/user_models.dart';

<<<<<<< HEAD
=======
// void main(){
//   runApp(app)
// }
>>>>>>> origin/usermanage
class UsermanagePage extends StatelessWidget {
  const UsermanagePage({super.key});

  void onTap(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => FavItem()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Additem()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Chat()));
    } else if (index == 4) {
      // Stay here
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
          leading: Icon(Icons.arrow_back_ios),
        ),
        bottomNavigationBar: Navbar(
          currentIndex: 4,
          onTap: (index) => onTap(index, context),
        ),
        body: Container(
            color: Color(0xFF389B72),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 1500,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 200,
                            left: 0,
                            right: 0,
                            bottom: 400,
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
                                  Profilecard(user: demoUser),
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
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => FavItem()));
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Product()));
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Itembar(
                                      text: "Sign out",
                                      color: Colors.red,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute( builder: (context) =>LoginPage()));
                                      },
                                      none: true,)
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
      required this.onTap, this.none});

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