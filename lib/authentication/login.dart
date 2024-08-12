import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
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
            TextField(
              controller: emailTextController,
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
            TextField(
              controller: passwordTextController,
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
                onPressed: () {},
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
                    'Sign in',
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
            Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: "Montserrat",
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: const Text(
                    ' Sign up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF287975),
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
