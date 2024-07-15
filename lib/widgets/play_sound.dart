 import 'package:audioplayers/audioplayers.dart';

void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer
        .play(AssetSource('song/tono.mp3')); // Ruta a tu archivo de sonido
  }