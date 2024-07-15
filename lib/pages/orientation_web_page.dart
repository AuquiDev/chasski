
import 'package:chasski/widgets/color_custom.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chasski/provider_cache/current_page.dart';
import 'package:chasski/pages/menu_principal.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:provider/provider.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
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
    return Scaffold(
      backgroundColor: CustomColors.lightIndigo,
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const TextAppBar(),
      // ),
      body: Row(
        children: [
          const SizedBox(width: 250, child: MenuPrincipal()),
          const VerticalDivider(
            width: 5,
          ),
          Expanded(flex: 3, child: layoutmodel.currentPage),
        ],
      ),
      // drawer: const MenuPrincipal(),
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

class TextAppBar extends StatelessWidget {
  const TextAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
                delay: const Duration(milliseconds: 4000),
      //TODO : debe cambiar en base a tipo de evento. 
      child: Image.asset('assets/img/logo_ar_red.png', height: 45,color: CustomColors.black,));
  }
}
