import 'dart:developer';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/utils/validation_utils.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool obscureText = true;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
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
                  CustomTextFormField(
                    hintText: 'confirm password',
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
                      confirmPassword = val;

                      log('confirmPassword $confirmPassword');
                    },
                    validator: (value) {
                      return ValidationUtils.validateConfirmPassword(
                          password, value);
                    },
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? Container(
                          height: 56,
                          width: 300,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : CustomButton(
                          title: 'Register',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              register();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  dismissDirection: DismissDirection.up,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).size.height - 150,
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


  Future <void> register()async{
    setState(() {
      isLoading= true;
    });
    try {
  final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email ,
    password: confirmPassword,
  );

  await saveUserToDatabase(credential.user!);

  setState(() {
    isLoading = false;
  });
} on FirebaseAuthException catch (e) {
   ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  dismissDirection: DismissDirection.up,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).size.height - 150,
                                    left: 10,
                                    right: 10,
                                  ),
                                  content:  Text('error: ${e.message}'),));

                                    setState(() {
                                      isLoading=false;
                                    });
    throw Exception(e);
  // if (e.code == 'weak-password') {
  //   log('The password provided is too weak. ${e.code}');
  //   log('The password provided is too weak. ${e.message}');

  // } else if (e.code == 'email-already-in-use') {
  //   log('The account already exists for that email.');
  // }
} catch (e) {
  log('message: $e');
  throw Exception(e);
}

setState(() {
  isLoading=false;
});
  }

Future <void> saveUserToDatabase (User user)async{
  try{
  final database = FirebaseFirestore.instance;
  final userCollection = database.collection('users');
  final sameId = userCollection.doc(user.uid);
  final userMap = {
    'email': user.email,
    'id': user.uid,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
  await sameId.set(userMap);
 
  // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return ChatView(email: email, userId: user.uid);
  //     }));
}
catch (e){
  log('saveUserTodatabase: $e');
  throw Exception(e);
}
}


}