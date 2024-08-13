import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/page/runner/home/homepage_runner.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/layuot/assets_fondos_painter.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_imge.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/utils/animations/assets_title_login.dart';
import 'package:chasski/utils/textfield/decoration_form.dart';
import 'package:chasski/widget/estate%20app/close_sesion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
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
    super.initState();
    cargarUsuario();
    // Al inicializar el widget, obtenemos el estado de inicio de sesión previo
    SharedPrefencesGlobal().getLoggedInRunner().then((value) {
      setState(() {
        _isLoggedIn = value; // Actualizamos el estado de inicio de sesión
      });
    });
  }

  void cargarUsuario() async {
    await Provider.of<CacheParticpantesProvider>(context, listen: false)
        .cargarRunner();
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
    ParticipantesModel? user =
        Provider.of<CacheParticpantesProvider>(context).usuarioEncontrado;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: DiagonalPainter(
                  colorBottom: AppColors.backgroundLight.withOpacity(.9),
                  colorTop: AppColors.backgroundDark.withOpacity(.1)),
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
                AssetsDelayedDisplayYbasic(
                  duration: 1000,
                  child: H1Text(
                    text: user?.imagen == null
                        ? 'Acceder como Corredor'.toUpperCase()
                        : '${user!.nombre} ${user.apellidos}',
                    color: AppColors.backgroundLight,
                  ),
                ),
                AssetsAnimationSwitcher(
                    child: user?.alergias == null
                        ? Opacity(
                            opacity: .4,
                            child: Image.asset(
                              AppImages.logoAndesRace,
                              height: size.height * .15,
                              width: size.height * .15,
                            ),
                          )
                        : GLobalImageUrlServer(
                            image: user!.alergias ?? ' ',
                            collectionId: user.collectionId ?? '',
                            id: user.id ?? '',
                            borderRadius: BorderRadius.circular(300),
                            height: size.height * .15,
                            width: size.height * .15,
                          )),
              ],
            ),

            ConditionsImagekeyborad(),

            //En caso de Bug el usuario se qeuda estancado en pagina Login.
            user?.imagen == null
                ? SizedBox()
                : Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              AssetAlertDialogPlatform.show(
                                context: context,
                                title: 'Acción Necesaria',
                                message:
                                    'Para continuar, por favor presiona "Cerrar Sesión" para restablecer' +
                                        ' la aplicación y luego inicia sesión nuevamente.',
                                child: CloseSesion(),
                              );
                            },
                            label: P2Text(text: 'Ayuda'),
                            icon: AppSvg().configBlue))),
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
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  // String text = '';

  // void _shuffleNumbers() {
  //   numbers.shuffle();
  // }

  @override
  void initState() {
    // _shuffleNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TParticipantesProvider>(context);
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cedulaController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')), // Denegar espacios
                  ],
                  decoration: decorationTextField(
                    hintText: 'Campo obligatorio',
                    labelText: 'DNI ',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: isVisible,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')), // Denegar espacios
                  ],
                  decoration: decorationTextField(
                      hintText: 'campo obligatorio',
                      labelText: 'contraseña',
                      prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible != true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 18,
                          ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: ElevatedButton(
                    style: buttonStyle1(),
                    onPressed: loginProvider.islogin
                        ? null
                        : () async {
                            setState(() {});
                            initStarLogin();
                            FocusManager.instance.primaryFocus?.unfocus();
                            //todos Importante para inizializar Memeoria Cache, sin eso no visilizaras los datos de sherd preferences
                            await Provider.of<CacheUsuarioProvider>(context,
                                    listen: false)
                                .cargarUsuario();
                            await Provider.of<CacheParticpantesProvider>(context,
                                    listen: false)
                                .cargarRunner();
                          },
                    child: Center(
                        child: loginProvider.islogin
                            ? AssetsCircularProgreesIndicator()
                            : const H2Text(
                                text: 'Iniciar Sesión',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initStarLogin() async {
    final loginProvider =
        Provider.of<TParticipantesProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      await loginProvider.login(
          context: context,
          cedulaDNI: _cedulaController.text,
          contrasena: _passwordController.text);
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
        AssetAlertDialogPlatform.show(
            context: context, message: 'Usuario no encontrado', title: 'Error');
      }
    }
  }
}
