import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const AddProductScreen({super.key, this.onSuccess});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'Electroniques';
  File? _image;
  List<Color> _selectedColors = [];

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
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProduct() {
    FocusScope.of(context).unfocus();

    String priceText = _priceController.text.replaceAll(',', '.');
    double? parsedPrice = double.tryParse(priceText);

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

    final newProduct = Product(
      name: _nameController.text,
      price: parsedPrice,
      description: _descController.text,
      category: _selectedCategory,
      image: _image,
      availableColors: List.from(_selectedColors),
    );

    globalProducts.add(newProduct);

    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }

    // Reset du formulaire
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
      backgroundColor: const Color(0xFFF5F7FA), // Fond gris clair moderne
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
            const Text(
              "Image du produit",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
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

            // --- FORMULAIRE ---
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
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Prix (€)",
                hintText: "Ex: 12.99",
                prefixIcon: Icon(Icons.euro_symbol_rounded),
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

            // --- CATÉGORIE ---
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
                  items: _categories.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedCategory = newValue!);
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- COULEURS ---
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

            // --- BOUTON ENREGISTRER ---
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 60),
                elevation: 4,
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
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

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
