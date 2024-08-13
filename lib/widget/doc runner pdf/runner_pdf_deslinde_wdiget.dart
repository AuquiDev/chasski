import 'dart:io';
import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';

import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_imge.dart';
import 'package:chasski/widget/doc%20runner%20pdf/runner_pdf_deslinde_textdoc.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class PDFExportDeslinde extends StatefulWidget {
  const PDFExportDeslinde({super.key, required this.e, required this.runner});
  final TChekListmodel02File e;
  // final TRunnersModel runner;
  final ParticipantesModel runner;
  @override
  State<PDFExportDeslinde> createState() => _PDFExportDeslindeState();
}

class _PDFExportDeslindeState extends State<PDFExportDeslinde> {
  bool isSaving = false;
  Uint8List? _signatureImage;
  Uint8List? _userPhotoBytes;

  bool isLoadingCamera = false;
  bool isLoadingGallery = false;
  File? imagenFile;
  @override
  void initState() {
    super.initState();
    final cache =
        Provider.of<CacheParticpantesProvider>(context, listen: false);
    // Usar una verificación segura con `?.`
    if (cache.userPhotoBytes?.isNotEmpty ?? false) {
      _userPhotoBytes = cache.userPhotoBytes;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cache = Provider.of<ParticpantesProvider>(context);
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);
    return AssetsAnimationSwitcher(
        child: isSaving
            ? AssetsCircularProgreesIndicator()
            : IconButton(
                icon: Icon(Icons.upload),
                onPressed: () async {
                  setState(() {
                    isSaving = true;
                  });
                  // Mostrar modal bottom sheet para la firma
                  await _showSignatureModal(context);

                  try {
                    // Generar PDF con la firma y la foto si se ha firmado y se capturó la foto
                    if (_signatureImage != null && _userPhotoBytes != null) {
                      // if (cache.signatureImage != null && cache.userPhotoBytes != null) {
                      await _generatePDF(
                              e: widget.e,
                              runner: widget.runner,
                              evento: evento,
                              distancia: distancia)
                          .timeout(Duration(seconds: 60));
                    }
                  } catch (e) {
                    // Manejar otras excepciones
                    print('Ocurrió un error: $e');
                    AssetAlertDialogPlatform(
                        message:
                            'Ocurrió un error al guardar. Por favor, inténtalo de nuevo.$e',
                        title: 'Error:');
                  } finally {
                    setState(() {
                      isSaving = false;
                    });
                  }
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
                        // FilePickerResult? result =
                        //     await FilePicker.platform.pickFiles(
                        //   type: FileType.image,
                        // );
                        // if (result != null) {
                        //   File file = File(result.files.single.path!);
                        //   _userPhotoBytes = await file.readAsBytes();
                        //   setState(() {});
                        //   Provider.of<CacheParticpantesProvider>(context,
                        //           listen: false)
                        //       .setUserPhotoBytes(_userPhotoBytes!);
                        // }
                        AssetAlertDialogPlatform.show(
                          context: context,
                          message: 'Selecione una opción:',
                          title: 'Foto para el Deslinde',
                          child: Material(
                              color: Colors.transparent,
                              child: _contentDialog(context)),
                        );
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
                          Provider.of<CacheParticpantesProvider>(context,
                                  listen: false)
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

  Widget _contentDialog(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          child: isLoadingCamera
              ? AssetsCircularProgreesIndicator()
              : H3Text(text: 'Camera'),
          onPressed: isLoadingCamera
              ? null
              : () async {
                  setState(() {
                    isLoadingCamera = true;
                  });
                  try {
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker
                        .pickImage(
                          source: ImageSource.camera,
                          imageQuality: 100,
                        )
                        .timeout(Duration(seconds: 60));

                    if (pickedFile == null) {
                      print('No image selected');
                    } else {
                      print('Image selected: ${pickedFile.path}');
                      final file = File(pickedFile.path);
                      setState(() {
                        imagenFile = file;
                        isLoadingCamera = false;
                      });

                      // Convertir la imagen a Uint8List
                      final imageBytes = await file.readAsBytes();
                      setState(() {
                        _userPhotoBytes = imageBytes;
                      });

                      // Guardar la imagen en el proveedor
                      Provider.of<CacheParticpantesProvider>(context,
                              listen: false)
                          .setUserPhotoBytes(_userPhotoBytes!);
                    }
                  } catch (e) {
                    print('Error selecting image: $e');
                  } finally {
                    setState(() {
                      isLoadingCamera = false;
                    });
                  }
                  Navigator.of(context).pop();
                },
        ),
        SizedBox(width: 5),
        ElevatedButton(
          child: H3Text(text: 'Gallery'),
          onPressed: () async {
            try {
              final picker = ImagePicker();
              final XFile? pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 100,
              );

              if (pickedFile == null) {
                print('No image selected');
              } else {
                print('Image selected: ${pickedFile.path}');
                final file = File(pickedFile.path);
                setState(() {
                  imagenFile = file;
                });

                // Check if the image is a PNG and convert it to JPEG if necessary
                if (imagenFile!.path.endsWith('.png')) {
                  await convertPngToJpeg(imagenFile!);
                  // Update imagenFile with the new JPEG file
                  final jpegFile = File('${imagenFile!.path}.jpg');
                  setState(() {
                    imagenFile = jpegFile;
                  });
                }

                // Convertir la imagen a Uint8List
                final imageBytes = await imagenFile!.readAsBytes();
                setState(() {
                  _userPhotoBytes = imageBytes;
                });

                // Guardar la imagen en el proveedor
                Provider.of<CacheParticpantesProvider>(context, listen: false)
                    .setUserPhotoBytes(_userPhotoBytes!);
              }
            } catch (e) {
              print('Error selecting image: $e');
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> convertPngToJpeg(File file) async {
    final image = img.decodeImage(file.readAsBytesSync());
    if (image != null) {
      final jpegBytes = Uint8List.fromList(img.encodeJpg(image));
      final jpegFile = File('${file.path}.jpg');
      await jpegFile.writeAsBytes(jpegBytes);
    }
  }

  Future<void> _generatePDF(
      {TChekListmodel02File? e,
      ParticipantesModel? runner,
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
      header: (context) {
        return (logoBytesSmall != null)
            ? pw.Image(pw.MemoryImage(logoBytesSmall),
                fit: pw.BoxFit.contain, width: 30, height: 30)
            : pw.Container();
      },
      // .copyWith(marginTop: 20, marginBottom: 20), // Aplica los márgenes
      footer: (context) {
        return AssetPDFDocument().buildFooter(logoBytes: logoBytesSmall);
      },
      build: (pw.Context context) {
        return [
          pw.Stack(alignment: pw.Alignment.center, children: [
            //Marca de AGUA
            AssetPDFDocument().buildParticipantInfo(
              logoBytes: logoBytes,
            ),
            //CONTENIDO
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
          ])
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
      Provider.of<CacheParticpantesProvider>(context, listen: false).setPdfFile(
        filePdf,
      );
      // Mostrar un mensaje de éxito
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'Archivo PDF cargado con éxito',
          title: 'Deslinde de Responsabilidad');
    } else {
      // Mostrar un mensaje de éxito
      AssetAlertDialogPlatform.show(
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
        Provider.of<CacheParticpantesProvider>(context).userPhotoBytes;
    return Column(
      children: [
        AssetsAnimationSwitcher(
          child: (userPhotoBytes != null)
              ? Image.memory(
                  (userPhotoBytes),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
              : SizedBox(),
        )
      ],
    );
  }
}
