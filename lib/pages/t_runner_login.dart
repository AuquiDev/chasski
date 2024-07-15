// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/pages/homepage_runner.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/gradient_background.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/image_app_widget.dart';
import 'package:chasski/widgets/lotties_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard/flutter_keyboard.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chasski/pages/orientation_web_page.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/widgets/demo_conectivity_plus.dart';
import 'package:provider/provider.dart';

class LoginRunnerPage extends StatefulWidget {
  const LoginRunnerPage({super.key});

  @override
  State<LoginRunnerPage> createState() => _LoginRunnerPageState();
}

class _LoginRunnerPageState extends State<LoginRunnerPage> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController _cedulaController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String text = '';
  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  //La función shuffle() sirve para aleatorizar los elementos de una lista reordena los elementos de forma aleatoria.
  List<String> _numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  void _shuffleNumbers() {
    _numbers.shuffle();
  }

  @override
  void initState() {
    _shuffleNumbers();

    //INISIALIZAR BD SQL
    Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();
    cargarUsuario();
    // Al inicializar el widget, obtenemos el estado de inicio de sesión previo
    SharedPrefencesGlobal().getLoggedInRunner().then((value) {
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
    await Provider.of<RunnerProvider>(context, listen: false).cargarRunner();
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Mostrar AlertDialog en Android
      showWelcomeDialog2(context);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Mostrar CupertinoDialog en iOS
      showWelcomeDialog(context);
    }
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TRunnersProvider>(context);
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;

    // Paso 1: Verificar si ya estás autenticado
    if (_isLoggedIn) {
      // Paso 2: Redireccionar automáticamente a la página posterior al inicio de sesión
      final screensize = MediaQuery.of(context).size;
      if (screensize.width > 900) {
        // print('Web Page: ${screensize.width}');
        return const PageHomeRunner();
      } else {
        // print('Web Page: ${screensize.width}');
        return PageHomeRunner();
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
              // BACKGROUND PAGE
              Container(
                decoration: gradientBackgroundlogin(),
              ),

              LoginBar(user: user),

              Align(
                alignment: Alignment.bottomCenter,
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 2000),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.lightIndigo,
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(.2, 1),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DelayedDisplay(
                          delay: Duration(milliseconds: 2500),
                          child: Container(
                            height: 50,
                            child: text.isNotEmpty
                                ? Text(
                                    generateMaskedText(text),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColors.darkIndigo,
                                      letterSpacing:
                                          15.0, // Ajusta este valor según sea necesario
                                    ),
                                  )
                                : H2Text(
                                    text: 'Ingresa tu cédula',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.darkIndigo,
                                  ),
                          ),
                        ),

                        //KEYBOARD TYPE
                        FlutterKeyboard(
                          physics: NeverScrollableScrollPhysics(),
                          onKeyboardTap: (value) {
                            setState(() {
                              if (text.length + value.length <= 8) {
                                text = text + value;
                                // _passwordController.text = text;
                                _cedulaController.text = text;
                                print('TEXTO: $text');
                                print(text.length);
                                print(value.length);
                              }
                            });
                          },
                          characters: _numbers,
                          footerMiddleCharacter: '0',
                          itemsPerRow: 3,
                          getAllSpace: true,
                          externalPaddingButtons: const EdgeInsets.all(5),
                          internalPaddingButtons:
                              EdgeInsets.symmetric(vertical: 10),
                          buttonsDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF1F1F1)),
                          footerLeftChild: //NUMERIC KEYBOARD
                              loginProvider.islogin
                                  ? Center(
                                      child: const CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(5),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 18.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            (_cedulaController.text.length < 8)
                                                ? Colors.transparent
                                                : Colors.green,
                                      ),
                                      child: H2Text(
                                        text: 'Continuar',
                                        fontSize: 14,
                                        color:
                                            (_cedulaController.text.length < 8)
                                                ? Colors.transparent
                                                : Colors.white,
                                      )),
                          footerLeftAction: loginProvider.islogin
                              ? null
                              : () async {
                                  (_cedulaController.text.length < 8)
                                      ? null
                                      : initStarLogin();
                                  await Provider.of<RunnerProvider>(context,
                                          listen: false)
                                      .cargarRunner();
                                },
                          footerRightAction: () {
                            setState(() {
                              if (text.isNotEmpty) {
                                text = text.substring(0, text.length - 1);
                                // _passwordController.text = text;
                                _cedulaController.text = text;
                              }
                            });
                          },
                          footerRightChild: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF3F3F3)),
                            child: const Icon(
                              Icons.backspace,
                              size: 32,
                              color: CustomColors.darkIndigo,
                            ),
                          ),
                        ),

                        //CONEXION INTERNET TEST - DESAPARECE SI SE ENCUENTRA AL USUARIO
                        user?.imagen == null ? ConectivityDemo() : SizedBox(),
                      ],
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

  void showWelcomeDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            '¡Bienvenido a nuestra plataforma de corredores!',
            maxLines: 10,
          ),
          content: Text(
            'Estamos encantados de que estés aquí. Si experimentas algún problema con la aplicación, te recomendamos reiniciarla cerrándola y volviéndola a abrir. ¡Disfruta de todas las funcionalidades que hemos preparado para ti!',
            textAlign: TextAlign.justify,
            maxLines: 10,
          ),
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

  void showWelcomeDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '¡Bienvenido a nuestra plataforma de corredores!',
            maxLines: 10,
          ),
          content: Text(
           'Estamos encantados de que estés aquí. Si experimentas algún problema con la aplicación, te recomendamos reiniciarla cerrándola y volviéndola a abrir. ¡Disfruta de todas las funcionalidades que hemos preparado para ti!',
           textAlign: TextAlign.justify,
           maxLines: 10,
                        ),
          actions: [
            TextButton(
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

  void initStarLogin() async {
    final loginProvider = Provider.of<TRunnersProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      await loginProvider.login(
        context: context,
        cedulaDNI: int.parse(_cedulaController.text),
        // idUsuario: '11111111'//_passwordController.text
      );
      _formKey.currentState!.save();
      print(loginProvider.islogin);
      //SIMULAR UNA CARGA
      if (loginProvider.islogin) {
        // Crear una instancia de SharedPrefencesGlobal
        SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.setLoggedInRunner();

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          final screensize = MediaQuery.of(context).size;
          if (screensize.width > 900) {
            return const PageHomeRunner(); // WebPage();
          } else {
            return const PageHomeRunner();
          }
        }), (route) => false);
        speackQr('Acceso correcto');
      } else {
        speackQr('usuario no encontrado');
        ElegantNotification.error(
          stackedOptions: StackedOptions(
            key: 'topRight',
            type: StackedType.same,
            itemOffset: Offset(0, 0),
          ),
          position: Alignment.bottomCenter,
          animation: AnimationType.fromBottom,
          description: H2Text(
            text: 'Usuario no encontrado',
            color: Colors.red,
            fontSize: 12,
          ),
          background: Colors.white,
          height: 60,
          width: 350,
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

  final TRunnersModel? user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DelayedDisplay(
      delay: const Duration(milliseconds: 100),
      child: Center(
        child: SafeArea(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: Duration(seconds: 2),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child:
                    //IMAGEN LOTIES RUNNER
                    user?.imagen == null
                        ? Hero(
                            transitionOnUserGestures: true,
                            tag: 'heroAnimation1',
                            child: LottiesImage())
                        : ImageLoginRunner(
                            user: user,
                            size: size.height * .3,
                          ),
              ),
              H2Text(
                text: user?.imagen == null
                    ? 'CHASKI CHALLENGE'
                    : '${user!.nombre} ${user!.apellidos}',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: CustomColors.darkIndigo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


