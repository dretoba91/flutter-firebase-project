import 'package:flutter/material.dart';
import 'package:flutter_firebase_projects/authentication/login.dart';
import 'package:flutter_firebase_projects/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    loadingChange();
  }

  loadingChange() async {
    final prefs = await SharedPreferences.getInstance();
    String? alreadyAuthenticated = prefs.getString('authenticated');
    if (alreadyAuthenticated != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(title: 'Firebase Project'),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app layer link
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
