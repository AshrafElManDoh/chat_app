import 'package:chat_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey();

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
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                } else if (state is LoginSuccess) {
                  BlocProvider.of<ChatCubit>(context).receiveMessages();
                  Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (route) {
                    return false;
                  }, arguments: email);
                } else if (state is LoginFailure) {
                  showSnackBar(context, state.errmsg);
                }
              },
              builder: (context, state) => ModalProgressHUD(
                inAsyncCall: state is LoginLoading,
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
                        ontap: () {
                          if (formkey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                                LoginEvent(email: email!, password: password!));
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
