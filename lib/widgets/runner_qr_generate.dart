import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_distancias_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

// import 'dart:ui' as ui;

class QrRunnerChild extends StatelessWidget {
  const QrRunnerChild({super.key});

  @override
  Widget build(BuildContext context) {
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;
    final loginProvider = Provider.of<TRunnersProvider>(context).listaRunner;

    TRunnersModel runner = loginProvider.firstWhere((e) => e.id == user!.id);

    final distanProvider =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    TDistanciasModel distancia = distanProvider.firstWhere(
      (d) => d.id == runner.idDistancia,
      orElse: () => distanciasDefault(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DelayedDisplay(
          delay: Duration(milliseconds: 500),
          child: PageQrGenerateRunner(
            e: runner,
            distancia: distancia,
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

class PageQrGenerateRunner extends StatefulWidget {
  const PageQrGenerateRunner({
    super.key,
    required this.e,
    required this.distancia,
  });

  final TRunnersModel e;
  final TDistanciasModel distancia;

  @override
  State<PageQrGenerateRunner> createState() => _PageQrGenerateRunnerState();
}

class _PageQrGenerateRunnerState extends State<PageQrGenerateRunner> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<Widget> buildQrCode(TRunnersModel e) async {
    final qrDataString = '${widget.e.id}|${widget.e.nombre}|${widget.e.dorsal}';

    final qrPainter = QrPainter(
      data: qrDataString,
      version: QrVersions.auto,
      // embeddedImage: ,
      eyeStyle: QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square),
      embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(70, 30)),
    );

    final qrWidget = RepaintBoundary(
      child: CustomPaint(
        painter: qrPainter,
        size: const Size(250, 250),
        child: Container(
          height: 250,
          width: 250,
          child: QrChildTest(widget: widget),
        ),
      ),
    );

    //VALOR RETORNADO
    return QrTickettarject(qrWidget: qrWidget);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildQrCode(widget.e),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: snapshot.data ?? Container(),
              ),
              OutlinedButton(
                onPressed: isLoading ? null : _captureAndSaveImage,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Icon(Icons.download),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _captureAndSaveImage() async {
    final image = await screenshotController.capture();
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2));

    if (image != null) {
      //GUARDAR IMAGEN EN GALLERIA
      final result = await ImageGallerySaver.saveImage(image);
      //NOTIFICAR SI SI SE GUARDO
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Card(
                color: Color(0xFF6BE66F),
                child: Text(
                  'Imagen guardada en galería: \n$result',
                  textAlign: TextAlign.center,
                ))),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}

class QrTickettarject extends StatelessWidget {
  const QrTickettarject({
    super.key,
    required this.qrWidget,
  });

  final RepaintBoundary qrWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF4ABDF4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Tiket anda sudah siap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk 2 orang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'KAI Access',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Scan this code in bar code scanner',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.white,
                  child: qrWidget,
                ),
                SizedBox(height: 10),
                Text(
                  'Valid 1 day',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QrChildTest extends StatelessWidget {
  const QrChildTest({
    super.key,
    required this.widget,
  });

  final PageQrGenerateRunner widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 67,
            height: 63,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    '${widget.e.dorsal}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FittedBox(
                  child: Text(
                    '${widget.distancia.distancias} ',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getColorFromHex(widget.distancia.color),
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}

class TicketWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}

// class QrRunnerChild extends StatelessWidget {
//   const QrRunnerChild({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     TRunnersModel? user =
//         Provider.of<RunnerProvider>(context).usuarioEncontrado;
//     final loginProvider = Provider.of<TRunnersProvider>(context).listaRunner;

//     TRunnersModel runner = loginProvider.firstWhere((e) => e.id == user!.id);

//     final distanProvider =
//         Provider.of<TDistanciasArProvider>(context).listAsistencia;

//     TDistanciasModel distancia = distanProvider.firstWhere(
//         (d) => d.id == runner.idDistancia,
//         orElse: () => distanciasDefault());

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         DelayedDisplay(
//             delay: Duration(milliseconds: 500),
//             child: PageQrGenerateRunner(
//               e: runner,
//               distancia: distancia,
//             )),
//       ],
//     );
//   }
// }

// class PageQrGenerateRunner extends StatefulWidget {
//   const PageQrGenerateRunner({
//     super.key,
//     required this.e,
//     required this.distancia,
//   });
//   final TRunnersModel e;
//   final TDistanciasModel distancia;

//   @override
//   State<PageQrGenerateRunner> createState() => _PageQrGenerateRunnerState();
// }

// class _PageQrGenerateRunnerState extends State<PageQrGenerateRunner> {
//   Future<Widget> buildQrCode(TRunnersModel e) async {
//     final qrDataString = '${widget.e.id}|${widget.e.nombre}|${widget.e.dorsal}';
//     final ui.Image textImage = await generateTextImage(
//         ' ${widget.e.dorsal} \n ${widget.distancia.distancias} ');
//     // final ui.Image textImage = await generateTextImage(' 8989 \n 1002K ');

//     final qrPainter = QrPainter(
//         data: qrDataString,
//         version: QrVersions.auto,
//         // embeddedImage: textImage,
//         eyeStyle: QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square),
//         embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(70, 30)));

//     final qrWidget = RepaintBoundary(
//       child: CustomPaint(
//         painter: qrPainter,
//         //  foregroundPainter: BorderPainter(),
//         size: const Size(250, 250),
//         child: Container(
//           height: 250,
//           width: 250,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Container(
//                   width: 67,
//                   height: 63,
//                   padding: EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                       // border: Border.all(style: BorderStyle.solid, width: 5),
//                       color: Colors.white),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       FittedBox(
//                         child: Text(
//                           '${widget.e.dorsal}',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w900),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       FittedBox(
//                         child: Text(
//                           '${widget.distancia.distancias} ',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: _getColorFromHex(widget.distancia.color),
//                               fontWeight: FontWeight.w900),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     return Container(
//         padding: EdgeInsets.all(30), color: Colors.white, child: qrWidget);
//   }

//   Color _getColorFromHex(String hexColor) {
//     hexColor = hexColor.replaceAll('#', '');
//     return Color(int.parse('FF$hexColor', radix: 16));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Widget>(
//       future: buildQrCode(widget.e),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return snapshot.data ??
//               Container(); // Puedes personalizar el contenedor de carga aquí
//         } else {
//           return const CircularProgressIndicator(); // Otra opción es mostrar un indicador de carga
//         }
//       },
//     );
//   }

//   // Método para generar una imagen de texto
//   Future<ui.Image> generateTextImage(String text) async {
//     final double width = 250;
//     final double height = 80;

//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder);

//     // Dibuja el texto en el lienzo
//     final paragraphStyle = ui.TextStyle(
//         background: Paint()..color = Colors.white,
//         color: Colors.black,
//         fontSize: 35.0,
//         letterSpacing: 15.0,
//         fontWeight: FontWeight.w900);
//     final paragraphBuilder =
//         ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center))
//           ..pushStyle(paragraphStyle)
//           ..addText(text);
//     final paragraph = paragraphBuilder.build();
//     paragraph.layout(ui.ParagraphConstraints(width: width));
//     canvas.drawParagraph(paragraph,
//         Offset((width - paragraph.width) / 2, (height - paragraph.height) / 2));

//     // Completa el proceso de renderizado y devuelve la imagen
//     final picture = recorder.endRecording();
//     final img = await picture.toImage(width.toInt(), height.toInt());
//     return img;
//   }
// }

// class BorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5;
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
