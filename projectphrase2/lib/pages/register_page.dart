import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/login_page.dart';
import 'package:projectphrase2/services/auth_service.dart';
import 'package:projectphrase2/widgets/fieldinput.dart';
import '../services/auth_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    // TODO: implement dispose
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void register() async {
    try {
      await authService.value.createAccount(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthLayout()),
        (route) => false,
      );
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
                  textEditingController: controllerEmail, hintText: 'Email'),
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
                      "Login",
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
