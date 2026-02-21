import 'dart:io';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String description;
  final File? image;
  final String category;
  final List<Color> availableColors;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.image,
    required this.category,
    // On peut ajouter une liste vide par défaut pour éviter les erreurs nulles
    this.availableColors = const [],
  });
}

// Ta liste globale initialisée
List<Product> globalProducts = [];
