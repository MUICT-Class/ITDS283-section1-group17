import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/loading.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageIfNotConnected,
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
            stream: authService.authStateChanges,
            builder: (context, snapshot) {
              Widget widget;
              if (snapshot.connectionState == ConnectionState.waiting) {
                widget = Loading();
              } else if (snapshot.hasData) {
                widget = HomePage();
              } else {
                widget = pageIfNotConnected ?? const LoginPage();
              }
              return widget;
            });
      },
    );
  }
}
