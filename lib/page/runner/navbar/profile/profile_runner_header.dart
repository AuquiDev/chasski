import 'package:chasski/page/runner/navbar/profile/profile_runner_edit_image.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/conversion/assets_format_parse_bool.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final distancia = RunnerData.getDistance(context, runner);
    final heightTop = size.height * .3;
    return Container(
      height: heightTop,
      width: size.width,
      child: Stack(
        children: [
          Container(
            height: (heightTop),
            width: size.width,
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      H2Text(
                        text: (runner.dorsal == null ||
                                runner.dorsal.toString().isEmpty)
                            ? '-'
                            : runner.dorsal.toString(),
                        fontSize: 30,
                        textAlign: TextAlign.center,
                      ),
                      P3Text(text: 'DORSAL'),
                    ],
                  ),
                  SizedBox(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      H2Text(
                        text: distancia.distancias.toString().isEmpty
                            ? '-'
                            : distancia.distancias,
                        fontSize: 30,
                        textAlign: TextAlign.center,
                      ),
                      P3Text(text: 'DISTANCIA')
                    ],
                  ),
                ],
              ),
            ),
          ),
          //TODOS nomnbre de usuario - y editar
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 10),
                visualDensity: VisualDensity.compact,
                leading: parseBool(runner.estado.toString())
                    ? Icon(
                        Icons.circle,
                        color: Colors.green.shade400,
                        size: 10,
                      )
                    : SizedBox(),
                title: H1Text(
                  text: runner.title ?? '',
                  textAlign: TextAlign.center,
                  color: AppColors.backgroundLight,
                ),
                subtitle: H3Text(
                  text: runner.email ?? '',
                  textAlign: TextAlign.center,
                  color: AppColors.backgroundLight,
                ),
                trailing: ElevatedButton(
                    onPressed: () async {
                      bool isclose = await showDialog(
                        context: context,
                        builder: (context) {
                          return AssetAlertDialogPlatform(
                            message:
                                'Para cerrar sesión en la aplicación presiona "ok".',
                            title:
                                '¿Deseas cerrar sesión?',
                          );
                        },
                      )?? true;
                      if (!isclose) {
                        isSescionClean(context);
                      }
                    },
                    child: AppSvg(width: 10).cloesesion),
              ),
            ),
          ),
          //TODOS imaen de usuario - y editar
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditUSerPage()));
              },
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(300)
                    ),
                    child: GLobalImageUrlServer(
                      duration: 200,
                      fadingDuration: 300,
                      curve: Curves.easeOutCirc,
                      image: runner.imagen ?? ' ',
                      collectionId: runner.collectionId ?? '',
                      id: runner.id ?? '',
                      borderRadius: BorderRadius.circular(300),
                      height: heightTop*.5,
                      width: heightTop*.5,
                    ),
                  ),
                  Card(child: AppSvg().editSvg)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void isSescionClean(BuildContext context) async {
    SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
    // Luego, llama al método setLoggedIn en esa instancia
    await sharedPrefs.logout(context);
    await sharedPrefs.logoutRunner(context);

    await SharedPrefencesGlobal().deleteEmpleado();

    await SharedPrefencesGlobal().deleteParticipante(); //NUEVO
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint redPaint = Paint()
      ..color = AppColors.primaryRed
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.7, size.width, size.height * 0.5)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, redPaint);

    Paint whitePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    Path whitePath = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.7, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(whitePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
