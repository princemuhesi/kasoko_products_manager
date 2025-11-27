import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Produits & Catégories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Couleur dominante de l'application
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        // Style des boutons pour mobile
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const ProductListScreen(),
    );
  }
}