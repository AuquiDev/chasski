import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/pges/t_login_empleado.dart';
import 'package:chasski/pges/t_login_runner.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/utils/aasets_fondos_painter.dart';
import 'package:chasski/utils/assets_butonsheets.dart';
import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:chasski/utils/assets_title_login.dart';
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_imge.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/lotties_image.dart';
import 'package:chasski/widgets/offline_buton.dart';
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
          duration: 5000,
          fadingDuration: 1500,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.successColor,
                ),
              ),
              onPressed: () {
                //VOLVER a llamar a los lista de USusario y RUNNER
                final loginProvider =
                    Provider.of<TEmpleadoProvider>(context, listen: false);
                loginProvider.getTEmpladoProvider();

                final loginRunner =
                    Provider.of<TRunnersProvider>(context, listen: false);
                loginRunner.getTAsistenciaApp();
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
        context: context,
        builder: (BuildContext context) {
          // Se carga automáticamente en SQL Lite
          // DBEMPLEADOS
          final dbEmpleados =
              Provider.of<DBEMpleadoProvider>(context, listen: false);
          // Llamamos al método SINC/Simulación de Carga
          bool issavingEmple = dbEmpleados.offlineSaving;
          // Guardamos la lista de API en SQL Lite. Se envía como parámetro
          List<TEmpleadoModel> listaDatosEmple =
              Provider.of<TEmpleadoProvider>(context, listen: false)
                  .listaEmpleados;

          // DB RUNNERS
          final dbRunner =
              Provider.of<DBRunnersAppProvider>(context, listen: false);
          bool issavingRun = dbRunner.offlineSaving;
          final listaDatosRun =
              Provider.of<TRunnersProvider>(context, listen: false).listaRunner;
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Hero(
                    transitionOnUserGestures: true,
                    tag: 'heroAnimation1',
                    child: LottiesImage(
                      height: 100,
                    )),
                const H2Text(
                  text: '¿Listo para la carrera?',
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print('DATARUN: ${listaDatosRun.length}');
                    //ALMACENAR EMPLEADOS
                    await dbRunner.guardarEnSQlLite(listaDatosRun, context);
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRunnerPage()));
                  },
                  child: issavingRun
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(),
                        )
                      : Container(
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
                    await dbEmpleados.guardarEnSQlLite(
                        listaDatosEmple, context);
                    Navigator.of(context).pop();
                    //ALMACENAR EMPLEADOS
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                    width: 220,
                    child: issavingEmple
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(),
                          )
                        : H2Text(
                            text: 'Acceder como Organizador',
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                  ),
                  style: ButtonStyle(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: ()  {
                  },
                  child: Container(
                    width: 220,
                    child: issavingEmple
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(),
                          )
                        : H2Text(
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
                
                Spacer(),
                P3Text(
                  text:
                      '¿Problemas para iniciar sesión o con tu contraseña? Contáctanos en WhatsApp:',
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
                const SizedBox(height: 10),
                ModoOfflineTitle(),
              ],
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
