import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/login_page.dart';
<<<<<<< HEAD
//import 'pages/home_page.dart';

//import firecase
import 'package:firebase_core/firebase_core.dart';
import 'package:projectphrase2/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ต้องมาก่อน
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase Initialized Successfully');
  } catch (e) {
    print('❌ Firebase Initialization Error: $e');
  }
=======
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'pages/home_page.dart';
>>>>>>> d93ff5068b8703caef505b1330669134df08b4f5

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album CRUD Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      // routes: {},
    );
  }
}
