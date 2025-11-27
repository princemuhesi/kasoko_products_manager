import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

class ProductService {
  // Instance Singleton pour un accès facile
  static final ProductService _instance = ProductService._internal();

  factory ProductService() {
    return _instance;
  }

  ProductService._internal();

  // --- Données factices (simulent la base de données) ---

  final List<Category> _categories = [
    Category(
      id: 'C001',
      name: 'Électronique',
      description: 'Appareils électroniques et gadgets.',
      icon: Icons.electrical_services,
    ),
    Category(
      id: 'C002',
      name: 'Vêtements',
      description: 'Articles de mode et accessoires.',
      icon: Icons.checkroom,
    ),
    Category(
      id: 'C003',
      name: 'Alimentation',
      description: 'Produits frais et emballés.',
      icon: Icons.fastfood,
    ),
  ];

  final List<Product> _products = [
    Product(
      id: 'P101',
      name: 'Smartphone X',
      description: 'Le dernier modèle avec triple caméra.',
      categoryId: 'C001',
      businessId: 'B_TECH',
      price: 599.99,
      availableStock: 15,
    ),
    Product(
      id: 'P102',
      name: 'T-shirt Coton',
      description: 'T-shirt 100% coton, blanc.',
      categoryId: 'C002',
      businessId: 'B_MODE',
      price: 19.99,
      availableStock: 50,
    ),
    Product(
      id: 'P103',
      name: 'Sac de Riz (5kg)',
      description: 'Riz de qualité supérieure.',
      categoryId: 'C003',
      businessId: 'B_FOOD',
      price: 12.50,
      availableStock: 200,
    ),
  ];
  
  // --- Méthodes CRUD simulées ---

  // READ (Catégories)
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100)); 
    return List.from(_categories); // Retourne une copie
  }

  // READ (Produits)
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_products); // Retourne une copie
  }

  // Helper pour trouver le nom de la catégorie
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // CREATE
  Future<void> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.add(product);
  }

  // UPDATE
  Future<void> updateProduct(Product updatedProduct) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
  }

  // DELETE
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.removeWhere((p) => p.id == id);
  }
}