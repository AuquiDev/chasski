// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_00.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/pages/orientation_phone_page.dart';
import 'package:chasski/pages/orientation_web_page.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/widgets/demo_conectivity_plus.dart';
import 'package:chasski/widgets/offline_buton.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String text = '';
  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  @override
  void initState() {
     Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();
              Provider.of<DBCheckPointsAppProviderAr00>(context, listen:  false).initDatabase();
              Provider.of<DBEMpleadoProvider>(context, listen:  false).initDatabase();
    cargarUsuario();
    // Al inicializar el widget, obtenemos el estado de inicio de sesión previo
    SharedPrefencesGlobal().getLoggedIn().then((value) {
      setState(() {
        _isLoggedIn = value; // Actualizamos el estado de inicio de sesión
      });
    });

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
    super.initState();
  }

  void cargarUsuario() async {
    await Provider.of<UsuarioProvider>(context, listen: false).cargarUsuario();
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TEmpleadoProvider>(context);
    TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;

    // Paso 1: Verificar si ya estás autenticado
    if (_isLoggedIn) {
      // Paso 2: Redireccionar automáticamente a la página posterior al inicio de sesión
      // return const WebPage();
      final screensize = MediaQuery.of(context).size;
      if (screensize.width > 900) {
        // print('Web Page: ${screensize.width}');
        return const WebPage();
      } else {
        // print('Web Page: ${screensize.width}');
        return const PhonePage();
      }
      // Redirige a la página posterior al inicio de sesión
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/fondo.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              DelayedDisplay(
                delay: const Duration(milliseconds: 5000),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 350, maxHeight: 600),
                        color: Colors.black54,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LoginBar(user: user),
                            H2Text(
                              text: generateMaskedText(text),
                              fontSize: 35,
                              color: Colors.white,
                            ),
                            user?.imagen == null
                                ? ConectivityDemo()
                                : SizedBox(),
                            loginProvider.islogin
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : NumericKeyboard(
                                    onKeyboardTap: (value) {
                                      setState(() {
                                        if (text.length + value.length <= 8) {
                                          text = text + value;
                                          _passwordController.text = text;
                                          _cedulaController.text = text;
                                          print('TEXTO: $text');
                                          print(text.length);
                                          print(value.length);
                                        }
                                      });
                                    },
                                    rightButtonFn: () {
                                      setState(() {
                                        if (text.isNotEmpty) {
                                          text = text.substring(
                                              0, text.length - 1);
                                          _passwordController.text = text;
                                          _cedulaController.text = text;
                                        }
                                      });
                                    },
                                    leftButtonFn: loginProvider.islogin
                                        ? null
                                        : () async {
                                            (_cedulaController.text.length < 8)
                                                ? null
                                                : initStarLogin();
                                            await Provider.of<UsuarioProvider>(
                                                    context,
                                                    listen: false)
                                                .cargarUsuario();
                                          },
                                    textColor: Colors.red,
                                    rightIcon: Icon(Icons.backspace,
                                        color: Colors.red),
                                    leftIcon: Icon(
                                      Icons.check,
                                      size: 32,
                                      color: (_cedulaController.text.length < 8)
                                          ? Colors.transparent
                                          : Color(0xFFF01313),
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () {
                                if (Theme.of(context).platform ==
                                    TargetPlatform.android) {
                                  // Mostrar AlertDialog en Android
                                  showAndroidDialog(context);
                                } else if (Theme.of(context).platform ==
                                    TargetPlatform.iOS) {
                                  // Mostrar CupertinoDialog en iOS
                                  showiOSDialog(context);
                                }
                              },
                              child: const OfflineSIgnalButon(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateMaskedText(String text) {
    final int maxLength = 8;
    String maskedText = '';

    for (int i = 0; i < maxLength; i++) {
      if (i < text.length) {
        maskedText += text[i];
      } else {
        maskedText += '•';
      }
    }

    return maskedText;
  }

// Función para mostrar un AlertDialog en Android
  void showAndroidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Trabajar sin conexión a internet.'),
          content: ModoOfflineClick(),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar un CupertinoDialog en iOS
  void showiOSDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // title: Text('Trabajar sin conexión a internet.'),
          content: ModoOfflineClick(),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initStarLogin() async {
    final loginProvider =
        Provider.of<TEmpleadoProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      await loginProvider.login(
          context: context,
          cedulaDNI: int.parse(_cedulaController.text),
          password: _passwordController.text);
      _formKey.currentState!.save();

      //SIMULAR UNA CARGA
      if (loginProvider.islogin) {
        // Crear una instancia de SharedPrefencesGlobal
        SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.setLoggedIn();

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          final screensize = MediaQuery.of(context).size;
          if (screensize.width > 900) {
            // print('Web Page: ${screensize.width}');
            return const WebPage();
          } else {
            // print('Web Page: ${screensize.width}');
            return const PhonePage();
          }
        }), (route) => false);
      } else {
        speackQr('usuario no encontrado');
        ElegantNotification.error(
          width: 350,
          stackedOptions: StackedOptions(
            key: 'topRight',
            type: StackedType.same,
            itemOffset: Offset(0, 0),
          ),
          position: Alignment.topCenter,
          animation: AnimationType.fromTop,
          description: H2Text(
            text: 'Usuario no encontrado',
            color: Colors.white,
            fontSize: 12,
          ),
          background: Color(0xFF9A9595),
          height: 50,
          onDismiss: () {},
        ).show(context);
      }
    }
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
    await flutterTts.speak(text);
  }
}

class LoginBar extends StatelessWidget {
  const LoginBar({
    super.key,
    required this.user,
  });

  final TEmpleadoModel? user;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 6000),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            user?.imagen == null
                ? Image.asset(
                    'assets/img/candado.png',
                    height: 110,
                  )
                : RippleAnimation(
                    duration: const Duration(seconds: 2),
                    color: Colors.white10,
                    child: ImageLoginUser(
                      user: user,
                      size: 90,
                    ),
                  ),
            H2Text(
              text: user?.imagen == null
                  ? 'INGRESE SU DNI'.toUpperCase()
                  : 'BIENVENIDO ${user!.nombre}!'.toUpperCase(),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class ImageLoginUser extends StatelessWidget {
  const ImageLoginUser({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: user?.imagen != null &&
                  user?.imagen is String &&
                  user!.imagen!.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.imagen}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      ),
    );
  }
}

Container imagenLogo() {
  return Container(
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/img/logo_smallar.png',
          ),
        ),
        color: Colors.black12),
  );
}
