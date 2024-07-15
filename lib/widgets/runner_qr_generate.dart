import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/utils/aasets_fondos_painter.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets_boton_style.dart';
import 'package:chasski/widgets/assets_colors.dart';

import 'package:chasski/widgets/assets_textapp.dart';
// import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/widget/app_provider_runner.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

// import 'dart:ui' as ui;

class QrRunnerChild extends StatelessWidget {
  const QrRunnerChild({super.key});

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: DiagonalPainter(),
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: PageQrGenerateRunner(
                e: runner, distancia: distancia, evento: evento),
          ),
        ],
      ),
    );
  }
}

class PageQrGenerateRunner extends StatefulWidget {
  const PageQrGenerateRunner({
    super.key,
    required this.e,
    required this.distancia,
    required this.evento,
  });

  final TRunnersModel e;
  final TDistanciasModel distancia;
  final TEventoModel evento;

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
    return CardQrImageDowloader(widget: widget, qrWidget: qrWidget);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: buildQrCode(widget.e),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            // alignment: Alignment.topCenter,
            children: [
              Screenshot(
                controller: screenshotController,
                child: snapshot.data ?? Container(),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: buttonStyle1(backgroundColor: Colors.blue),
                  onPressed: isLoading ? null : _captureAndSaveImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      P2Text(
                        text: 'Descargar',
                        color: Colors.white,
                      ),
                      isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                    ],
                  ),
                ),
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

    await Future.delayed(Duration(seconds: 2));

    if (image != null) {
      //GUARDAR IMAGEN EN GALLERIA
      // final result = await ImageGallerySaver.saveImage(image);
      await ImageGallerySaver.saveImage(image);
      //NOTIFICAR SI SI SE GUARDO
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.yellow,
            content: P3Text(
              text: 'Imagen guardada en galería ', //+ ': \n${result}',
              textAlign: TextAlign.center,
              color: AppColors.backgroundDark
            )),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}

class CardQrImageDowloader extends StatelessWidget {
  const CardQrImageDowloader({
    super.key,
    required this.widget,
    required this.qrWidget,
  });

  final PageQrGenerateRunner widget;
  final RepaintBoundary qrWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal:BorderSide(style: BorderStyle.solid, color: Colors.black12, width: 4), ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                GLobalImageUrlServer(
                  image: widget.evento.logo!,
                  collectionId: widget.evento.collectionId!,
                  id: widget.evento.id!,
                  borderRadius: BorderRadius.circular(0),
                  height: 50,
                  width: 130,
                  fadingDuration: 1000,
                  duration: 500, 
                  curve: Curves.bounceInOut,
                ),
                H1Text(
                  text: widget.evento.nombre,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GLobalImageUrlServer(
                  image: widget.e.imagen ?? ' ',
                  collectionId: widget.e.collectionId!,
                  id: widget.e.id!,
                  borderRadius: BorderRadius.circular(300),
                  height: 100,
                  width: 100,
                   fadingDuration: 1000,
                  duration: 500, 
                  curve: Curves.bounceInOut,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      P3Text(
                        text: widget.e.pais,
                        color: Colors.black,
                        textAlign: TextAlign.start,
                      ),
                      H3Text(
                        text: widget.e.nombre + ' ' + widget.e.apellidos,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              H1Text(
                                text: widget.distancia.distancias,
                                color: getColorFromHex(widget.distancia.color),
                                fontSize: 25,
                              ),
                              P3Text(
                                text: 'DISTANCIA',
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                widget.e.dorsal,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              P3Text(
                                text: 'DORSAL',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: qrWidget,
          ),
        ],
      ),
    );
  }
}

//WIDGET EMBEBVIDO DENTRO DEL QR
class QrChildTest extends StatelessWidget {
  const QrChildTest({
    super.key,
    required this.widget,
  });

  final PageQrGenerateRunner widget;

  @override
  Widget build(BuildContext context) {
    //ES Neseario que este en u nstack para posicioanr dentro del QR
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
                  child: H1Text(
                    text: '${widget.e.dorsal}',
                    textAlign: TextAlign.center,
                  ),
                ),
                FittedBox(
                  child: H1Text(
                    text: '${widget.distancia.distancias} ',
                    color: getColorFromHex(widget.distancia.color),
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
}
