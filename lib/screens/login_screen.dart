import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey();
  bool isLoading = false;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: kPrimaryColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Form(
            key: formkey,
            child: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Image.asset(
                    "assets/images/scholar.png",
                    height: 100,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Scholar Chat",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: "pacifico",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextfield(
                    hint: "E-Mail",
                    onChange: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextfield(
                    obsecureText: true,
                    hint: "Password",
                    onChange: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                      text: "Login",
                      ontap: () async {
                        if (formkey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await userSignIn();
                            Navigator.pushNamed(context, ChatScreen.id,arguments: email);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              showSnackBar(context, "Invalid credential");
                            }
                          }
                          isLoading = false;
                          setState(() {});
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "don't have account ?    ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                          child: const Text(
                            "Register !",
                            style: TextStyle(
                                color: Color(0xffC7EDE6),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userSignIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
