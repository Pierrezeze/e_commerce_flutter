import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String? _selectedCategory;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _selectedCategory ?? "Nos Catégories",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _searchQuery = "";
                    _searchController.clear();
                  });
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // Barre de recherche
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

          // Contenu variable
          Expanded(
            child: _selectedCategory == null
                ? _buildFilteredCategoryGrid()
                : _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredCategoryGrid() {
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
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: filteredCats.length,
      itemBuilder: (context, index) {
        final cat = filteredCats[index];
        return InkWell(
          onTap: () => setState(() {
            _selectedCategory = cat['name'];
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

  Widget _buildProductList() {
    final filteredProducts = globalProducts.where((product) {
      final matchesCategory = product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            const Text("Aucun produit trouvé dans cette catégorie"),
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
      // La Key est ESSENTIELLE pour éviter l'écran noir lors du rafraîchissement
      itemBuilder: (context, index) => ProductCard(
        key: ValueKey(filteredProducts[index].name + index.toString()),
        product: filteredProducts[index],
      ),
    );
  }
}
