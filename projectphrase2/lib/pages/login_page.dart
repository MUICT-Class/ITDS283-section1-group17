import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/register_page.dart';
import 'package:projectphrase2/widgets/fieldinput.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                "Login",
                style: TextStyle(fontSize: 56, fontWeight: FontWeight.w500),
              ),
              const Text(
                "login to your account",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              TextFieldInLog(
                  textEditingController: emailController,
                  hintText: "username",
                  icon: Icons.person),
              const SizedBox(height: 15),
              TextFieldInLog(
                  textEditingController: emailController,
                  hintText: "password",
                  icon: Icons.key),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot password?",
                    style:
                        TextStyle(color: const Color.fromARGB(255, 0, 127, 85)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(178, 0, 127, 85),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360)),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New user? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 127, 85)),
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
