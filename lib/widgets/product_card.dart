// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/Product_Detail_Screen.dart';

class ProductCard extends StatefulWidget {
  final Product product; // Le produit que cette carte doit afficher

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    // InkWell permet de rendre la carte cliquable avec un effet visuel (ripple)
    return InkWell(
      onTap: () {
        // Navigation vers la page de détails au clic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // Espace entre les cartes
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Bords arrondis modernes
          boxShadow: [
            // Ombre légère pour donner un effet de relief (élévation)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- SECTION IMAGE ---
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  // Hero permet une animation fluide de l'image entre deux écrans
                  child: Hero(
                    tag:
                        'hero_${widget.product.name}_${identityHashCode(widget.product)}',
                    // Vérification si l'image existe physiquement sur le téléphone
                    child:
                        widget.product.image != null &&
                            widget.product.image!.existsSync()
                        ? Image.file(widget.product.image!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 15), // Espacement entre l'image et le texte
              // --- SECTION INFORMATIONS (NOM, PRIX, ETC.) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Affichage de la catégorie en majuscules et style discret
                    Text(
                      widget.product.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E).withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Nom du produit avec limitation à 1 ligne pour garder le design propre
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Boucle pour afficher les petits points de couleurs disponibles
                    if (widget.product.availableColors.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Wrap(
                          spacing: 4,
                          children: widget.product.availableColors.map((color) {
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // Description courte
                    Text(
                      widget.product.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Affichage du prix formaté en Gourdes Haïtiennes (HTG)
                    Text(
                      "${widget.product.price.toStringAsFixed(2)} HTG",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(
                          0xFF00B8D4,
                        ), // Couleur cyan pour faire ressortir le prix
                      ),
                    ),
                  ],
                ),
              ),

              // Petite flèche indiquant que l'élément est cliquable
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFE0E0E0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
