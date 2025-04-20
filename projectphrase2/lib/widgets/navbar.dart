import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/addItem.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/pages/favItem.dart';
import 'package:projectphrase2/pages/home_page.dart';
import 'package:projectphrase2/pages/usermanage_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home_icon.svg',
            width: 30,
            height: 30,
            color: Color.fromARGB(255, 99, 99, 99),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/heart_icon.svg',
            width: 30,
            height: 30,
            color: Color.fromARGB(255, 99, 99, 99),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 33,
            backgroundColor: const Color(0xFF4DA688),
            child: SvgPicture.asset(
              'assets/icons/add_icon.svg',
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/chat_icon.svg',
              width: 30,
              height: 30,
              color: Color.fromARGB(255, 99, 99, 99),
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile_icon.svg',
              width: 30,
              height: 30,
              color: Color.fromARGB(255, 99, 99, 99),
            ),
            label: ''),
      ],
    );
  }
}
