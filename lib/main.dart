import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe Multiplayer',
      theme: ThemeData(
        primarySwatch: Colors.grey, // Minimalist black (use grey with a black tone)
        appBarTheme: AppBarTheme(
          color: Colors.black, // AppBar color set to black
          iconTheme: IconThemeData(
            color: Colors.white, // Back button color set to white
          ),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // AppBar title color to white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black, // Button color set to black
            onPrimary: Colors.white, // Text color for buttons set to white
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
