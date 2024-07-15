// ignore_for_file: use_build_context_synchronously

import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/pges/homepage_runner.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/aasets_fondos_painter.dart';
import 'package:chasski/utils/assets_animationswith.dart';
import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/utils/assets_keyboard_type.dart';
import 'package:chasski/utils/assets_notifications.dart';
import 'package:chasski/utils/assets_speack.dart';
import 'package:chasski/utils/assets_title_login.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_imge.dart';
import 'package:chasski/widgets/widget/runner_sponsor_widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:provider/provider.dart';

class LoginRunnerPage extends StatefulWidget {
  const LoginRunnerPage({super.key});

  @override
  State<LoginRunnerPage> createState() => _LoginRunnerPageState();
}

class _LoginRunnerPageState extends State<LoginRunnerPage> {

  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  @override
  void initState() {
    TextToSpeechService()
        .speak('Bienvenido, por favor introduce tu cédula para acceder.');
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
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.fondoApp1),
                      fit: BoxFit.cover)),
            ),
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: DiagonalPainter(),
            ),
            Column(
              children: [
                TitleLogin(
                  title1: 'Prepárate',
                  title2: 'para Correr',
                  title3: 'Chaski',
                  title4: 'Challenge',
                  parrafo:
                      'Accede como corredor y únete a la aventura de descubrir nuevos caminos en los Andes mientras desafías tus límites.',
                  fontsize: 40,
                ),
                SponsorSpage(
                  width: 300,
                  height: 100,
                )
              ],
            ),
            ConditionsImagekeyborad(),
          ],
        ),
      ),
    );
  }
}

class ConditionsImagekeyborad extends StatefulWidget {
  const ConditionsImagekeyborad({
    super.key,
  });
  @override
  State<ConditionsImagekeyborad> createState() =>
      _ConditionsImagekeyboradState();
}

class _ConditionsImagekeyboradState extends State<ConditionsImagekeyborad> {
  final TextEditingController _cedulaController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String text = '';

  void _shuffleNumbers() {
    numbers.shuffle();
  }

  @override
  void initState() {
    _shuffleNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TRunnersProvider>(context);
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DelayedDisplay(
          delay: Duration(milliseconds: 1000),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AssetsDelayedDisplayYbasic(
                  duration: 2000,
                  child: H1Text(
                    text: user?.imagen == null
                        ? 'Acceder como Corredor'.toUpperCase()
                        : '${user!.nombre} ${user.apellidos}',
                    color: AppColors.backgroundLight,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AssetsDelayedDisplayYbasic(
                  duration: 500,
                  child: AssetsAnimationSwitcher(
                    duration: 800,
                    child: text.isNotEmpty
                        ? Text(
                            generateMaskedText(text),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.backgroundLight,
                              letterSpacing:
                                  15.0, // Ajusta este valor según sea necesario
                              fontFamily: 'Quicksand',
                            ),
                          )
                        : H2Text(
                            text: 'Ingresa tu cédula',
                            color: AppColors.backgroundLight,
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AssetsAnimationSwitcher(
                    child: //IMAGEN LOTIES RUNNER
                        user?.imagen == null
                            ?
                            //KEYBOARD TYPE
                            CustomFlutterKeyboard(
                                characters: numbers,
                                isLogin: loginProvider.islogin,
                                textController: _cedulaController,
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
                                footerLeftAction: loginProvider.islogin
                                    ? null
                                    : () async {
                                        (_cedulaController.text.length < 8)
                                            ? null
                                            : initStarLogin();
                                        await Provider.of<RunnerProvider>(
                                                context,
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
                              )
                            : GLobalImageUrlServer(
                                image: user!.imagen ?? ' ',
                                collectionId: user.collectionId!,
                                id: user.id!,
                                borderRadius: BorderRadius.circular(300),
                                height: size.height * .3,
                                width: size.height * .3,
                              )),
              ],
            ),
          ),
        ),
      ),
    );
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
        TextToSpeechService().speak('Acceso correcto');
      } else {
        TextToSpeechService().speak('Usuario no encontrado');
        showCustomNotification(
          context,
          title: 'Usuario no encontrado',
        );
      }
    }
  }
}
