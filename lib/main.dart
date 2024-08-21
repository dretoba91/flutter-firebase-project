// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_projects/firebase_options.dart';
import 'package:flutter_firebase_projects/screens/splash.dart';
import 'package:flutter_firebase_projects/services/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationApi().initNotifications();
  // await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 24)),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(fontSize: 24),
        ),
      ),
      home: const Splash(),
    );
  }
}
