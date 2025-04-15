import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _fire = FirebaseFirestore.instance;

  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      await _fire.collection("users").doc(userData["uid"]).set(userData);

      print("user saved");
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loadUser(String uid) async {
    try {
      final res = await _fire.collection("users").doc(uid).get();

      if (res.data() != null) {
        print("user fetched");
        return res.data();
      }
    } catch (e) {
      rethrow;
    }
  }
}
