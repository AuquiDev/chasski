// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/qr%20validation/provider_qr_statescan.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/dialogs/assets_butonsheets.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/files/assets_play_sound.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/routes/assets_url_lacuncher.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

//PAGINA PARA SCANEAR QR
class QrPage02ChList extends StatefulWidget {
  const QrPage02ChList(
      {super.key,
      required this.idCheckList,
      required this.runnerList,
      required this.checkpointList,
      required this.saveProductosApp,
      required this.editarEntrada, 
      required this.updateParent
      });
  final List<ParticipantesModel> runnerList;
  final String idCheckList;
  final List<TChekListmodel02File> checkpointList;
  final Future<void> Function(TChekListmodel02File) saveProductosApp;
  final Future<void> Function(TChekListmodel02File) editarEntrada;
  final VoidCallback updateParent; // Nueva función de callback
  @override
  State<QrPage02ChList> createState() => _QrPage02ChListState();
}

class _QrPage02ChListState extends State<QrPage02ChList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.height * .4;
    final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 320,
          child: Column(
            children: [
              SizedBox(height: 20,),
              AppSvg(width: 80).certificadoSgv,
              H1Text(text: 'Verificación de Documentos'.toUpperCase()),
              P2Text(
                text:
                    'Documento de deslinde y el certificado médico.' +
                        ' Asegúrate de que ambos estén subidos al sistema.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        AppLoties(width: width).qrLoties,
        ElevatedButton(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(10), // Elevación del botón
            backgroundColor: MaterialStatePropertyAll(
                AppColors.primaryRed), // Color de fondo del botón
          ),
          onPressed: () {
            _scanQRCode(
              runnerQrScanState: runnerQrScanState,
            ); 
             // Llamar la función de callback para notificar al padre
              widget.updateParent();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: P2Text(
              text: 'Presione aqui.',
              color: AppColors.backgroundLight,
            ),
          ),
        ),
      ],
    );
  }

  // Método para escanear códigos QR y gestionar la asistencia del corredor
  Future<void> _scanQRCode(
      {required RunnerQrScanState runnerQrScanState}) async {
    try {
      // Inicia el escaneo del código QR
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", 'Cancelar', true, ScanMode.DEFAULT);

      //LEEMOSQR -> ( id | nombre | dorsal)
      // Divide el resultado del escaneo en una lista de datos
      List<String> listDataQrLeido = barcodeScanRes.split('|');
      String idRunnerQRLeido = listDataQrLeido[0]; // Obtiene el ID del corredor

      // TODOS Trabajamos con un Provider
      // Busca el corredor en la lista usando el ID escaneado
      runnerQrScanState.buscarRunnerIdScaneado(
          idScanerQr: idRunnerQRLeido, listData: widget.runnerList);
      // Obtiene los detalles del corredor
      ParticipantesModel isRunner = runnerQrScanState.isRunner;
      String dorsal = runnerQrScanState.dorsal;
      //verificamos que su id no sea nulo
      if (isRunner.id != null) {
        // Reproduce un mensaje de texto usando el servicio de texto a voz
        // Verifica si ya existe una asistencia registrada del corredor
        TChekListmodel02File? puntoDeControl;
        try {
          //si el corredor debe registrasre un unica ves en la vida
          puntoDeControl = widget.checkpointList
              .firstWhere((e) => e.idCorredor == isRunner.id, orElse: null);

          //guardamos Provider La asistencia en punto de control encontrado en provider
          runnerQrScanState.setScanerSaveCheckListFile(puntoDeControl);
          TextToSpeechService().speak(
            '${isRunner.nombre} ${isRunner.apellidos},' +
                'Dorsal: ${dorsal == 'N/A' ? 'No asignado' : dorsal}' +
                ' Distancia: ${isRunner.distancias}',
          );
          modalSheetDetallesCorredor(
            context: context,
          );
        } catch (e) {
          TextToSpeechService().speak(
              'El corredor no cargó documentos. No hay registro. Indíquele que cargue los documentos para proseguir.');

          //TODOS si no tiene los docuemntos cargados
          AssetAlertDialogPlatform.show(
              context: context,
              message: 'El corredor no cargó documentos.',
              title: 'No hay registro');
        }
        // Confirmar documentos existencia previa
        if (puntoDeControl!.id != null) {
          messageSpeack(puntoDeControl: puntoDeControl);
        }
      } else {
        noSeEncontroCorredor(
          runnerQrScanState: runnerQrScanState,
        );
      }
    } catch (e) {
      print('Error $e');
      // AssetAlertDialogPlatform.show(
      //     context: context, message: 'Error $e', title: 'Error');
    }
  }

  void messageSpeack({required TChekListmodel02File puntoDeControl}) {
    SoundUtils.vibrate(); // Realiza una vibración
    // Muestra un cuadro de diálogo informando que no se encontró el corredor
    AssetAlertDialogPlatform.show(
        context: context,
        message: 'Revise y valide los documentos adjuntados.',
        title: 'Documentos Adjuntos');
    bool isDeslinde = puntoDeControl.deslinde!.isEmpty;
    bool isCertfi = puntoDeControl.file!.isEmpty;

    String deslindeMessage = isDeslinde
        ? 'No adjuntó el documento deslinde'
        : 'Si adjuntó el documento deslinde';

    String certfiMessage = isCertfi
        ? 'No adjuntó el certificado médico'
        : 'Si adjuntó el certificado médico';

    TextToSpeechService().speak(
        'El corredor: $deslindeMessage. $certfiMessage. Revise y valide los documentos adjuntados.');
  }

  void noSeEncontroCorredor(
      {required RunnerQrScanState runnerQrScanState}) async {
    TextToSpeechService().speak(
      'No se encontró corredor.',
    );
    // Muestra un cuadro de diálogo informando que no se encontró el corredor
    bool isContinue = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AssetAlertDialogPlatform(
              message: 'Presione "OK" para intentar de nuevo.',
              title: 'No se encontró corredor',
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Cierra el diálogo
                  },
                  child: Text('No intentar')), // Texto del botón
            );
          },
        ) ??
        true;
    if (!isContinue) {
      //False permite reintentar
      // Si el usuario decide intentar de nuevo, vuelve a escanear el QR
      _scanQRCode(
        runnerQrScanState: runnerQrScanState,
      ); // Llama al método para escanear QR nuevamente
    }
  }

  void modalSheetDetallesCorredor({
    required BuildContext context,
  }) {
    // Reproduce un sonido cuando se encuentra un participante
    SoundUtils.playSound();

    showCustomBottonSheet(
         backgroundColor: Colors.white30,
        // sheetAnimationStyle: AnimationStyle(),
        context: context,
        builder: (BuildContext context) {
          final size = MediaQuery.of(context).size;
          final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
          ParticipantesModel isRunner = runnerQrScanState.isRunner;
          TChekListmodel02File personScaner =
              runnerQrScanState.personScanerCheckListFile;
          return Container(
             margin: EdgeInsets.only(left:30, right: 30, bottom: 30),
            padding: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 3.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GLobalImageUrlServer(
                        height: size.width * .3,
                        width: size.width * .3,
                        duration: 300,
                        fadingDuration: 600,
                        image: isRunner.imagen ?? '',
                        collectionId: isRunner.collectionId ?? '',
                        id: isRunner.id ?? "",
                        borderRadius: BorderRadius.circular(300)),
                    Expanded(
                      child: Column(
                        children: [
                          H1Text(
                              text: isRunner.nombre + ' ' + isRunner.apellidos,
                              fontSize: 25,
                              maxLines: 5,
                              textAlign: TextAlign.center),
                          P1Text(
                            text: isRunner.distancias.toString().toUpperCase(),
                            color: AppColors.buttonPrimary,
                          ),
                          P1Text(
                            text: isRunner.pais,
                          ),
                          H1Text(
                            text: isRunner.dorsal,
                            fontSize: 40,
                          ),
                          P3Text(
                            text: 'Número de dorsal',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                H2Text(text: formatFecha(personScaner.fecha)),
                P2Text(
                  text: 'Revisa y valida los documentos',
                ),
                FittedBox(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (personScaner.deslinde!.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            launchServerURL(
                                file: personScaner.deslinde,
                                collectionId: personScaner.collectionId,
                                id: personScaner.id);
                          },
                          icon: AppSvg(width: 50).pdfSvg,
                          label: Text('Deslinde'),
                        ),
                      if (personScaner.file!.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {
                            launchServerURL(
                                file: personScaner.file,
                                collectionId: personScaner.collectionId,
                                id: personScaner.id);
                          },
                          icon: AppSvg(width: 50).pdfSvg,
                          label: Text('Crt.Medico'),
                        )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
