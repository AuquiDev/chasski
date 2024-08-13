// import 'package:chasski/models/check%20list/model_check_list_2file.dart';
// import 'package:chasski/models/runner/model_participantes.dart';
// import 'package:chasski/provider/cache/qr%20validation/provider_qr_statescan.dart';
// import 'package:chasski/utils/colors/assets_colors.dart';
// import 'package:chasski/utils/conversion/assets_format_fecha.dart';
// import 'package:chasski/utils/dialogs/assets_butonsheets.dart';
// import 'package:chasski/utils/dialogs/assets_dialog.dart';
// import 'package:chasski/utils/files/assets-svg.dart';
// import 'package:chasski/utils/files/assets_loties.dart';
// import 'package:chasski/utils/files/assets_play_sound.dart';
// import 'package:chasski/utils/routes/assets_img_urlserver.dart';
// import 'package:chasski/utils/speack/assets_speack.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:chasski/utils/text/assets_textapp.dart';

// //PAGINA PARA SCANEAR QR
// class QrPage04ChList extends StatefulWidget {
//   const QrPage04ChList(
//       {super.key,
//       required this.idCheckList,
//       required this.runnerList,
//       required this.checkpointList,
//       required this.saveProductosApp,
//       required this.editarEntrada});
//   final List<ParticipantesModel> runnerList;
//   final String idCheckList;
//   final List<TChekListmodel02File> checkpointList;
//   final Future<void> Function(TChekListmodel02File) saveProductosApp;
//   final Future<void> Function(TChekListmodel02File) editarEntrada;

//   @override
//   State<QrPage04ChList> createState() => _QrPage04ChListState();
// }

// class _QrPage04ChListState extends State<QrPage04ChList> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.height * .4;
//     final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 340,
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               AppSvg(width: 80).equipajeSvg,
//               H1Text(
//                 text: 'Verificación de Pertenencias de los Corredores'
//                     .toUpperCase(),
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//               ),
//               P2Text(
//                 text:
//                     'Gestión de la entrega y devolución de equipos, mochilas, dropbags, prendas y' +
//                         ' zapatillas con registro fotográfico.',
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         AppLoties(width: width).qrLoties,
//         ElevatedButton(
//           style: ButtonStyle(
//             elevation: WidgetStatePropertyAll(10), // Elevación del botón
//             backgroundColor: MaterialStatePropertyAll(
//                 AppColors.primaryRed), // Color de fondo del botón
//           ),
//           onPressed: () {
//             _scanQRCode(
//               runnerQrScanState: runnerQrScanState,
//             ); // Llama al método para escanear QR
//           },
//           child: P2Text(
//             text: 'Presione aqui.', // Texto del botón
//             color: AppColors.backgroundLight, // Color del texto
//           ),
//         ),
//       ],
//     );
//   }

//   // Método para escanear códigos QR y gestionar la asistencia del corredor
//   Future<void> _scanQRCode({required RunnerQrScanState runnerQrScanState}) async {
//     try {
//       // Inicia el escaneo del código QR
//       String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           "#ff6666", 'Cancelar', true, ScanMode.DEFAULT);

//       //LEEMOSQR -> ( id | nombre | dorsal)
//       // Divide el resultado del escaneo en una lista de datos
//       List<String> listDataQrLeido = barcodeScanRes.split('|');
//       String idRunnerQRLeido = listDataQrLeido[0]; // Obtiene el ID del corredor

//       // TODOS Trabajamos con un Provider
//       // Busca el corredor en la lista usando el ID escaneado
//       runnerQrScanState.buscarRunnerIdScaneado(
// idScanerQr: idRunnerQRLeido, listData: widget.runnerList);
//       // Obtiene los detalles del corredor
//       ParticipantesModel isRunner = runnerQrScanState.isRunner;
//       String dorsal = runnerQrScanState.dorsal;
//       String nombre = runnerQrScanState.nombre;
//       //verificamos que su id no sea nulo
//       if (isRunner.id != null) {
//         // Muestra un cuadro de diálogo con los detalles del corredor
//         modalSheetDetallesCorredor(context);

