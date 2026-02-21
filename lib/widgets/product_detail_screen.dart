import 'package:flutter/material.dart';
import 'dart:io';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  // --- FONCTION POUR AGRANDIR L'IMAGE ---
  void _showFullScreenImage(BuildContext context, File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: 'product_image_${product.name}',
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(imageFile),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool imageExists = false;
    try {
      if (product.image != null && product.image!.existsSync()) {
        imageExists = true;
      }
    } catch (e) {
      imageExists = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (imageExists)
                        _showFullScreenImage(context, product.image!);
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Hero(
                          tag: 'product_image_${product.name}',
                          child: imageExists
                              ? Image.file(product.image!, fit: BoxFit.cover)
                              : const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CATÉGORIE
                  _buildBadge(product.category.toUpperCase()),
                  const SizedBox(height: 15),

                  // NOM ET PRIX
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ),
                      Text(
                        "${product.price.toStringAsFixed(2)} €",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00B8D4),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- SECTION COULEURS DYNAMIQUE ---
                  if (product.availableColors.isNotEmpty) ...[
                    const Text(
                      "Couleurs disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: product.availableColors
                          .map((color) => _buildColorCircle(color))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  // Widget pour un badge de catégorie
  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1A237E),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget pour afficher un rond de couleur
  Widget _buildColorCircle(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: CircleAvatar(radius: 12, backgroundColor: color),
    );
  }

  // Widget pour le bouton en bas
  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${product.name} ajouté au panier !"),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "AJOUTER AU PANIER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
