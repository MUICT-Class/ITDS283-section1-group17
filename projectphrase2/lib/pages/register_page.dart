import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/models/user_model.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/services/auth_service.dart';
import 'package:projectphrase2/widgets/fieldinput.dart';
import '../services/auth_layout.dart';
import 'package:projectphrase2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerMobile = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    // TODO: implement dispose
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerUsername.dispose();
    controllerMobile.dispose();
    super.dispose();
  }

  String? validatePhoneNumber(String value) {
    //Regular Expression for check mobile number
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  // String? validateMuictEmail(String value) {
  //   final muictEmailRegExp =
  //       RegExp(r'^[a-zA-Z0-9._%+-]+@student\.mahidol\.edu$');
  //   if (!muictEmailRegExp.hasMatch(value)) {
  //     return 'Email must be a valid student.mahidol.edu address';
  //   }
  //   return null;
  // }

  void register() async {
    try {
      // final email = controllerEmail.text;
      // String? emailValidation = validateMuictEmail(email);
      // if (emailValidation != null) {
      //   setState(() {
      //     errorMessage = emailValidation;
      //   });
      //   return;
      // }

      final phoneNumber = controllerMobile.text;

      // check mobile
      String? phoneValidation = validatePhoneNumber(phoneNumber);
      if (phoneValidation != null) {
        setState(() {
          errorMessage = phoneValidation;
        });
        return;
      }

      final res = await authService.value.createAccount(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      final uid = res.user?.uid;

      // store user data to Firestore
      if (uid != null) {
        final user = UserModel(
          uid: uid,
          email: controllerEmail.text,
          name: controllerUsername.text,
          mobile: controllerMobile.text,
        );

        await DatabaseService().saveUser(user.toMap());
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthLayout()),
        (route) => false,
      );
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: (const EdgeInsets.all(30.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              const Text(
                "Register",
                style: TextStyle(fontSize: 56, fontWeight: FontWeight.w500),
              ),
              const Text(
                "create your account",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              TextFieldInSign(
                textEditingController: controllerUsername,
                hintText: 'Username',
              ),
              const SizedBox(height: 15),
              TextFieldInSign(
                textEditingController: controllerEmail,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),
              TextFieldInSign(
                  textEditingController: controllerMobile, hintText: 'Mobile'),
              const SizedBox(height: 15),
              TextFieldInSign(
                  textEditingController: controllerPassword,
                  hintText: 'Password'),
              const SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.redAccent),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(178, 0, 127, 85),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360)),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(color: Color.fromARGB(255, 0, 127, 85)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
