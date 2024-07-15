// ignore_for_file: use_build_context_synchronously

import 'package:chasski/provider/provider_sql_checkp_ar_00.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
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
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/pages/orientation_phone_page.dart';
import 'package:chasski/pages/orientation_web_page.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/widgets/demo_conectivity_plus.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  @override
  void initState() {
    TextToSpeechService()
        .speak('Bienvenido, por favor introduce tu cédula para acceder.');

    Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();
    Provider.of<DBCheckPointsAppProviderAr00>(context, listen: false)
        .initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
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
                  title1: 'Acceso a',
                  title2: 'Área de Gestión',
                  title3: 'Chaski',
                  title4: 'Challenge',
                  parrafo:
                      'Ingrese como organizador o administrador para gestionar todos los aspectos de la carrera, desde la creación de eventos hasta la supervisión de la participación de los corredores.',
                  fontsize: 40,
                ),
                SponsorSpage(
                  width: 300,
                  height: 100,
                )
              ],
            ),
            ConditionsImagekeyboradAdmin()
            // LoginBar(user: user),
          ],
        ),
      ),
    );
  }
}

class ConditionsImagekeyboradAdmin extends StatefulWidget {
  const ConditionsImagekeyboradAdmin({
    super.key,
  });
  @override
  State<ConditionsImagekeyboradAdmin> createState() =>
      _ConditionsImagekeyboradAdminState();
}

class _ConditionsImagekeyboradAdminState
    extends State<ConditionsImagekeyboradAdmin> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
    final loginProvider = Provider.of<TEmpleadoProvider>(context);
    TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;
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
                        : '${user!.nombre} ',
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
                                      _passwordController.text = text;
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
                                        await Provider.of<UsuarioProvider>(
                                                context,
                                                listen: false)
                                            .cargarUsuario();
                                      },
                                footerRightAction: () {
                                  setState(() {
                                    if (text.isNotEmpty) {
                                      text = text.substring(0, text.length - 1);
                                      _passwordController.text = text;
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
                //CONEXION INTERNET TEST - DESAPARECE SI SE ENCUENTRA AL USUARIO
                user?.imagen == null ? ConectivityDemo() : SizedBox(),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  

//METODO LOGIN
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
            return const WebPage();
          } else {
            return const PhonePage();
          }
        }), (route) => false);
        TextToSpeechService().speak('Acceso correcto');
      } else {
        TextToSpeechService().speak('usuario no encontrado');
        showCustomNotification(
          context,
          title: 'Usuario no encontrado',
        );
      }
    }
  }
}
