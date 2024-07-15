import 'dart:io';
import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class PDFExportDeslinde extends StatefulWidget {
  const PDFExportDeslinde({super.key, required this.e, required this.runner});
  final TChekListmodel02File e;
  final TRunnersModel runner;
  @override
  State<PDFExportDeslinde> createState() => _PDFExportDeslindeState();
}

class _PDFExportDeslindeState extends State<PDFExportDeslinde> {
  bool isSaving = false;
  Uint8List? _signatureImage;
  Uint8List? _userPhotoBytes;

  @override
  Widget build(BuildContext context) {
    return isSaving
        ? const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : OutlinedButton.icon(
            label: Text('Doc. Deslinde'),
            icon: Icon(Icons.attach_file_sharp),
            onPressed: () async {
              setState(() {
                isSaving = true;
              });

              // Simulación de guardado con un retraso de 2 segundos
              await Future.delayed(const Duration(seconds: 2));

              // Mostrar modal bottom sheet para la firma
              await _showSignatureModal(context);

              // Generar PDF con la firma y la foto si se ha firmado y se capturó la foto
              if (_signatureImage != null && _userPhotoBytes != null) {
                await _generatePDF(e: widget.e, runner: widget.runner);
              }

              setState(() {
                isSaving = false;
              });
            },
          );
  }

  Future<void> _showSignatureModal(BuildContext context) async {
    final _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    await showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
             
              Expanded(
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    child: Text('Resetear Firma'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final signature = await _controller.toPngBytes();
                      if (signature != null) {
                        setState(() {
                          _signatureImage = signature;
                        });
                        Provider.of<RunnerProvider>(context, listen: false).setSignatureImage(_signatureImage!);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Guardar Firma'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    _userPhotoBytes = await file.readAsBytes();
                    setState(() {});
                    Provider.of<RunnerProvider>(context, listen: false).setUserPhotoBytes(_userPhotoBytes!);
                  }
                },
                child: Text('Seleccionar Foto'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _generatePDF(
      {TChekListmodel02File? e, TRunnersModel? runner}) async {
    ByteData byteData = await rootBundle.load('assets/img/logo_lachay.png');
    Uint8List imagenBytes = byteData.buffer.asUint8List();
    // const grisbordertable = PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

    pw.Document pdf = pw.Document();

    // Página de ejemplo
    pdf.addPage(pw.MultiPage(
      // margin: const pw.EdgeInsets.all(20),
      maxPages: 200,
      pageFormat: PdfPageFormat.a4
          .copyWith(marginTop: 20, marginBottom: 20), // Aplica los márgenes
      header: (context) {
        return pw.Image(
          pw.MemoryImage(imagenBytes),
          width: 60,
        );
      },
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildTitle(),
              pw.SizedBox(height: 30),
              _buildParticipantInfo(e: e, runner: runner),
              pw.SizedBox(height: 10),
              _buildDeclaration(),
              pw.SizedBox(height: 10),
              _buildCommitments(),
              pw.SizedBox(height: 10),
              _buildSignatureArea(),
            ],
          ),
        ];
      },
    ));

    Uint8List bytes = await pdf.save();
    Directory directory = await getApplicationDocumentsDirectory();
    File filePdf =
        File("${directory.path}/${e!.nombre}_${e.dorsal}_${e.id}.pdf");
    await filePdf.writeAsBytes(bytes);
    OpenFilex.open(filePdf.path);

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Archivo PDF exportado con éxito'),
      ),
    );
    //GUARDAR EL PATH en PROVIDER
    Provider.of<RunnerProvider>(context, listen: false).setPdfFile(
      filePdf,
    );
    // final docProvider = Provider.of<TCheckList02Provider>(context, listen: false);
    //                   await docProvider.saveProductosApp(
    //                       e: e, deslinde: filePdf);
  }

  pw.Widget _buildTitle() {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text(
        'DESLINDE DE RESPONSABILIDADES',
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Widget _buildParticipantInfo(
      {TChekListmodel02File? e, TRunnersModel? runner}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Yo,',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.justify),
            pw.Text('${runner!.nombre} ${runner.apellidos}',
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify),
            pw.Text('Sexo: ${runner.genero}',
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify),
            pw.Text('Nacionalidad: ${runner.pais}',
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify),
            pw.Text('DNI: ${runner.numeroDeDocumentos}',
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify),
            pw.SizedBox(height: 10),
            pw.Text(
                'Participante del evento deportivo "Andes Race" organizado por\n[Nombre del Organizador], declaro lo siguiente:',
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify),
          ],
        ),
        pw.SizedBox(width: 20),
        if (_userPhotoBytes != null)
          pw.Container(
            width: 90,
            height: 90,
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _signatureImage != null
                ? pw.Image(
                    pw.MemoryImage(_userPhotoBytes!),
                    fit: pw.BoxFit.cover,
                    width: 110,
                    height: 110,
                  )
                : pw.Text('Foto', style: pw.TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  pw.Widget _buildDeclaration() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
            'He leído y comprendido plenamente los riesgos asociados con la participación en una carrera de montaña. Reconozco que tales actividades implican desafíos físicos y mentales significativos, y acepto voluntariamente estos riesgos.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.SizedBox(height: 10),
        pw.Text(
            'Afirmo que estoy en condiciones físicas adecuadas y tengo el entrenamiento necesario para participar en "Andes Race". Me comprometo a seguir todas las reglas y directrices establecidas por los organizadores.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
      ],
    );
  }

  pw.Widget _buildCommitments() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Asumo las siguientes responsabilidades:',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Bullet(
            text:
                'Acepto los riesgos relacionados con la carrera, incluidos los del terreno y desafíos naturales.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Me comprometo a cumplir todas las normativas y regulaciones de los organizadores.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Renuncio a cualquier reclamación por daños, lesiones o pérdidas derivadas de mi participación, liberando de responsabilidad a los organizadores y entidades asociadas.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Exonero a la organización de "Andes Race" de cualquier responsabilidad legal resultante de mi participación.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Asumo la responsabilidad por la seguridad de mis pertenencias personales y equipo deportivo.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Acepto indemnizar y eximir de responsabilidad a los organizadores por cualquier pérdida o daño resultante de mi participación.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.Bullet(
            text:
                'Autorizo el uso de mi nombre, fotografía y documentos relacionados con mi participación para fines promocionales y futuros eventos.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
      ],
    );
  }

  pw.Widget _buildSignatureArea() {
    // Obtener la fecha y hora actual
    String formattedDate =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
            'He leído y aceptado este deslinde de responsabilidades. Firmo este documento en conformidad con las directrices establecidas por los organizadores.',
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.justify),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Fecha: $formattedDate',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Column(
              children: [
                pw.Container(
                  width: 200,
                  height: 100,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: _signatureImage != null
                      ? pw.Image(pw.MemoryImage(_signatureImage!),
                          fit: pw.BoxFit.contain)
                      : pw.SizedBox(),
                ),
                pw.Text('Firma: ________________________________',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ],
    );
  }
}
