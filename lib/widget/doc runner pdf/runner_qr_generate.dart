import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QrRunnerChild extends StatelessWidget {
  const QrRunnerChild({super.key});

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);

    return AssetsDelayedDisplayYbasic(
      duration: 100,
      child:
          PageQrGenerateRunner(e: runner, distancia: distancia, evento: evento),
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

  // final TRunnersModel e;
  final ParticipantesModel e;
  final TDistanciasModel distancia;
  final TEventoModel evento;

  @override
  State<PageQrGenerateRunner> createState() => _PageQrGenerateRunnerState();
}

class _PageQrGenerateRunnerState extends State<PageQrGenerateRunner> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<Widget> buildQrCode(ParticipantesModel runner) async {
    final qrDataString =
        '${widget.e.id}|${widget.e.title + " " + widget.e.apellidos}|${widget.e.dorsal}';

    final qrPainter = QrPainter(
      data: qrDataString,
      version: QrVersions.auto,
      // eyeStyle: QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square),
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
    return Center(
      child: FutureBuilder<Widget>(
        future: buildQrCode(widget.e),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: snapshot.data ?? Container(),
                ),
                Container(
                  width: 150,
                  child: ElevatedButton.icon(
                    style: buttonStyle1(backgroundColor: Colors.blue),
                    onPressed: isLoading ? null : _captureAndSaveImage,
                    icon: P2Text(
                      text: 'Descargar',
                      color: Colors.white,
                    ),
                    label: isLoading
                        ? AssetsCircularProgreesIndicator()
                        : Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
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
      // Navigator.pop(context);
      //NOTIFICAR SI SI SE GUARDO
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.yellow,
            content: P3Text(
                text: 'Imagen guardada en galería ', //+ ': \n${result}',
                textAlign: TextAlign.center,
                color: AppColors.backgroundDark)),
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
              border: Border.symmetric(
                horizontal: BorderSide(
                    style: BorderStyle.solid, color: Colors.black12, width: 4),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                GLobalImageUrlServer(
                  image: widget.evento.logo ?? '',
                  collectionId: widget.evento.collectionId ?? '',
                  id: widget.evento.id ?? '',
                  borderRadius: BorderRadius.circular(0),
                  height: 30,
                  fadingDuration: 1000,
                  duration: 500,
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
                H3Text(
                  text: formatEventDates(
                      widget.evento.fechaInicio, widget.evento.fechaFin),
                  fontSize: 11,
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
                  collectionId: widget.e.collectionId ?? '',
                  id: widget.e.id ?? '',
                  borderRadius: BorderRadius.circular(300),
                  height: 60,
                  width: 60,
                  fadingDuration: 1000,
                  duration: 500,
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              H1Text(
                                text: widget.distancia.distancias,
                                color: getColorFromHex(widget.distancia.color),
                                fontSize: 20,
                              ),
                              P3Text(
                                text: 'Distancia',
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                widget.e.dorsal != null &&
                                        widget.e.dorsal.isNotEmpty
                                    ? widget.e.dorsal.toString()
                                    : 'N/A',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              P3Text(
                                text: 'Dorsal',
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                P3Text(
                                  text: widget.e.pais ?? '-',
                                  color: Colors.black,
                                  textAlign: TextAlign.start,
                                ),
                                H3Text(
                                  text: (widget.e.title ?? '') +
                                      ' ' +
                                      (widget.e.apellidos ?? ''),
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          )
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
            width: 50,
            height: 50,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: H2Text(
                    text: widget.e.dorsal != null && widget.e.dorsal.isNotEmpty
                        ? widget.e.dorsal.toString()
                        : 'N/A',
                    textAlign: TextAlign.center,
                  ),
                ),
                FittedBox(
                  child: H3Text(
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
