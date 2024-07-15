import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/pages/t_empleado_login.dart';
import 'package:chasski/pages/t_runner_login.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/lotties_image.dart';
import 'package:chasski/widgets/offline_buton.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.darkIndigo,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  H2Text(
                      text: 'Hola!',
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.light1Grey),
                  H2Text(
                      text:
                          'Inicia sesión como Corredor o como Organizador para aprovechar todas las funcionalidades.',
                      textAlign: TextAlign.justify,
                      fontSize: 14,
                      maxLines: 6,
                      color: CustomColors.light1Grey),
                ],
              ),
              Positioned.fill(bottom: 0, child: OptionLogin()),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //SE CARGA AUTOMEITCAMENTE EN SQL LITE

    //DB EMPLEADOS
    //LLAMAMOS al metodo SINC
    final dbEmpleados = Provider.of<DBEMpleadoProvider>(context);
    bool issavingEmple = dbEmpleados.offlineSaving; //Simulacion de Carga
    //GUARDAMOS LA LISTA DE API en SQL LITE. se envia como aprametro
    List<TEmpleadoModel> listaDatosEmple =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados;

    //DB RUNNERS
     final dbRunner = Provider.of<DBRunnersAppProvider>(context);
    bool issavingRun = dbRunner.offlineSaving;
    final listaDatosRun = Provider.of<TRunnersProvider>(context).listaRunner;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Hero(
            transitionOnUserGestures: true,
            tag: 'heroAnimation1',
            child: LottiesImage()),
        SizedBox(height: 35),
        OutlinedButton(
          onPressed: () async {
            print('DATARUN: ${listaDatosRun.length}');
            await dbRunner.guardarEnSQlLite(listaDatosRun, context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginRunnerPage()));
            //ALMACENAR RUNNER
           
          },
          child:issavingRun
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(),
                  ): Container(
            width: 220,
            child: H2Text(
              text: 'Acceder como Corredor',
              fontSize: 14,
              textAlign: TextAlign.center,
              color: CustomColors.light1Grey,
            ),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(CustomColors.darkIndigo)),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            //ALMACENAR EMPLEADOS
            await dbEmpleados.guardarEnSQlLite(listaDatosEmple, context);
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
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(CustomColors.light1Grey)),
        ),
        SizedBox(
          height: size.height * .1,
        )
      ],
    );
  }
}

class SignalOfflineButon extends StatelessWidget {
  const SignalOfflineButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Theme.of(context).platform == TargetPlatform.android) {
          // Mostrar AlertDialog en Android
          showAndroidDialog(context);
        } else if (Theme.of(context).platform == TargetPlatform.iOS) {
          // Mostrar CupertinoDialog en iOS
          showiOSDialog(context);
        }
        //VOLVER a llamar a los lista de USusario y RUNNER
        final loginProvider =
            Provider.of<TEmpleadoProvider>(context, listen: false);
        loginProvider.getTEmpladoProvider();

        final loginRunner =
            Provider.of<TRunnersProvider>(context, listen: false);
        loginRunner.getTAsistenciaApp();
      },
      child: const OfflineSIgnalButon(),
    );
  }

// Función para mostrar un AlertDialog en Android
  void showAndroidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trabajar sin conexión a internet.'),
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
          title: Text('Trabajar sin conexión a internet.'),
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
}
