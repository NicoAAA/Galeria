// lib/src/presentation/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
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
  late final PageController _pageController;
  // 1. Controlador para manejar el estado del zoom y la posición.
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
  
  // Función para resetear el zoom.
  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            // Cada vez que cambiamos de página, reseteamos el zoom.
            onPageChanged: (index) => _resetZoom(),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final imageUrlRegular = image['regular']!;
              final heroTag = image['small']!;

              // 2. Envolvemos el Hero con un GestureDetector para el doble toque.
              return GestureDetector(
                onDoubleTap: () {
                  // Si la imagen no tiene zoom, la ampliamos. Si ya tiene, la reseteamos.
                  if (_transformationController.value != Matrix4.identity()) {
                    _resetZoom();
                  } else {
                    final position = _transformationController.value.getTranslation();
                    // Zoom a 2x
                    _transformationController.value = Matrix4.identity()
                      ..translate(position.x, position.y)
                      ..scale(2.0);
                  }
                },
                child: Hero(
                  tag: heroTag,
                  child: Center(
                    // 3. Envolvemos la imagen con InteractiveViewer.
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 4.0, // Permite un zoom de hasta 4x
                      child: CachedNetworkImage(
                        imageUrl: imageUrlRegular,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 50.0,
            left: 16.0,
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