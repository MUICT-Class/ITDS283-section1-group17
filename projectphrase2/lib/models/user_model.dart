import 'dart:convert';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? mobile;
  final String? imageUrl;

  UserModel({this.uid, this.name, this.email, this.imageUrl, this.mobile});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return UserModel(
      uid: uid,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>,
          uid: ""); // Placeholder for uid
}
