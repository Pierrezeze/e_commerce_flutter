import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Pour choisir des photos
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  final VoidCallback? onSuccess; // Callback déclenché après un ajout réussi

  const AddProductScreen({super.key, this.onSuccess});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // --- CONTRÔLEURS DE TEXTE ---
  // Permettent de récupérer les valeurs saisies par l'utilisateur
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  // --- ÉTAT DU FORMULAIRE ---
  String _selectedCategory = 'Electroniques';
  File? _image; // Stocke le fichier image sélectionné
  List<Color> _selectedColors =
      []; // Liste des couleurs choisies pour le produit

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
    // NETTOYAGE : Libère la mémoire des contrôleurs quand on quitte l'écran
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- LOGIQUE : SÉLECTION D'IMAGE ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Ouvre la galerie du téléphone
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Met à jour l'aperçu
      });
    }
  }

  // --- LOGIQUE : SAUVEGARDE ---
  void _saveProduct() {
    // Ferme le clavier automatiquement
    FocusScope.of(context).unfocus();

    // Gestion du format de prix (remplace virgule par point pour le calcul)
    String priceText = _priceController.text.replaceAll(',', '.');
    double? parsedPrice = double.tryParse(priceText);

    // VALIDATION : Vérifie si les champs obligatoires sont remplis
    if (_nameController.text.isEmpty ||
        parsedPrice == null ||
        parsedPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer un nom et un prix valide"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // CRÉATION de l'objet Produit
    final newProduct = Product(
      name: _nameController.text,
      price: parsedPrice,
      description: _descController.text,
      category: _selectedCategory,
      image: _image,
      availableColors: List.from(_selectedColors),
    );

    // Ajout à la liste globale statique
    globalProducts.add(newProduct);

    // Informe le widget parent que l'ajout est réussi (pour rafraîchir l'UI)
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }

    // RÉINITIALISATION du formulaire pour un nouvel ajout
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
            // --- ZONE DE SÉLECTION D'IMAGE ---
            _buildLabel("Image du produit"),
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
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ajouter une photo",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- CHAMPS DE TEXTE ---
            _buildLabel("Détails du produit"),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom du produit",
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(height: 15),

            // Champ Prix configuré pour la monnaie locale (HTG)
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Prix (HTG)",
                hintText: "Ex: 1500.00",
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
                labelText: "Description",
                prefixIcon: Icon(Icons.description_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 25),

            // --- SÉLECTION DE CATÉGORIE (DROPDOWN) ---
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

            // --- CHOIX DES COULEURS (WRAP) ---
            _buildLabel("Couleurs disponibles"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColors.contains(color);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected
                        ? _selectedColors.remove(color)
                        : _selectedColors.add(color);
                  }),
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

            // --- BOUTON DE VALIDATION FINAL ---
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

  // --- PETIT HELPER POUR LES TITRES DE SECTION ---
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
