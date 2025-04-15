import 'package:flutter/material.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profilecard extends StatelessWidget {
  final UserModel user;

  const Profilecard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        elevation: 4,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Color(0xFF90C3AE),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(user.name ?? 'No name',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.black)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Email   ${user.email ?? FirebaseAuth.instance.currentUser?.email ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  "Mobile   ${user.mobile}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            )));
  }
}
