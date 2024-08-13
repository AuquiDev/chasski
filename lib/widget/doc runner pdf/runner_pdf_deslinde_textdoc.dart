import 'dart:typed_data';

import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AssetPDFDocument {
  //ATRIBUTOS
  pw.Font fontBold = pw.Font.helvetica();
  double fontSize = 9;
  pw.TextAlign textAlign = pw.TextAlign.justify;
  //TITULO Y LOGO
  pw.Widget buildTitle({Uint8List? terrexBytes, TEventoModel? evento}) {
    return pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Column(
          children: [
            pw.Image(
              pw.MemoryImage(terrexBytes!),
              width: 350,
            ),
            pw.Text(
              'DESLINDE DE RESPONSABILIDAD ${evento!.nombre.toUpperCase()}',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                // decoration: pw.TextDecoration.underline,
                // font: fontBold
              ),
            ),
          ],
        ));
  }

  pw.Widget buildDeclaration({TEventoModel? evento}) {
    double fontSize = 9;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
            //ANDES RACE 25 y 26 de agosto del 2023
            'Declaro conocer que el ${evento!.nombre} en su versión del ${formatEventDates(evento.fechaInicio, evento.fechaFin)}, significa un esfuerzo de las capacidades tanto físicas como mentales, por lo que asumo, en forma total y exclusiva, los riesgos que mi participación, pueda eventualmente ocasionar a mi salud, durante y después de la competencia antes señalada.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 10),
        pw.Text(
            'Declaro que me encuentro físicamente apto y que tengo suficiente entrenamiento para este tipo de eventos. En ese sentido, declaro no haber sido aconsejado en sentido contrario por médico certificado alguno.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 10),
        pw.Text(
            'Dejo constancia que mi declaración en este documento es verdadera y debe ser aceptada por el Comité Organizador y Administradores del EVENTO MISMO.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 10),
        pw.Text(
            'Este documento debe ser firmado antes de recibir el kit del corredor, ya sea durante una de las dos entregas programadas en Lima o en Cusco, a través de la aplicación.',
            // 'Este documento se firma una vez recibido el KIT del corredor en cualquiera de las dos entregas de KIT realizadas en Lima o en Cusco.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget buildCommitments({
    // TRunnersModel? runner,
    ParticipantesModel? runner,
  }) {
    // Construir el texto dinámicamente
    String nombre = (runner!.title != null && runner.title.isNotEmpty)
        ? ('____' + runner.title + " " + runner.apellidos + ' _____')
        : ' _______________________________________________';

    String numeroDeDocumento = runner.numeroDeDocumentos != null
        ? ('__' + runner.numeroDeDocumentos.toString() + '__')
        : ' ________________';

    String declarationText =
        'Yo, $nombre, con Documento de Identidad Nº $numeroDeDocumento, '
        'declaro haber leído el formato de deslinde de responsabilidades '
        'y suscribo el presente en señal de conformidad.';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Por lo que manifiesto lo siguiente:',
          style:
              pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
        ),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'a) Me comprometo a observar las reglas de competencia, incluyendo las reglas de control médico. En ese sentido, reconozco que por incumplimiento de cualquiera de ellas, podré ser descalificado del ANDES RACE.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'b) Renuncio a cualquier pretensión indemnizatoria por muerte o daño de cualquier tipo que traiga como consecuencia mi participación en el evento ANDES RACE contra el Comité Organizador, empresas, auspiciadores, representantes y entes reguladores, los que están libres de cualquier responsabilidad.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'c) Declaro la inocencia de las personas y entidades mencionadas en el párrafo anterior (b) de cualquier reclamo contra ellos, como resultado de mis actos durante el evento.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'd) Por la presente estoy de acuerdo en obedecer todas las reglas e instrucciones del evento y de sus directores.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'e) Reconozco que tengo responsabilidad por mis posesiones personales así como equipo atlético durante el evento ANDES RACE.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.Bullet(
            bulletColor: PdfColors.white,
            bulletMargin: pw.EdgeInsets.only(left: 3),
            text:
                'f) Autorizo al libre uso de mi nombre, fotografía, video u otro documento como promoción del presente y de siguientes eventos.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 15),
        pw.Text(declarationText,
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign),
        pw.SizedBox(height: 10),
        pw.Text(
            'Asimismo, me comprometo a cumplir con el reglamento del ANDES RACE, así como a respetar las indicaciones del comité técnico del evento y sus jueces.',
            style: pw.TextStyle(fontSize: fontSize, font: fontBold),
            textAlign: textAlign)
      ],
    );
  }

  pw.Widget buildSignatureArea({
    Uint8List? signatureImage,
    Uint8List? userPhotoBytes,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 100,
              height: 100,
              child: signatureImage != null
                  ? pw.Image(pw.MemoryImage(signatureImage),
                      fit: pw.BoxFit.contain)
                  : pw.SizedBox(),
            ),
            pw.Text('________________________________',
                style: pw.TextStyle(fontSize: fontSize)),
            pw.Text('FIRMA',
                style: pw.TextStyle(
                    fontSize: 12,
                    fontBold: fontBold,
                    fontWeight: pw.FontWeight.bold),
                textAlign: textAlign),
          ],
        ),
        if (userPhotoBytes != null)
          pw.Image(
            pw.MemoryImage(userPhotoBytes),
            fit: pw.BoxFit.cover,
            width: 100,
            height: 100,
          ),
      ],
    );
  }

  pw.Widget buildFooter({
    Uint8List? logoBytes,
  }) {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
        // pw.Image(
        //   pw.MemoryImage(logoBytes!),
        //   height: 20,
        // ),
        pw.Text(
          '${formatFechaTimeZone(DateTime.now())}',
          style: pw.TextStyle(fontSize: 8),
        )
      ])
    ]);
  }

  pw.Widget buildParticipantInfo({
    Uint8List? logoBytes,
  }) {
    return(logoBytes != null) ? 
        pw.Container(
          width: 350, 
          height: 190,
          child: pw.Transform.rotate(
            // Ángulo de rotación en radianes (-0.5 es aproximadamente -28.6 grados)
            angle:0.5, 
            // Ajustar la opacidad para que sea visible como marca de agua
            child: pw.Opacity(
              opacity: 0.1, 
              child:pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.contain),
            ),
          ),
        ) : pw.Container();
  }
}
