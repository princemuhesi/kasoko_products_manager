import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  // Charger les produits
  void _refreshProducts() {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  // Gère la navigation vers le formulaire et le rafraîchissement
  void _navigateAndRefresh(Product? product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
    
    // Si 'result' est true, c'est qu'une modification/création a eu lieu.
    if (result == true) {
      _refreshProducts();
    }
  }

  // Gère la suppression du produit
  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${product.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Fermer la boîte de dialogue
              await _productService.deleteProduct(product.id);
              _refreshProducts(); // Rafraîchir la liste
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} supprimé.')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun produit trouvé. Appuyez sur "+" pour en créer un.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final category = _productService.getCategoryById(product.categoryId);
              final categoryName = category?.name ?? 'Inconnue';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(category?.icon ?? Icons.inventory_2, color: Colors.white),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catégorie: $categoryName'),
                      Text('Prix: ${product.price.toStringAsFixed(2)} €'),
                      Text(
                        'Stock: ${product.availableStock}',
                        style: TextStyle(
                          color: product.availableStock < 10 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton d'édition (UPDATE)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () => _navigateAndRefresh(product),
                      ),
                      // Bouton de suppression (DELETE)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Bouton flottant pour créer (CREATE)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateAndRefresh(null),
      ),
    );
  }
}