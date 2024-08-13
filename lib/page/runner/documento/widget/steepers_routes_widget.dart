import 'dart:io';

import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/routes/assets_url_lacuncher.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/widget/doc%20runner%20pdf/runner_pdf_deslinde_wdiget.dart';
import 'package:chasski/widget/doc%20runner%20pdf/runner_qr_generate.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SteeprCustom extends StatelessWidget {
  const SteeprCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheParticpantesProvider>(context);
    final runner = RunnerData.getRunner(context);
    final checkDoc = RunnerData.getCheckDeslinde(context, runner);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);
    return SteeperRoutes(
      cache: cache,
      runner: runner,
      checkDoc: checkDoc,
      evento: evento,
      distancia: distancia,
    );
  }
}

class SteeperRoutes extends StatefulWidget {
  const SteeperRoutes(
      {super.key,
      required this.cache,
      required this.runner,
      required this.checkDoc,
      required this.evento,
      required this.distancia});
  final CacheParticpantesProvider cache;
  // final TRunnersModel runner;
  final ParticipantesModel runner;
  final TChekListmodel02File checkDoc;
  final TEventoModel evento;
  final TDistanciasModel distancia;
  @override
  State<SteeperRoutes> createState() => _SteeperRoutesState();
}

class _SteeperRoutesState extends State<SteeperRoutes> {
  int _currentStep = 0;
  File? selectedFile;

  late bool visibleSteeps;

