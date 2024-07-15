import 'dart:io';

import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/pages/routes_localstorage.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/assets_animationswith.dart';
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_dialog.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/assets_url_lacuncher.dart';
import 'package:chasski/widgets/assets_boton_style.dart';
import 'package:chasski/widgets/runner_pdf_deslinde_wdiget.dart';
import 'package:chasski/widgets/runner_qr_generate.dart';
import 'package:chasski/widgets/widget/app_provider_runner.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SteeprCustom extends StatelessWidget {
  const SteeprCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<RunnerProvider>(context);
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
  final RunnerProvider cache;
  final TRunnersModel runner;
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
        path: Column(
          children: [
            areFieldsNotEmpty(widget.checkDoc)
                ? PageQrGenerateRunner(
                    e: widget.runner,
                    distancia: widget.distancia,
                    evento: widget.evento)
                : P2Text(
                    text: 'Aún no has cargado los archivos.' +
                        ' La carga de archivos es obligatoria' +
                        ' para obtener tu código QR.')
          ],
        ),
      ),
    ];

    return AssetsAnimationSwitcher(
        child: visibleSteeps
            ? CupertinoStepper(
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
                    title: Text(e.title),
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

  void selectFile(RunnerProvider cache) async {
    // Abre el selector de archivos para seleccionar un archivo PDF
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']); 
    // Verifica si se ha seleccionado un archivo 
    if (result == null) {
      //Nose encontro archivos.
        PlatformAlertDialog.show(
        context: context,
        message: 'No se selecciono Archivo PDF.',
        title: 'Certificado médico.');
    } else {
      // Actualiza el estado del widget con el archivo seleccionado
      print('File selected: ${result.files.single.path}');
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
      if (selectedFile != null) {
        //Guardamos en PROVIUDER el FILE path de certificado
        cache.setMedicalCertificateFile(selectedFile!);
         // Mostrar un mensaje de éxito
     PlatformAlertDialog.show(
        context: context,
        message: 'Archivo PDF cargado con éxito',
        title: 'Certificado médico.');
      }
    }
  }
}
