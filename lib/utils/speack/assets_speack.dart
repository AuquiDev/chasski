import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  late FlutterTts flutterTts;

  factory TextToSpeechService() {
    // Singleton
    return _instance;
  }

  TextToSpeechService._internal() {
    flutterTts = FlutterTts();
    initializeTts();
  }

  Future<void> initializeTts() async {
    try {
      // Opciones para la instancia compartida, volumen, velocidad y tono
      await flutterTts.setSharedInstance(true);
      await flutterTts.setVolume(1);
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setPitch(1.0);
      
      // Configuración del idioma
      await flutterTts.setLanguage('es-ES');

      // Configuración de la categoría de audio en iOS
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          // IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          // IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          // IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );

      // Configuración de handlers
      _setHandlers();
    } catch (e) {
      print("Error al inicializar TTS: $e");
    }
  }

  void _setHandlers() {
    // Handlers para gestionar los estados del TTS
    flutterTts.setStartHandler(() {
      print("Playing");
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
    });

    flutterTts.setPauseHandler(() {
      print("Paused");
    });

    flutterTts.setContinueHandler(() {
      print("Continued");
    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
    });
  }

  Future<void> speak(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text).then((result) {
        if (result == 1) {
          print('Successfully spoke the text.');
        } else {
          print('Failed to speak the text.');
        }
      });
    } catch (e) {
      print('Error during speak: $e');
    }
  }

  Future<void> stop() async {
    try {
      await flutterTts.stop();
    } catch (e) {
      print('Error during stop: $e');
    }
  }

  Future<void> pause() async {
    try {
      await flutterTts.pause();
    } catch (e) {
      print('Error during pause: $e');
    }
  }
}
