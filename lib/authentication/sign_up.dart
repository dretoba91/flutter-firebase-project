// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_projects/screens/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final fullnameTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Email validation
  String? validateEmail(String? value) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password  validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    return null;
  }

  Future _createWithEmailAndPassword() async {
    final prefs = await SharedPreferences.getInstance();
    var message = '';
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF287975),
        ),
      ),
    );

    try {
      // creating user with Email and Password
      final userResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Creating a User collection in the Firestore database
      User user = userResult.user!;
      user.updateDisplayName(fullnameTextController.text);
      if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
        prefs.setString('authenticated', 'isAuthenticated');
      }

      Future.delayed(const Duration(milliseconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(title: 'Firebase Posts')),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/firebase.png',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: fullnameTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your fullname';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Fullname',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                controller: emailTextController,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordTextController,
                validator: validatePassword,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createWithEmailAndPassword();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF287975),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Center(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: "Montserrat",
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Center(
              //     child: Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Don't have an account? ",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           color: Color(0xFF000000),
              //           fontFamily: "Montserrat",
              //           fontSize: 13,
              //           fontWeight: FontWeight.w500),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         // Navigator.push(context,
              //         //     MaterialPageRoute(builder: (context) => SignUp()));
              //       },
              //       child: const Text(
              //         ' Sign up',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             color: Color(0xFF287975),
              //             fontFamily: "Montserrat",
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500),
              //       ),
              //     )
              //   ],
              // ))
            ],
          ),
        ),
      ),
    );
  }
}
