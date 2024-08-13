import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final Random random = Random();

  return Color.fromARGB(
    255,
    random.nextInt(256), // Rojo en el rango 100-155
    random.nextInt(256), // Verde en el rango 100-199
    random.nextInt(256), // Azul en el rango 100-155
  );
}
