import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();
  static String id = "RegisterScreen";
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
            key: formKey,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is RegisterLoading) {
                } else if (state is RegisterSuccess) {
                  Navigator.pop(context);
                } else if (state is RegisterFailure) {
                  showSnackBar(context, state.errmsg);
                }
              },
              builder: (context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is RegisterLoading,
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
                        "Register",
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
                        hint: "Password",
                        onChange: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        text: "Register",
                        ontap: () async {
                          if (formKey.currentState!.validate()) {
                            await BlocProvider.of<AuthCubit>(context)
                                .register(email: email!, password: password!);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account ?    ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login !",
                              style: TextStyle(
                                  color: Color(0xffC7EDE6),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
