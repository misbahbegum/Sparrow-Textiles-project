import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:godownmanager/screens/category.dart';
import 'package:godownmanager/widgets/drawer.dart';
import 'package:godownmanager/screens/home.dart';
import 'package:godownmanager/screens/login.dart';
import 'package:godownmanager/screens/registration.dart';
import 'package:godownmanager/utils/myroutes.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: category(),
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.homeRoustes: (context) => const home(),
        MyRoutes.loginRoustes: (context) => login(),
        MyRoutes.drawerRoustes: (context) => const mydrawer(),
        MyRoutes.registrationRoustes: (context) => const registration(),
        MyRoutes.categoryRoustes: (context) => const category(),
      },
    );
  }
}
