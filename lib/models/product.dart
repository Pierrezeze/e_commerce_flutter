import 'dart:io';
import 'package:flutter/material.dart';

/// --- MODÈLE DE DONNÉES : PRODUCT ---
/// Cette classe définit ce qu'est un "Produit" dans ton application.
class Product {
  final String name; // Le nom de l'article
  final double price; // Le prix (stocké en double pour les décimales)
  final String description; // Une courte description
  final File? image; // L'image (File? signifie qu'elle peut être nulle)
  final String category; // La catégorie (ex: Electroniques)
  final List<Color> availableColors; // Une liste de couleurs Flutter (Color)

  // Constructeur : permet de créer une instance de Product
  Product({
    required this.name,
    required this.price,
    required this.description,
    this.image,
    required this.category,
    // Initialisé par défaut avec une liste vide pour éviter les erreurs d'affichage
    this.availableColors = const [],
  });
}

/// --- BASE DE DONNÉES TEMPORAIRE (MÉMOIRE VIVE) ---
/// 'globalProducts' est une liste statique accessible depuis n'importe quel fichier.
/// Note : Si tu relances l'application, cette liste est réinitialisée.
List<Product> globalProducts = [];
