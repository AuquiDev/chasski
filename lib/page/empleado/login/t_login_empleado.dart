import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/layuot/assets_fondos_painter.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/layuot/assets_keyboard_type.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/utils/animations/assets_title_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/page/empleado/home/orientation_phone_page.dart';
import 'package:chasski/page/empleado/home/orientation_web_page.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/provider/empleado/online/provider_t_empleado.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
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
    super.initState();
    cargarUsuario();
    DatabaseInitializer.initializeDatabase(context);

    SharedPrefencesGlobal().getLoggedIn().then((value) {
      setState(() {
        _isLoggedIn = value; // Actualizamos el estado de inicio de sesión
      });
    });
    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp //portraitUp, // Solo retrato
    ]);
  }

  void cargarUsuario() async {
    await Provider.of<CacheUsuarioProvider>(context, listen: false)
        .cargarUsuario();
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    // Paso 1: Verificar si ya estás autenticado
    if (_isLoggedIn) {
      // Paso 2: Redireccionar automáticamente a la página posterior al inicio de sesión
      final screensize = MediaQuery.of(context).size;
      if (screensize.width > 900) {
        print('Web Page: ${screensize.width}');
        return const WebPage();
      } else {
        print('Web Page: ${screensize.width}');
        return const PhonePage();
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: DiagonalPainter(
                  colorBottom: AppColors.backgroundLight.withOpacity(.9),
                  colorTop: AppColors.backgroundDark.withOpacity(.1)),
            ),
            ContentKeyboard(),
          ],
        ),
      ),
    );
  }
}

class ContentKeyboard extends StatefulWidget {
  const ContentKeyboard({
    super.key,
  });
  @override
  State<ContentKeyboard> createState() => _ContentKeyboardState();
}

class _ContentKeyboardState extends State<ContentKeyboard> {
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
        Provider.of<CacheUsuarioProvider>(context).usuarioEncontrado;
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: FittedBox(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  user?.sexo == '-'
                      ? TitleLogin(
                          title1: 'Acceso a',
                          title2: 'Gestión de',
                          title3: 'Chaski',
                          title4: 'Challenge',
                          parrafo:
                              'Administre eventos y corredores con facilidad.',
                          fontsize: 40,
                        )
                      : GLobalImageUrlServer(
                          image: user?.sexo ?? '',
                          collectionId: user?.collectionId ?? '',
                          id: user?.id ?? "",
                          borderRadius: BorderRadius.circular(300),
                          height: size.height * .20,
                          width: size.height * .20,
                        ),
                  AssetsDelayedDisplayYbasic(
                    duration: 2000,
                    child: H1Text(
                      text: user?.imagen == null
                          ? 'COLABORADOR'.toUpperCase()
                          : '${user!.nombre} ',
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.shade800,
                      fontSize: 30,
                    ),
                  ),
                  AssetsDelayedDisplayYbasic(
                    duration: 500,
                    child: AssetsAnimationSwitcher(
                      duration: 300,
                      child: text.isNotEmpty
                          ? Text(
                              generateMaskedText(text),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                                letterSpacing: 20.0,
                                fontFamily: 'Quicksand',
                              ),
                            )
                          : H1Text(
                              text: 'Ingresa tu cédula',
                              color: Colors.blue.shade800,
                              fontSize: 24,
                            ),
                    ),
                  ),
                ],
              ),
              Spacer(),
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
                        //todos Importante para inizializar Memeoria Cache, sin eso no visilizaras los datos de sherd preferences
                        await Provider.of<CacheUsuarioProvider>(context,
                                listen: false)
                            .cargarUsuario();
                        await Provider.of<CacheParticpantesProvider>(context,
                                listen: false)
                            .cargarRunner();
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
            ],
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
        TextToSpeechService().speak('Acceso correcto');
        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.setLoggedIn();
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          final screensize = MediaQuery.of(context).size;
          if (screensize.width > 900) {
            return const WebPage();
          } else {
            return const PhonePage();
          }
        }), (route) => false);
      } else {
        TextToSpeechService().speak('usuario no encontrado');
        AssetAlertDialogPlatform.show(
            context: context, message: 'Usuario no encontrado', title: 'Error');
      }
    }
  }
}
