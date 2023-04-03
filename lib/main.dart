import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pr8_2/res/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/Screens/Home_page.dart';
import 'Views/Screens/Login.dart';
import 'Views/Screens/splash_screen.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Global.isLogged = prefs.getBool('isLogged') ?? false;
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'S_Screen',
      routes: {
        '/': (context) => const HomePage(),
        'login': (context) => const LoginPage(),
        'S_Screen': (context) => Splashscreen(),
      },
    ),
  );
}
