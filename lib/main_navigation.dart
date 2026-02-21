import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/login_screen.dart';
import 'models/product.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // --- CLÉ DE RAFRAÎCHISSEMENT ---
  // Essentielle pour forcer le Catalogue à se redessiner après un ajout ou un tri
  int _refreshKey = 0;

  // Fonction pour trier les produits
  void _sortProducts(String criteria) {
    setState(() {
      if (criteria == 'name') {
        globalProducts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      } else if (criteria == 'price') {
        globalProducts.sort((a, b) => a.price.compareTo(b.price));
      }

      _refreshKey++; // On change la clé pour forcer le rafraîchissement
      _selectedIndex = 1; // On bascule sur l'onglet catalogue
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Produits triés par ${criteria == 'name' ? 'nom' : 'prix'}",
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1A237E),
      ),
    );
  }

  // CALLBACK : Appelée quand un produit est ajouté avec succès dans AddProductScreen
  void _onProductAdded() {
    setState(() {
      _refreshKey++; // Force la reconstruction propre du catalogue avec les nouvelles données
      _selectedIndex = 1; // Bascule automatiquement sur l'onglet catalogue
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Produit ajouté avec succès !"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fonction de déconnexion avec dialogue de confirmation
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment quitter l'application ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULER"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme le dialogue
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("OUI", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // La liste des pages est reconstruite à chaque build pour prendre en compte le refreshKey
    final List<Widget> _pages = [
      const HomeScreen(),
      CatalogScreen(
        key: ValueKey(_refreshKey),
      ), // La clé force le rafraîchissement ici
      AddProductScreen(
        onSuccess: _onProductAdded,
      ), // On passe le callback de succès
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TECH STORE",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1A237E)),
              accountName: Text("Utilisateur Tech Store"),
              accountEmail: Text("contact@techstore.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF1A237E)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("À propos"),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: "TECH STORE",
                  applicationVersion: "1.0.0",
                  applicationIcon: const Icon(
                    Icons.store,
                    size: 40,
                    color: Color(0xFF1A237E),
                  ),
                  children: [
                    const Text("Votre boutique high-tech de référence."),
                    const SizedBox(height: 10),
                    const Text("Développé avec Flutter en 2026."),
                  ],
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
              child: Text(
                "Filtrer par :",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text("Nom du produit"),
              onTap: () {
                Navigator.pop(context);
                _sortProducts('name');
              },
            ),
            ListTile(
              leading: const Icon(Icons.euro),
              title: const Text("Prix (Croissant)"),
              onTap: () {
                Navigator.pop(context);
                _sortProducts('price');
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
                _logout(context); // Appelle la fonction de déconnexion
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1A237E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Catalogue"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Ajouter",
          ),
        ],
      ),
    );
  }
}
