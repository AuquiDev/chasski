// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:ui' as ui;

import 'package:chasski/models/model_runners_ar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PageQrGenerateRunner extends StatefulWidget {
  const PageQrGenerateRunner({
    super.key,
    required this.e,
  });
  final TRunnersModel e;

  @override
  State<PageQrGenerateRunner> createState() => _PageQrGenerateRunnerState();
}

class _PageQrGenerateRunnerState extends State<PageQrGenerateRunner> {
  Future<Widget> buildQrCode(TRunnersModel e) async {
    final qrDataString = '${widget.e.id}|${widget.e.nombre}|${widget.e.dorsal}';
    final qrData = QrCode.fromData(  data: qrDataString, errorCorrectLevel: QrErrorCorrectLevel.L);

    // Carga la imagen de forma asíncrona
    const AssetImage assetImage = AssetImage('assets/img/runner.png');
    final ByteData byteData =  await (assetImage.bundle ?? DefaultAssetBundle.of(context)).load(assetImage.keyName);

    final List<int> bytes = byteData.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(Uint8List.fromList(bytes));

    final qrPainter = QrPainter(
        data: qrDataString,
        color: ui.Color(0xFF217A8C),
        version: QrVersions.auto,
        embeddedImage: image,
        embeddedImageStyle: const QrEmbeddedImageStyle(
            // color: Colors.red,
            size: Size(50, 50)));

    final qrWidget = RepaintBoundary(
      child: CustomPaint(
        painter: qrPainter,
        size: const Size(220, 220),
      ),
    );
    return qrWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<Widget>(
          future: buildQrCode(widget.e),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ??
                  Container(); // Puedes personalizar el contenedor de carga aquí
            } else {
              return const CircularProgressIndicator(); // Otra opción es mostrar un indicador de carga
            }
          },
        ),
        H2Text(
          text: widget.e.nombre.toUpperCase(),
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        H2Text(
          text: widget.e.dorsal,
          fontWeight: FontWeight.bold,
          // fontSize: 30,
          color: Colors.grey,
        ),
      ],
    );
  }
}
