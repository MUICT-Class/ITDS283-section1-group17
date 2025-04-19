import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              size: 30,
            ),
            label: ''),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 33,
            backgroundColor: Color(0xFF4DA688),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 30,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
              size: 30,
            ),
            label: ''),
      ],
    );
  }
}
