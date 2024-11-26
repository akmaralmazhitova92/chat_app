import 'dart:developer';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utils/validation_utils.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '';
  String password = '';
  bool obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'flash',
                    child: SvgPicture.asset(
                      'assets/svg/flash.svg',
                      color: AppColors.amber,
                      height: 246,
                    ),
                  ),
                  const SizedBox(height: 54),
                  CustomTextFormField(
                    hintText: 'email',
                    onChanged: (String val) {
                      email = val;
              
                      log('email $email');
                    },
                    validator: ValidationUtils.validateEmail,
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    hintText: 'password',
                    obscureText: obscureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                    onChanged: (String val) {
                      password = val;
              
                      log('password $password');
                    },
                    validator: ValidationUtils.validatePassword,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    title: 'Sign in',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            dismissDirection: DismissDirection.up,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height - 150,
                              left: 10,
                              right: 10,
                            ),
                            content: const Text('KATA: Tuura jaz!'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future <void> signIn() async{
    try {
  final UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password
  );

   final userModel = await getUser(credential.user!.uid);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatView(email: userModel.email, userId: userModel.id);
      }));
      
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
  }

   Future<UserModel> getUser(String userid) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    final data = documentSnapshot.data();

    final userModel = UserModel.fromJson(data!);

    return userModel;
  }

  }