import 'dart:io';
import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/assets_animationswith.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets_boton_style.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_dialog.dart';
import 'package:chasski/widgets/assets_imge.dart';
import 'package:chasski/widgets/assets_pdf_document.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/widget/app_provider_runner.dart';
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
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);
    return AssetsAnimationSwitcher(
        child: isSaving
            ? const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
            : IconButton(
                icon: Icon(Icons.upload),
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
                    await _generatePDF(
                        e: widget.e,
                        runner: widget.runner,
                        evento: evento,
                        distancia: distancia);
                  }

                  setState(() {
                    isSaving = false;
                  });
                },
              ));
  }

  Future<void> _showSignatureModal(BuildContext context) async {
    final _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    await showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H1Text(text: 'Cargar Foto (obligatorio)'),
                P3Text(
                    text: 'Por favor, elige una foto reciente y presentable para el deslinde.' +
                        ' Debe ser de frente y con el rostro claramente visible,' +
                        ' ya que se usará en el documento oficial.'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          Provider.of<RunnerProvider>(context, listen: false)
                              .setUserPhotoBytes(_userPhotoBytes!);
                        }
                      },
                      child: Text('Seleccionar Foto'),
                    ),
                    ImageMemoryUser(),
                  ],
                ),
                H1Text(text: 'Firma Digital (Obligatorio)'),
                P3Text(
                    text: 'Por favor, utilice su dedo para firmar en el lienzo.' +
                        ' Esta firma es obligatoria y se utilizará en el documento oficial.'),
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  child: Text('Resetear Firma'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid, color: Colors.black12)),
                  child: Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: buttonStyle1(backgroundColor: Colors.blue),
                      onPressed: () async {
                        final signature = await _controller.toPngBytes();
                        if (signature != null) {
                          setState(() {
                            _signatureImage = signature;
                          });
                          Provider.of<RunnerProvider>(context, listen: false)
                              .setSignatureImage(_signatureImage!);
                          Navigator.of(context).pop();
                        }
                      },
                      child: H3Text(
                        text: 'Completar Deslinde',
                        color: AppColors.backgroundLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generatePDF(
      {TChekListmodel02File? e,
      TRunnersModel? runner,
      TEventoModel? evento,
      TDistanciasModel? distancia}) async {
    Uint8List terrexBytes = await loadAssetImage(AppImages.logoPdf);
    Uint8List logoBytes = await loadImageFromUrl(
        collectionId: evento!.collectionId, id: evento.id, file: evento.logo);
    Uint8List logoBytesSmall = await loadImageFromUrl(
        collectionId: evento.collectionId,
        id: evento.id,
        file: evento.logoSmall);
    pw.Document pdf = pw.Document();

    // Página de ejemplo
    pdf.addPage(pw.MultiPage(
      // margin: const pw.EdgeInsets.all(20),
      maxPages: 200,
      pageFormat: PdfPageFormat.a4,
      // .copyWith(marginTop: 20, marginBottom: 20), // Aplica los márgenes
      footer: (context) {
        return AssetPDFDocument().buildFooter(logoBytes: logoBytesSmall);
      },
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              AssetPDFDocument()
                  .buildTitle(terrexBytes: terrexBytes, evento: evento),
              pw.SizedBox(height: 15),
              AssetPDFDocument().buildDeclaration(evento: evento),
              pw.SizedBox(height: 10),
              AssetPDFDocument().buildCommitments(runner: runner),
              pw.SizedBox(height: 10),
              AssetPDFDocument().buildSignatureArea(
                  signatureImage: _signatureImage,
                  userPhotoBytes: _userPhotoBytes),
            ],
          ),
        ];
      },
    ));
    //PAGINA DE INFORACION DE CORREDOR
    pdf.addPage(pw.MultiPage(
      maxPages: 200,
      build: (pw.Context context) {
        return [
          AssetPDFDocument().buildParticipantInfo(
              e: e,
              runner: runner,
              evento: evento,
              distancia: distancia,
              userPhotoBytes: _userPhotoBytes,
              logoBytes: logoBytes,
              logoBytesSmall: logoBytesSmall)
        ];
      },
    ));

    Uint8List bytes = await pdf.save();
    Directory directory =
        await getTemporaryDirectory(); //getApplicationDocumentsDirectory();
    File filePdf =
        File("${directory.path}/${e!.nombre}_${e.dorsal}_${e.id}.pdf");
    await filePdf.writeAsBytes(bytes);
    await OpenFilex.open(filePdf.path);

    // Mostrar la alerta solo si se ha abierto el archivo correctamente
    if (await filePdf.exists()) {
      //GUARDAR EL PATH en PROVIDER
      Provider.of<RunnerProvider>(context, listen: false).setPdfFile(
        filePdf,
      );
      // Mostrar un mensaje de éxito
      PlatformAlertDialog.show(
          context: context,
          message: 'Archivo PDF cargado con éxito',
          title: 'Deslinde de Responsabilidad');
    } else {
      // Mostrar un mensaje de éxito
      PlatformAlertDialog.show(
          context: context,
          message: 'Error: El archivo PDF no se ha creado correctamente.',
          title: 'Deslinde de Responsabilidad');
    }
  }
}

class ImageMemoryUser extends StatelessWidget {
  const ImageMemoryUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? userPhotoBytes =
        Provider.of<RunnerProvider>(context).userPhotoBytes;
    return Column(
      children: [
       AssetsAnimationSwitcher(
        child:  (userPhotoBytes != null) ? 
          Image.memory(
            (userPhotoBytes),
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ) : SizedBox(),
       )
      ],
    );
  }
}
