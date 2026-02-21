import 'dart:async';
import 'package:flutter/material.dart';
import '../main_navigation.dart'; // <-- On importe MainNavigation au lieu de CatalogScreen

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    // 5000ms / 100 pas = 50ms par unité de pourcentage
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          if (_counter < 100) {
            _counter++;
            _progress = _counter / 100;
          } else {
            timer.cancel();
            _navigateToHome();
          }
        });
      }
    });
  }

  void _navigateToHome() {
    // On utilise MainNavigation pour retrouver le menu du bas
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation icône
            const Icon(
              Icons.rocket_launch_rounded, // Icône plus dynamique
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 40),

            // Chiffre du pourcentage
            Text(
              "$_counter %",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Initialisation du système...",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Barre de progression stylisée
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Stack(
                children: [
                  // Fond de la barre
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Partie remplie
                  FractionallySizedBox(
                    widthFactor: _progress,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B8D4), Color(0xFF00E5FF)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00B8D4).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
