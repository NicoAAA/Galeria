// lib/src/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart'; // Importa tus colores

final String unsplashApiKey = dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'API_KEY_NO_ENCONTRADA';

Future<List<String>> fetchImages() async {
  // ... (Esta función no cambia)
  final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?count=30&client_id=$unsplashApiKey'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map<String>((item) => item['urls']['small'] as String).toList();
  } else {
    throw Exception('Fallo al cargar las imágenes. Código: ${response.statusCode}');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El estilo del título ahora viene del tema.
        title: const Text('Galería con Unsplash'),
      ),
      body: FutureBuilder<List<String>>(
        // ... (El FutureBuilder no cambia)
        future: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center));
          } else if (snapshot.hasData) {
            final imageURLs = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: imageURLs.length,
              itemBuilder: (context, index) {
                return Image.network(imageURLs[index], fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No se encontraron imágenes.'));
          }
        },
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        // Los colores ahora vienen del tema.
        onPressed: () => print('FAB presionado'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Este estilo es específico, así que lo mantenemos, pero usando los colores centralizados.
                Text('Sena CBA', style: GoogleFonts.passeroOne(fontSize: 30, color: AppColors.textPrimary)),
                Text('Bienvenidos', style: GoogleFonts.passeroOne(fontSize: 30, color: AppColors.textPrimary)),
              ],
            ),
          ),
          // El estilo de fuente (Roboto) ahora se aplica automáticamente por el tema.
          const ListTile(title: Text("Inicio"), leading: Icon(Icons.home)),
          const Divider(height: 0.2),
          const ListTile(title: Text("Tiendas"), leading: Icon(Icons.storefront)),
          const ListTile(title: Text("Promociones"), leading: Icon(Icons.shopping_cart)),
          const ListTile(title: Text("Categorias"), leading: Icon(Icons.category)),
          const Divider(height: 0.2),
          const ListTile(title: Text("email"), leading: Icon(Icons.mail)),
          const ListTile(title: Text('Soporte'), leading: Icon(Icons.contact_phone_sharp)),
        ],
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      // El color ahora viene del tema.
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            // El color del ícono ahora viene del tema del BottomAppBar
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}