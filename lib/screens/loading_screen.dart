import 'dart:async';
import 'package:flutter/material.dart';
import '../main_navigation.dart'; // Importation du conteneur de navigation principal

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0; // Gère la largeur de la barre (de 0.0 à 1.0)
  int _counter = 0; // Gère le texte affiché (de 0 à 100)

  @override
  void initState() {
    super.initState();
    _startLoading(); // Lance le compte à rebours dès l'affichage de l'écran
  }

  // --- LOGIQUE DU CHARGEMENT ---
  void _startLoading() {
    // Timer.periodic exécute un bloc de code à intervalles réguliers
    // Ici : 50ms * 100 pas = 5000ms (soit 5 secondes de chargement total)
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          if (_counter < 100) {
            _counter++;
            _progress = _counter / 100;
          } else {
            timer.cancel(); // Arrête le timer une fois arrivé à 100
            _navigateToHome(); // Redirige vers l'accueil
          }
        });
      }
    });
  }

  // --- NAVIGATION VERS L'ACCUEIL ---
  void _navigateToHome() {
    // pushReplacement retire le LoadingScreen de la pile pour qu'on ne puisse pas y revenir avec "Retour"
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
          // Dégradé de bleu pour correspondre à la charte graphique Tech Store
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône dynamique pour l'effet visuel
            const Icon(
              Icons.rocket_launch_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 40),

            // Affichage du pourcentage dynamique
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

            // --- BARRE DE PROGRESSION PERSONNALISÉE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Stack(
                children: [
                  // Fond gris translucide de la barre
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Partie remplie (évolue avec _progress)
                  FractionallySizedBox(
                    widthFactor: _progress,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        // Dégradé cyan pour un look "Tech"
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B8D4), Color(0xFF00E5FF)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          // Effet de néon/brillance
                          BoxShadow(
                            color: const Color(0xFF00B8D4).withOpacity(0.5),
                            blurRadius: 10,
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
