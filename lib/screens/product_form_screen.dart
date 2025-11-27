import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  // Contrôleurs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String? _selectedCategoryId;
  late Future<List<Category>> _categoriesFuture;
  
  bool get isEditing => widget.product != null;
  // Définition de l'ID de la boutique pour la simplification
  final String _businessId = 'B_DEFAULT_123'; 

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _productService.getCategories();
    
    // Pré-remplir les champs pour l'édition
    if (isEditing) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.availableStock.toString();
      _selectedCategoryId = widget.product!.categoryId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      // 1. Créer le nouvel objet Produit
      final newProduct = Product(
        id: isEditing ? widget.product!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        categoryId: _selectedCategoryId!,
        businessId: _businessId, 
        price: double.tryParse(_priceController.text) ?? 0.0,
        availableStock: int.tryParse(_stockController.text) ?? 0,
      );

      // 2. Appeler le service (CREATE ou UPDATE)
      if (isEditing) {
        await _productService.updateProduct(newProduct);
      } else {
        await _productService.createProduct(newProduct);
      }
      
      // 3. Retourner à la liste et rafraîchir
      // Renvoie 'true' pour que l'écran précédent sache qu'il doit rafraîchir
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier Produit' : 'Nouveau Produit', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Champ Nom
              _buildTextField(_nameController, 'Nom du produit', Icons.label),
              const SizedBox(height: 15),

              // Champ Description
              _buildTextField(_descriptionController, 'Description', Icons.notes, maxLines: 3),
              const SizedBox(height: 15),

              // Champ Prix
              _buildTextField(_priceController, 'Prix (€)', Icons.attach_money, keyboardType: TextInputType.number),
              const SizedBox(height: 15),

              // Champ Stock disponible
              _buildTextField(_stockController, 'Stock disponible', Icons.inventory, keyboardType: TextInputType.number),
              const SizedBox(height: 25),

              // Sélecteur de Catégorie
              FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement des catégories: ${snapshot.error}'));
                  }

                  final categories = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Catégorie',
                      border: const OutlineInputBorder(),
                      prefixIcon: categories.isNotEmpty && _selectedCategoryId != null 
                        ? Icon(_productService.getCategoryById(_selectedCategoryId!)?.icon) 
                        : const Icon(Icons.category),
                    ),
                    value: _selectedCategoryId,
                    items: categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner une catégorie.';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 40),

              // Bouton d'enregistrement
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'MODIFIER LE PRODUIT' : 'ENREGISTRER LE PRODUIT'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire.';
        }
        if (keyboardType == TextInputType.number) {
            if (double.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide.';
            }
        }
        return null;
      },
    );
  }
}