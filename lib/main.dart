import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_projects/firebase_options.dart';
import 'package:flutter_firebase_projects/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 24)),
          snackBarTheme: const SnackBarThemeData(
            contentTextStyle: TextStyle(fontSize: 24),
          ),
        ),
        home: const HomePage(title: 'Picture Posts'),
      );
  }
}


