import 'package:firebase_auth/firebase_auth.dart';
class UserModels {
  final String name;
  final String email;

  UserModels({
    required this.name,
    required this.email,
  });
}

final demoUser = UserModels(
  name: FirebaseAuth.instance.currentUser?.displayName ?? 'Thanakrit Smith',
  email: FirebaseAuth.instance.currentUser?.email ?? 'firstname.las@student.mahidol.ac.th',
);