  @override
  void initState() {
    setState(() {
      visibleSteeps = !areFieldsNotEmpty(widget.checkDoc);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RoutesLocalStorage> routesSteeps = [
      RoutesLocalStorage(
        icon: AppSvg(width: 60).certificadoSgv,
        title: "Firmar el deslinde de responsabilidad",
        path: ListTile(
          contentPadding: EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
          dense: true,
          leading: PDFExportDeslinde(
            e: widget.checkDoc,
            runner: widget.runner,
          ),
          title: H2Text(
              text: deslindeNoEMpty(widget.checkDoc)
                  ? 'Editar Archivo'
                  : 'Subir Ahora'),
          subtitle: P3Text(text: 'Presione el icono.'),
          trailing: deslindeNoEMpty(widget.checkDoc)
              ? IconButton(
                  onPressed: () {
                    launchServerURL(
                        file: widget.checkDoc.deslinde,
                        collectionId: widget.checkDoc.collectionId,
                        id: widget.checkDoc.id);
                  },
                  icon: AppSvg(width: 50).pdfSvg,
                )
              : SizedBox(),
        ),
      ),
      RoutesLocalStorage(
        icon: AppSvg(width: 60).checkSvg,
        title: "Subir el certificado médico.",
        path: ListTile(
          contentPadding: EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
          dense: true,
          leading: Icon(Icons.upload),
          title: H2Text(
              text: fileNoEmpty(widget.checkDoc)
                  ? 'Editar Archivo'
                  : 'Subir Ahora'),
          subtitle: P3Text(text: 'Presione aqui.'),
          onTap: () async {
            //Guardamos el PATH de FILE EN PROVIDER
            selectFile(widget.cache);
          },
          trailing: fileNoEmpty(widget.checkDoc)
              ? IconButton(
                  onPressed: () {
                    launchServerURL(
                        file: widget.checkDoc.file,
                        collectionId: widget.checkDoc.collectionId,
                        id: widget.checkDoc.id);
                  },
                  icon: AppSvg(width: 40).pdfSvg,
                )
              : SizedBox(),
        ),
      ),
      RoutesLocalStorage(
        icon: AppSvg(width: 60).fileSvg,
        title: "Descargar QR.",
        path: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            children: [
              areFieldsNotEmpty(widget.checkDoc)
                  ? PageQrGenerateRunner(
                      e: widget.runner,
                      distancia: widget.distancia,
                      evento: widget.evento)
                  : P2Text(
                      text: 'Aún no has cargado los archivos.\n' +
                          'La carga de archivos es obligatoria\n' +
                          'para obtener tu código QR.')
            ],
          ),
        ),
      ),
    ];

    return AssetsAnimationSwitcher(
        child: visibleSteeps
            ? Stepper(
                margin: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < routesSteeps.length - 1) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                onStepTapped: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                steps: List.generate(routesSteeps.length, (index) {
                  final e = routesSteeps[index];
                  return Step(
                    title: H3Text(text: e.title),
                    content: e.path,
                    isActive: _currentStep == index,
                    state: _currentStep == index
                        ? StepState.complete
                        : StepState.indexed,
                  );
                }),
              )
            : ElevatedButton(
                style: buttonStyle1(backgroundColor: AppColors.buttonPrimary),
                onPressed: () {
                  setState(() {
                    visibleSteeps = !visibleSteeps;
                  });
                },
                child: H3Text(
                  text: 'Editar Registros',
                  color: AppColors.backgroundLight,
                )));
  }

  bool areFieldsNotEmpty(TChekListmodel02File checkDoc) {
    return checkDoc.file != null &&
        checkDoc.file!.isNotEmpty &&
        checkDoc.deslinde != null &&
        checkDoc.deslinde!.isNotEmpty;
  }

  bool fileNoEmpty(TChekListmodel02File checkDoc) {
    return (checkDoc.file != null && checkDoc.file!.isNotEmpty);
  }

  bool deslindeNoEMpty(TChekListmodel02File checkDoc) {
    return (checkDoc.deslinde != null && checkDoc.deslinde!.isNotEmpty);
  }

  // void selectFile(CacheParticpantesProvider cache) async {
  //   // Abre el selector de archivos para seleccionar un archivo PDF
  //   FilePickerResult? result = await FilePicker.platform
  //       .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  //   // Verifica si se ha seleccionado un archivo
  //   if (result == null) {
  //     //Nose encontro archivos.
  //       AssetAlertDialogPlatform.show(
  //       context: context,
  //       message: 'No se selecciono Archivo PDF.',
  //       title: 'Certificado médico.');
  //   } else {
  //     // Actualiza el estado del widget con el archivo seleccionado
  //     print('File selected: ${result.files.single.path}');
  //     setState(() {
  //       selectedFile = File(result.files.single.path!);
  //     });
  //     if (selectedFile != null) {
  //       //Guardamos en PROVIUDER el FILE path de certificado
  //       cache.setMedicalCertificateFile(selectedFile!);
  //        // Mostrar un mensaje de éxito
  //    AssetAlertDialogPlatform.show(
  //       context: context,
  //       message: 'Archivo PDF cargado con éxito',
  //       title: 'Certificado médico.');
  //     }
  //   }
  // }
  void selectFile(CacheParticpantesProvider cache) async {
    try {
      // Abre el selector de archivos para seleccionar un archivo PDF
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      // Verifica si se ha seleccionado un archivo
      if (result == null) {
        // No se encontró archivo
        _showAlertDialog('No se seleccionó archivo PDF.', 'Certificado médico');
        return;
      }

      String? filePath = result.files.single.path;
      if (filePath == null || filePath.isEmpty) {
        // Ruta del archivo no válida
        _showAlertDialog('La ruta del archivo seleccionado no es válida.',
            'Certificado médico');
        return;
      }

      File selectedFile = File(filePath);
      if (!await selectedFile.exists()) {
        // El archivo no existe
        _showAlertDialog(
            'El archivo seleccionado no existe.', 'Certificado médico');
        return;
      }

      // Actualiza el estado del widget con el archivo seleccionado
      setState(() {
        this.selectedFile = selectedFile;
      });

      // Guardamos en PROVIDER el FILE path de certificado
      cache.setMedicalCertificateFile(selectedFile);

      // Mostrar un mensaje de éxito
      _showAlertDialog('Archivo PDF cargado con éxito', 'Certificado médico');
    } catch (e) {
      // Manejo de cualquier otro error no esperado
      _showAlertDialog(
          'Ocurrió un error al seleccionar el archivo: $e', 'Error');
    }
  }

  void _showAlertDialog(String message, String title) {
    AssetAlertDialogPlatform.show(
        context: context, message: message, title: title);
  }
}
