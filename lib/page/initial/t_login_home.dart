import 'package:chasski/page/runner/navbar/home/home_bar.dart';
import 'package:chasski/page/runner/login/t_login_runner.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/page/empleado/login/t_login_empleado.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/utils/dialogs/assets_butonsheets.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/layuot/assets_fondos_painter.dart';
import 'package:chasski/utils/files/assets_imge.dart';
import 'package:chasski/utils/animations/assets_title_login.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/utils/animations/assets_ripley_animation.dart';
import 'package:chasski/widget/estate%20app/offline_buton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.fondoApp1), fit: BoxFit.cover)),
          ),
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: DiagonalPainter(),
          ),
          TitleLogin(
            title1: 'Corre',
            title2: 'y Descubre',
            title3: 'Andes',
            title4: 'Race',
            parrafo:
                'Explora nuevos caminos, desafía tus límites y descubre la belleza de los Andes mientras corres kilómetros llenos de aventura.',
            fontsize: 50,
          ),
          Align(alignment: Alignment.bottomCenter, child: OptionLogin()),
        ],
      ),
    );
  }
}

class OptionLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 300,
        child: AssetsDelayedDisplayX(
          duration: 4000,
          fadingDuration: 1000,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.successColor,
                ),
              ),
              onPressed: () {
                _showModalBotonSheet(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H3Text(
                    text: 'Get Started',
                    color: AppColors.backgroundLight,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.backgroundLight,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _showModalBotonSheet(BuildContext context) {
    showCustomBottonSheet(
        sheetAnimationStyle: AnimationStyle(),
        context: context,
        builder: (BuildContext context) {
          DatabaseInitializer.initializeDatabase(context);
          final listaDatosRun =
              Provider.of<TParticipantesProvider>(context, listen: false)
                  .listaRunner;
          final size = MediaQuery.of(context).size;
          return FittedBox(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: size.width,
              child: Column(
                children: [
                  LottiesImage(
                    height: 100,
                    child: AssetsDelayedDisplayX(
                      fadingDuration: 1000,
                      duration: 300,
                      curve: Curves.ease,
                      child: SizedBox(
                        child: AppLoties(width: 100).runnerLoties,
                      ),
                    ),
                  ),
                  const H2Text(
                    text: '¿Listo para la carrera?',
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      print('DATARUN: ${listaDatosRun.length}');
                      //ALMACENAR EMPLEADOS
                      // await dbRunner.guardarEnSQlLite(listaDatosRun, context);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginRunnerPage()));
                    },
                    child: Container(
                      width: 220,
                      child: const H2Text(
                        text: '  Acceder como Corredor  ',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        color: AppColors.backgroundLight,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppColors.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      //ALMACENAR EMPLEADOS
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Container(
                      width: 220,
                      child: H2Text(
                        text: 'Acceder como Organizador',
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: ButtonStyle(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InformationPage()));
                    },
                    child: Container(
                      width: 220,
                      child: H2Text(
                        text: 'Acceder como Visitante',
                        fontSize: 14,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.successColor)),
                  ),
                  const SizedBox(height: 20),
                  P3Text(
                    text:
                        '¿Problemas para iniciar sesión o con tu contraseña?\nContáctanos en WhatsApp:',
                    fontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      sendMessageToWhatsApp(
                          '+51976357951', 'Hello, this is a test message!');
                    },
                    icon: AppSvg().whatsappSvg,
                    label: P2Text(
                      text: 'Send WhatsApp Message',
                      color: AppColors.accentColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  P3Text(
                    text:
                        'Disponible solo para Organizadores',
                    fontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                  ModoOfflineClick(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
  }

  Future<void> sendMessageToWhatsApp(String phoneNumber, String message) async {
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
