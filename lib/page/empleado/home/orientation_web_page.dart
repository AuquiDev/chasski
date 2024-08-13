
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/cache/start%20page/current_page.dart';
import 'package:chasski/page/empleado/home/menu_principal.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:provider/provider.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakWelcomeMessage();
    });

    sharedPrefs.setLoggedIn();
  }

  void _speakWelcomeMessage() {
    final currenUser =
        Provider.of<CacheUsuarioProvider>(context, listen: false).usuarioEncontrado;
    if (currenUser != null) {
      TextToSpeechService().speak('Bienvenido, ${currenUser.nombre}');
    } else {
      // Puedes manejar el caso en el que currenUser es null, si es necesario
      TextToSpeechService().speak('Bienvenido, usuario desconocido');
    }
  }

  @override
  Widget build(BuildContext context) {
    final layoutmodel = Provider.of<LayoutModel>(context);
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(width: 170, child: MenuPrincipal()),
          Expanded( child: layoutmodel.currentPage),
        ],
      ),
      // drawer: const MenuPrincipal(),
    );
  }
}
