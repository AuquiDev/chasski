// ignore_for_file: use_build_context_synchronously, prefer_adjacent_string_concatenation, unused_catch_clause

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:provider/provider.dart';

class ConectivityDemo extends StatefulWidget {
  const ConectivityDemo({super.key});

  @override
  State<ConectivityDemo> createState() => _ConectivityDemoState();
}

class _ConectivityDemoState extends State<ConectivityDemo> {
  FlutterTts flutterTts = FlutterTts();
  String message = '';


  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
     flutterTts.stop();  // Detener la reproducción de TTS
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();

    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) { return Future.value(null); }

    return _updateConnectionStatus(result);
  }

 //METODO QUE MODIFCA EL ESTADO DE LA CONEXION 
Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  setState(() {
    _connectionStatus = result;
  });

  // Verificar la conexión a Internet
  if (_connectionStatus == ConnectivityResult.mobile ||
      _connectionStatus == ConnectivityResult.wifi) {
    _checkInternetConnection();
  } else if (_connectionStatus == ConnectivityResult.none) {
    speackQr(
        'Desactive el modo avión para verificar su conexión a Internet.'
      );
      print(message);
       final data =Provider.of<UsuarioProvider>(context, listen: false);
         data.updateConnectionStatus(false); //Activamso botones dde sincronizar 
  }
}


  Future<void> _checkInternetConnection() async {
     final data =Provider.of<UsuarioProvider>(context, listen: false);
    bool isOffline = data.isOffline;
    bool existData = data.sincData;

    String stringSincData = existData ? 'Tiene datos pendientes para sincronizar.' : '';

    try {
      final stopwatch = Stopwatch()..start();

      final response = await http.get(Uri.parse('https://www.google.com'));

      stopwatch.stop();

      if (response.statusCode == 200) {
        // Verificar el tiempo de respuesta para determinar si la conexión es débil
        if (stopwatch.elapsedMilliseconds > 3000) {
          message = 'Conexión a Internet estable pero lenta';
          speackQr(message);
         data.updateConnectionStatus(true); //Activamso botones dde sincronizar 
         
        } else {  
       
          message = '¡Conexión a Internet estable!';
           data.updateConnectionStatus(true); //Activamso botones dde sincronizar 
            speackQr(message + stringSincData);
        }
      } else {
        message = 'Conexión débil o demorada';
        data.updateConnectionStatus(true); //Activamso botones dde sincronizar 
        speackQr(message);
      }
    } catch (e) {
      message = 'Dispositivo no conectado a Internet.';
      // Mostrar mensaje si no hay internet
       
      // Si no hay conexión y no estamos en modo offline, leer el mensaje automáticamente
      if (!isOffline || _connectionStatus ==ConnectivityResult.none) {
         speackQr(
          'Dispositivo no conectado a Internet.'+
          ' Cambie al modo offline. $stringSincData');
           data.updateConnectionStatus(false); //Activamso botones dde sincronizar 
      }
     
    }
   
    data.updateMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    String messageProvider =  Provider.of<UsuarioProvider>(context).message;
    return Center(
      child: H2Text(
        text: 'Conexión ${_connectionStatus.name.toUpperCase()}\n$messageProvider',
        fontSize: 12,
        color: Colors.white38,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }

  speackQr(text) async {
  await flutterTts.stop(); // Detener la reproducción anterior, si la hay
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode);
    // Agregar una pausa antes de la reproducción
    await flutterTts.speak(text);
}

}
