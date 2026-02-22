import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // --- VARIABLES D'ÉTAT ---
  String? _selectedCategory; // Stocke la catégorie choisie (null = vue grille)
  String _searchQuery = ""; // Stocke le texte tapé dans la barre de recherche
  final TextEditingController _searchController = TextEditingController();

  // Liste des catégories avec leurs icônes et couleurs respectives
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electroniques', 'icon': Icons.devices, 'color': Colors.blue},
    {'name': 'Vetements', 'icon': Icons.checkroom, 'color': Colors.orange},
    {'name': 'Electro-menager', 'icon': Icons.kitchen, 'color': Colors.green},
    {
      'name': 'Provision alimentaires',
      'icon': Icons.local_grocery_store,
      'color': Colors.red,
    },
  ];

  @override
  void dispose() {
    // Très important : on libère la mémoire du contrôleur quand l'écran est détruit
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        // Le titre change dynamiquement selon si on est dans une catégorie ou non
        title: Text(
          _selectedCategory ?? "Nos Catégories",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        // Affiche un bouton retour uniquement si une catégorie est sélectionnée
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null; // Retour à la vue grille
                    _searchQuery = "";
                    _searchController.clear();
                  });
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // --- BARRE DE RECHERCHE ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: _selectedCategory == null
                    ? "Chercher une catégorie..."
                    : "Chercher dans $_selectedCategory...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1A237E)),
                // Bouton "X" pour effacer la recherche, visible seulement si on a tapé quelque chose
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // --- CONTENU VARIABLE (GRILLE OU LISTE) ---
          Expanded(
            child: _selectedCategory == null
                ? _buildFilteredCategoryGrid() // Affiche les carrés de catégories
                : _buildProductList(), // Affiche la liste des produits
          ),
        ],
      ),
    );
  }

  // --- VUE 1 : GRILLE DES CATÉGORIES ---
  Widget _buildFilteredCategoryGrid() {
    // Filtre la liste des catégories selon la recherche
    final filteredCats = _categories.where((cat) {
      return cat['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
    }).toList();

    if (filteredCats.isEmpty) {
      return const Center(child: Text("Aucune catégorie trouvée"));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colonnes
        crossAxisSpacing: 15, // Espace horizontal
        mainAxisSpacing: 15, // Espace vertical
      ),
      itemCount: filteredCats.length,
      itemBuilder: (context, index) {
        final cat = filteredCats[index];
        return InkWell(
          onTap: () => setState(() {
            _selectedCategory = cat['name']; // On "entre" dans la catégorie
            _searchQuery = "";
            _searchController.clear();
          }),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'], color: cat['color'], size: 40),
                const SizedBox(height: 10),
                Text(
                  cat['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- VUE 2 : LISTE DES PRODUITS FILTRÉS ---
  Widget _buildProductList() {
    // On filtre globalProducts selon la catégorie ET la recherche textuelle
    final filteredProducts = globalProducts.where((product) {
      final matchesCategory = product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    // Si aucun produit ne correspond
    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            const Text("Aucun produit trouvé"),
            TextButton(
              onPressed: () => setState(() => _selectedCategory = null),
              child: const Text("Retour aux catégories"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      itemCount: filteredProducts.length,
      // ValueKey est crucial ici pour que Flutter reconstruise correctement les cartes
      itemBuilder: (context, index) => ProductCard(
        key: ValueKey(filteredProducts[index].name + index.toString()),
        product: filteredProducts[index],
      ),
    );
  }
}