//         // Verifica si el usuario está en modo offline o en línea y maneja la asistencia
//         //TODOS llamamos lista de checkpoints  //final List<TCheckPointsModel> checkpointList;
//         // Verifica si ya existe una asistencia registrada del corredor
//         TChekListmodel02File? puntoDeControl;

//         try {
//           //todos OJO AQUI, no considerar la fecha no es nesesario,
//           //si el corredor debe registrasre un unica ves en la vida
//           puntoDeControl = widget.checkpointList.firstWhere(
//               (e) => e.idCorredor == isRunner.id
//               // && e.fecha.day == DateTime.now().day,
//               ,
//               orElse: null);
//           //guardamos Provider La asistencia en punto de control encontrado en provider
//           runnerQrScanState.setScanerSaveCheckListFile(puntoDeControl);
//         } catch (e) {
//           print('Error al buscar la asistencia para hoy: $e');
//         }

//         //Otenemos la asistnecia de Provider
//         TChekListmodel02File personScaner =
//             runnerQrScanState.personScanerCheckListFile;
//         // Actualiza o guarda la entrada dependiendo de la existencia previa
//         if (puntoDeControl?.id != null) {
//           // Muestra un cuadro de diálogo informando que no se encontró el corredor
//           bool isContinue = await showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   TextToSpeechService().speak(
//                     'El corredor ya está registrado. ¿Actualizar hora?',
//                   );
//                   return AssetAlertDialogPlatform(
//                     message:
//                         '¿Actualizar la hora de marcación? Presione "OK" para confirmar.',
//                     title: 'Registro Existente',
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(
//                               true); // Cierra el diálogo y permite reintentar
//                         },
//                         child: Text('No actualizar')), // Texto del botón
//                   );
//                 },
//               ) ??
//               true;

//           if (!isContinue) {
//             editarEntrada(
//                 isRunner: isRunner,
//                 personScaner: personScaner,
//                 runnerQrScanState: runnerQrScanState); // Actualiza la entrada
//             AssetAlertDialogPlatform.show(
//                 context: context,
//                 message: 'Registro actualizado en el servidor.',
//                 title: 'Registro Actualizado',
//                 child: AppSvg(width: 80).serverBlue);
//             SoundUtils.vibrate(); // Realiza una vibración
//           }
//         } else {
//           // Reproduce un mensaje de texto usando el servicio de texto a voz
//           TextToSpeechService().speak(
//             '${nombre} ${isRunner.apellidos},' +
//                 'Dorsal: ${dorsal == 'N/A' ? 'No asignado' : dorsal}' +
//                 ' Distancia: ${isRunner.distancias}',
//           );
//           guardarEntrada(
//               isRunner: isRunner,
//               runnerQrScanState: runnerQrScanState); // Guarda la entrada
//           AssetAlertDialogPlatform.show(
//               context: context,
//               message: 'Registro guardado en el servidor.',
//               title: 'Registro Exitoso',
//               child: AppSvg(width: 80).serverBlue);
//           SoundUtils.vibrate(); // Realiza una vibración
//         }
//       } else {
//         noSeEncontroCorredor(
//           runnerQrScanState: runnerQrScanState,
//         );
//       }
//     } catch (e) {
//       print('Error $e');
//       AssetAlertDialogPlatform.show(
//           context: context, message: 'Error $e', title: 'Error');
//     }
//   }

//   void noSeEncontroCorredor(
//       {required RunnerQrScanState runnerQrScanState}) async {
//     TextToSpeechService().speak(
//       'No se encontró corredor',
//     );
//     // Muestra un cuadro de diálogo informando que no se encontró el corredor
//     bool isContinue = await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AssetAlertDialogPlatform(
//               message: 'Presione "OK" para intentar de nuevo.',
//               title: 'No se encontró corredor',
//               child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true); // Cierra el diálogo
//                   },
//                   child: Text('No intentar')), // Texto del botón
//             );
//           },
//         ) ??
//         true;
//     if (!isContinue) {
//       //False permite reintentar
//       // Si el usuario decide intentar de nuevo, vuelve a escanear el QR
//       _scanQRCode(
//         runnerQrScanState: runnerQrScanState,
//       ); // Llama al método para escanear QR nuevamente
//     }
//   }

//   // Método para actualizar la entrada en el servidor
//   Future<void> editarEntrada(
//       {required ParticipantesModel isRunner,
//       required TChekListmodel02File personScaner,
//       required RunnerQrScanState runnerQrScanState}) async {
//     final TChekListmodel02File editar = TChekListmodel02File(
//       id: personScaner.id,
//       idCorredor: isRunner.id!,
//       idCheckList: widget.idCheckList,
//       fecha: DateTime.now(),
//       estado: true, //Verdadero si ya se registro
//       nombre: isRunner.nombre + " " + isRunner.apellidos,
//       dorsal: isRunner.dorsal,
//       fileUrl: '',
//       detalles: isRunner.distancias,
//     );
//     // await context.read<TCheckP00Provider>().saveProductosApp(editar);
//     await widget.saveProductosApp(editar);

//     runnerQrScanState.setScanerSaveCheckListFile(editar);
//   }

//   // Método para guardar la entrada en el servidor
//   Future<void> guardarEntrada(
//       {required ParticipantesModel isRunner,
//       required RunnerQrScanState runnerQrScanState}) async {
//     final TChekListmodel02File guardar = TChekListmodel02File(
//       id: '',
//       idCorredor: isRunner.id!,
//       idCheckList: widget.idCheckList,
//       fecha: DateTime.now(),
//       estado: true, //Verdadero si ya se registro
//       nombre: isRunner.nombre + " " + isRunner.apellidos,
//       dorsal: isRunner.dorsal,
//       fileUrl: '',
//       detalles: isRunner.distancias,
//     );
//     // await context.read<TCheckP00Provider>().saveProductosApp(guardar);
//     await widget.saveProductosApp(guardar);
//     runnerQrScanState.setScanerSaveCheckListFile(guardar);
//   }

//   void modalSheetDetallesCorredor(BuildContext context) {
//     // Reproduce un sonido cuando se encuentra un participante
//     SoundUtils.playSound();
//     showCustomBottonSheet(
//         backgroundColor: Colors.white38,
//         sheetAnimationStyle: AnimationStyle(),
//         context: context,
//         builder: (BuildContext context) {
//           final size = MediaQuery.of(context).size;
//           final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
//           String dorsal = runnerQrScanState.dorsal;
//           String nombre = runnerQrScanState.nombre;
//           ParticipantesModel isRunner = runnerQrScanState.isRunner;
//           TChekListmodel02File runnerChekpoints =
//               runnerQrScanState.personScanerCheckListFile;
//           return Container(
//             margin: EdgeInsets.all(10),
//             padding: const EdgeInsets.all(30.0),
//             constraints: BoxConstraints(maxWidth: 500),
//             decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white54,
//                     blurRadius: 5.0,
//                     spreadRadius: 1.0,
//                     offset: Offset(0.0, 3.0),
//                   )
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GLobalImageUrlServer(
//                         height: size.width * .3,
//                         width: size.width * .3,
//                         duration: 300,
//                         fadingDuration: 600,
//                         image: isRunner.imagen ?? '',
//                         collectionId: isRunner.collectionId ?? '',
//                         id: isRunner.id ?? "",
//                         borderRadius: BorderRadius.circular(300)),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           H1Text(
//                               text: nombre + ' ' + isRunner.apellidos,
//                               fontSize: 25,
//                               maxLines: 5,
//                               textAlign: TextAlign.center),
//                           P1Text(
//                             text: isRunner.distancias.toString().toUpperCase(),
//                             color: AppColors.buttonPrimary,
//                           ),
//                           P1Text(
//                             text: isRunner.pais,
//                           ),
//                           H1Text(
//                             text: dorsal,
//                             fontSize: 40,
//                           ),
//                           P3Text(
//                             text: 'Número de dorsal',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 P2Text(text: 'Hora de marcación'.toUpperCase()),
//                 H2Text(text: formatFecha(runnerChekpoints.fecha)),
//                 H1Text(
//                   text: formatFechaPDfhora(runnerChekpoints.fecha),
//                   fontSize: 40,
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }
