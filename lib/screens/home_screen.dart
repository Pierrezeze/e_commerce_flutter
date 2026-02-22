import 'package:flutter/material.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // --- CALCUL DES STATISTIQUES ---
    // On récupère le nombre total d'articles dans la liste globale
    int totalProducts = globalProducts.length;

    // On calcule la somme totale des prix en utilisant 'fold'
    // sum commence à 0, et on ajoute le prix de chaque item de la liste
    double totalValue = globalProducts.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      body: Stack(
        children: [
          // --- 1. DESIGN DE FOND (DÉGRADÉ) ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A237E), // Bleu nuit en haut
                  Color(0xFFF5F7FA), // Gris très clair pour le reste
                ],
                stops: [
                  0.0,
                  0.5,
                ], // Le bleu occupe les 50 premiers % de l'écran
              ),
            ),
          ),

          // --- 2. CONTENU PRINCIPAL ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // EN-TÊTE : Message de bienvenue et Icône
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Bienvenue sur",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "TECH STORE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      // Badge circulaire avec l'icône de boutique
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- SECTION STATISTIQUES (CARTES) ---
                  const Text(
                    "Vue d'ensemble",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Carte affichant le nombre de produits en stock
                      Expanded(
                        child: _buildStatCard(
                          title: "Produits",
                          value: totalProducts.toString(),
                          icon: Icons.inventory_2_rounded,
                          color: const Color(0xFF00B8D4),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Carte affichant la valeur monétaire totale en HTG
                      Expanded(
                        child: _buildStatCard(
                          title: "Valeur Totale",
                          value: "${totalValue.toStringAsFixed(2)} HTG",
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- BANNIÈRE DÉCORATIVE / INFO ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.rocket_launch,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Gérez votre stock",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // Sous-titre explicatif
                              Text(
                                "Suivez vos inventaires en temps réel.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET RÉUTILISABLE POUR LES CARTES DE STATISTIQUES ---
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône avec un fond coloré très léger
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 20),
          // 'FittedBox' évite que le texte déborde si le prix est trop long
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Libellé de la statistique
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
