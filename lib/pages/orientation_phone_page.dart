import 'package:chasski/utils/gradient_background.dart';
import 'package:chasski/widgets/state_signal_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chasski/provider_cache/current_page.dart';
import 'package:chasski/pages/menu_principal.dart';
import 'package:chasski/pages/orientation_web_page.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';

import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  FlutterTts flutterTts = FlutterTts();

  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  @override
  void initState() {
    final currenUser =
        Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    currenUser != null
        ? _speackInit('Bienvenido, ${currenUser.nombre}')
        : _speackInit('¡Es un placer saludarte de nuevo!');

    // Luego, llama al método setLoggedIn en esa instancia
    sharedPrefs.setLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final layoutmodel = Provider.of<LayoutModel>(context);
    return Container(
      decoration: gradientBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.redAccent),
          backgroundColor: Colors.transparent,
          title: const TextAppBar(),
          actions: [
            OfflineSIgnalButonSmall(),
          ],
        ),
        body: layoutmodel.currentPage, //const ListaOpciones(),
        drawer: const MenuPrincipal(),
      ),
    );
  }

  

  _speackInit(text) async {
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
    await flutterTts.speak(text);
  }
}
