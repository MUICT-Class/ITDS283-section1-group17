import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectphrase2/services/database_service.dart';
import 'package:projectphrase2/pages/editprofile_page.dart';

class Profilecard extends StatefulWidget {
  final UserModel userModel;
  const Profilecard({required this.userModel, super.key});

  @override
  State<Profilecard> createState() => _ProfilecardState();
}

class _ProfilecardState extends State<Profilecard> {
  UserModel? _loadedUserModel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = widget.userModel.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('❌ uid is still null');
      return;
    }
    final data = await DatabaseService().loadUser(uid);
    try {
      if (data != null) {
        print('User: ${uid} data loaded');

        setState(() {
          _loadedUserModel = UserModel.fromMap(data, uid: uid);
        });
      }
    } catch (e) {
      print('there is an error: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedUserModel == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _loadedUserModel!.name ?? 'No name',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => EditprofilePage())),
                      icon: SvgPicture.asset(
                        'assets/icons/edit_icon.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Email   ${_loadedUserModel!.email}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Mobile   ${_loadedUserModel!.mobile}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
              ],
            )));
  }
}
