// lib/src/presentation/screens/detail_screen.dart

import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  // Ahora recibimos la lista completa y el índice inicial.
  final List<Map<String, String>> images;
  final int initialIndex;

  const DetailScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Un PageController nos permite controlar el PageView, como establecer la página inicial.
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      // Le decimos al carrusel que empiece en la imagen que el usuario seleccionó.
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Usamos un Stack para poner elementos uno encima de otro (el carrusel y el botón).
      body: Stack(
        children: [
          // 1. El carrusel de imágenes
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final imageUrlRegular = image['regular']!;
              final heroTag = image['small']!; // Usamos la URL pequeña como tag

              return Hero(
                tag: heroTag,
                child: Center(
                  child: Image.network(
                    imageUrlRegular,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              );
            },
          ),

          // 2. El botón para regresar
          Positioned(
            top: 50.0, // Espacio desde la parte superior
            left: 16.0, // Espacio desde la izquierda
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30.0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
