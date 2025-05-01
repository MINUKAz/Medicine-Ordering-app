import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled3/profile.dart';
import 'SplashScreen.dart';
import 'Userinfopage.dart';
import 'profile.dart';
import 'userinfopage.dart';
import 'productpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDGiw_qxGGDv6ZEjQDLyqZl5s9FwOItjxc", // Replace with your Firebase API key
      appId: "1:953286574936:android:69a53171fb6eb326005b2d", // Replace with your Firebase App ID
      messagingSenderId: "953286574936", // Replace with your Messaging Sender ID
      projectId: "medicine-delivery-5aa24", // Replace with your Firebase Project ID
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medicine Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial page
    );
  }
}