import 'package:flutter/material.dart';

BoxDecoration gradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF171717), // Negro con un toque de gris
          Color(0xFF232323), // Gris oscuro
          Color(0xFF222222), // Gris más oscuro
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }