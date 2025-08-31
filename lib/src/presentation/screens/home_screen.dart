// lib/src/presentation/screens/home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import 'detail_screen.dart';

final String unsplashApiKey = dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'API_KEY_NO_ENCONTRADA';

Future<List<Map<String, String>>> fetchImages() async {
  final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?count=30&client_id=$unsplashApiKey'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    // 2. Modificamos la función para que devuelva un mapa con la URL pequeña y la regular.
    return data.map<Map<String, String>>((item) {
      return {
        'small': item['urls']['small'] as String,
        'regular': item['urls']['regular'] as String,
      };
    }).toList();
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
        title: const Text('Galería con Unsplash'),
      ),
      // 3. Actualizamos el tipo del FutureBuilder para que coincida con la nueva función.
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center));
          } else if (snapshot.hasData) {
            final images = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imageUrlSmall = images[index]['small']!;
                final imageUrlRegular = images[index]['regular']!;
                
                // 4. Envolvemos la imagen en GestureDetector y Hero.
                return GestureDetector(
                  onTap: () {
                    // Acción de navegar a la nueva pantalla.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          images: images, // Pasamos la imagen de mayor calidad.
                          initialIndex: index, // El tag debe ser único. Usamos la URL pequeña.
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    // El tag aquí debe coincidir EXACTAMENTE con el de la pantalla de detalle.
                    tag: imageUrlSmall,
                    child: CachedNetworkImage(
                      imageUrl: imageUrlSmall, // Mostramos la imagen pequeña en la galería.
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
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
        onPressed: () => print('FAB presionado'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Drawer _buildDrawer() {
    // ... (Este método no cambia)
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sena CBA', style: GoogleFonts.passeroOne(fontSize: 30, color: AppColors.textPrimary)),
                Text('Bienvenidos', style: GoogleFonts.passeroOne(fontSize: 30, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const ListTile(title: Text("Inicio"), leading: Icon(Icons.home)),
          const Divider(height: 0.2),
          const ListTile(title: Text("Tiendas"), leading: Icon(Icons.storefront)),
          const ListTile(title: Text("Promociones"), leading: Icon(Icons.shopping_cart)),
          const ListTile(title: Text("Categorias"), leading: Icon(Icons.category)),
          const Divider(height: 0.2),
          const ListTile(title: Text("email"), leading: Icon(Icons.mail)),
          const ListTile(title: Text('Soport'), leading: Icon(Icons.contact_phone_sharp)),
        ],
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    // ... (Este método no cambia)
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
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