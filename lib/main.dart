import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Store App',

      // Définition du thème moderne
      theme: ThemeData(
        useMaterial3: true,
        // Palette de couleurs principale
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Dark Blue
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF00B8D4), // Cyan
          surface: Colors.white,
        ),

        // Style des AppBar sur tout le projet
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        // Style par défaut des champs de texte (TextFormField)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF1A237E)),
        ),

        // Style global pour les boutons Elevated
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),

      // Point de départ : Page de connexion
      home: const LoginScreen(),
    );
  }
}
