import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Bibliothèque pour accéder à la galerie/appareil photo
import '../models/product.dart'; // Importation du modèle de données Produit

class AddProductScreen extends StatefulWidget {
  final VoidCallback?
  onSuccess; // Action à exécuter après un enregistrement réussi

  const AddProductScreen({super.key, this.onSuccess});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // --- CONTRÔLEURS DE SAISIE ---
  // Utilisés pour extraire le texte des champs de formulaire
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  // --- VARIABLES D'ÉTAT ---
  String _selectedCategory = 'Electroniques'; // Catégorie par défaut
  File? _image; // Fichier image stocké localement
  List<Color> _selectedColors =
      []; // Liste des couleurs cochées par l'utilisateur

  // Listes de données pour les menus et options
  final List<String> _categories = [
    'Electroniques',
    'Vetements',
    'Electro-menager',
    'Provision alimentaires',
  ];

  final List<Color> _colorOptions = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.grey,
  ];

  @override
  void dispose() {
    // NETTOYAGE : Détruire les contrôleurs pour éviter les fuites de mémoire
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- FONCTION : SÉLECTION DE L'IMAGE ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Ouvre la galerie du téléphone
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Met à jour l'UI avec l'image choisie
      });
    }
  }

  // --- FONCTION : LOGIQUE DE SAUVEGARDE ---
  void _saveProduct() {
    // Ferme le clavier virtuel
    FocusScope.of(context).unfocus();

    // Transformation du prix (remplace ',' par '.') pour conversion numérique
    String priceText = _priceController.text.replaceAll(',', '.');
    double? parsedPrice = double.tryParse(priceText);

    // 1. Validation de l'image (Obligatoire)
    if (_image == null) {
      _showSnackBar("📸 L'ajout d'une photo est obligatoire !", Colors.orange);
      return;
    }

    // 2. Validation du nom et du prix
    if (_nameController.text.trim().isEmpty ||
        parsedPrice == null ||
        parsedPrice <= 0) {
      _showSnackBar(
        "⚠️ Veuillez remplir le nom et un prix valide.",
        Colors.red,
      );
      return;
    }

    // 3. Validation de la description (Obligatoire)
    if (_descController.text.trim().isEmpty) {
      _showSnackBar(
        "📝 Veuillez ajouter une description au produit.",
        Colors.red,
      );
      return;
    }

    // 4. Création de l'objet Produit
    final newProduct = Product(
      name: _nameController.text.trim(),
      price: parsedPrice,
      description: _descController.text.trim(),
      category: _selectedCategory,
      image: _image,
      availableColors: List.from(
        _selectedColors,
      ), // Copie de la liste de couleurs
    );

    // Ajout à la base de données statique (liste globale)
    globalProducts.add(newProduct);

    // Déclenchement du callback de succès (ex: rafraîchir l'écran précédent)
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }

    _showSnackBar("✅ Produit enregistré avec succès !", Colors.green);

    // Réinitialisation du formulaire pour un nouvel ajout
    _resetFields();
  }

  // Helper pour afficher des alertes rapides (SnackBars)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Helper pour vider le formulaire
  void _resetFields() {
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    setState(() {
      _image = null;
      _selectedColors = [];
      _selectedCategory = 'Electroniques';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Nouveau Produit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION IMAGE ---
            _buildLabel("Image du produit *"),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // Bordure orange si l'image est absente
                    border: Border.all(
                      color: _image == null
                          ? Colors.orange.shade200
                          : Colors.grey.shade300,
                      width: _image == null ? 2 : 1,
                    ),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: 50,
                              color: Colors.orange.shade300,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Ajouter une photo (requis)",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- SECTION DÉTAILS (NOM, PRIX, DESCRIPTION) ---
            _buildLabel("Détails du produit"),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom du produit *",
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Prix (HTG) *",
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description *",
                hintText: "Décrivez les caractéristiques...",
                prefixIcon: Icon(Icons.description_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 25),

            // --- SECTION CATÉGORIE ---
            _buildLabel("Catégorie"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (newValue) =>
                      setState(() => _selectedCategory = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- SECTION COULEURS ---
            _buildLabel("Couleurs disponibles"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColors.contains(color);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? _selectedColors.remove(color)
                          : _selectedColors.add(color);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A237E)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 18,
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 18,
                              color: color == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // --- BOUTON DE VALIDATION ---
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "ENREGISTRER LE PRODUIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget personnalisé pour les titres de section
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color(0xFF1A237E),
      ),
    );
  }
}
