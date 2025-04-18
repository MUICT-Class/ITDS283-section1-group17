import 'package:flutter/material.dart';
import 'package:projectphrase2/models/product.dart';
import 'package:projectphrase2/pages/displayproduct.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/login_page.dart';

import 'package:projectphrase2/pages/usermanage_page.dart';
import 'package:projectphrase2/widgets/product_display.dart';
import 'pages/home_page.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/widgets/navbar.dart';

//import firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:projectphrase2/pages/register_page.dart';
import 'package:projectphrase2/services/auth_layout.dart';
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album CRUD Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthLayout(),
      // home: Displayproduct(product: demoProduct),
      // routes: {},
    );
  }
}

// class MainPageWithNavbar extends StatefulWidget {
//   const MainPageWithNavbar({super.key});

//   @override
//   State<MainPageWithNavbar> createState() => _MainPageWithNavbarState();
// }

// class _MainPageWithNavbarState extends State<MainPageWithNavbar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [
//     HomePage(),
//     FavItem(),
//     Additem(),
//     Chat(),
//     UsermanagePage(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Navbar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped,
//       ),
//     );
//   }
// }
