import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'pages/home_page.dart';

void main() {
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
