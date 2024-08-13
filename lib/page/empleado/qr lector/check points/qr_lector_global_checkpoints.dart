import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/page/empleado/check%20poins/lista%20puntos/checkpoint_list.dart';
import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/provider/runners/offline/provider_sql___participantes.dart';
import 'package:chasski/provider/cache/qr%20validation/provider_qr_statescan.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/dialogs/assets_butonsheets.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/files/assets_play_sound.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/widget/estate%20app/state_icon_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:chasski/utils/text/assets_textapp.dart';

//TODOS SCANQR PUNTO PARTIDA
class QrLectoGlobalChekPoint extends StatefulWidget {
  const QrLectoGlobalChekPoint({
    super.key,
    required this.idCheckPoints,
    required this.name,
    required this.providersMap,
    required this.orden,
  });
  final String idCheckPoints;
  final String name;
  final int orden;
  final ProvidersMap providersMap;

  @override
  State<QrLectoGlobalChekPoint> createState() => _QrLectoGlobalChekPointState();
}

class _QrLectoGlobalChekPointState extends State<QrLectoGlobalChekPoint> {
  @override
  void initState() {
    super.initState();
    DatabaseInitializer.initializeDatabase(context);
    toSpeack();
  }

  void toSpeack() {
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      TextToSpeechService()
          .speak('¡Escaneo QR activado! Presiona aquí para comenzar.');
    });
  }

  // Nueva función de callback para actualizar el estado
  //TODOS es importante redibujar toda la pagina cada ves que se registra un dato, por eso se envie un setesta co papramtro widget hijo.
  void updateParentState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isOffline = Provider.of<OfflineStateProvider>(context).isOffline;

    //Lista servidor
    final runnerServerList =
        Provider.of<TParticipantesProvider>(context).listaRunner;
    //Lista SQL
    final runnerSQlList =
        Provider.of<DBParticiapntesAppProvider>(context).listsql;

    //Lista Elegida
    List<ParticipantesModel> runnerList =
        isOffline ? runnerSQlList : runnerServerList;

    //PUNTOSQL DECONTROL 0
    // Accede a los proveedores desde el providersMap; de acuerdo al orden
    final checkPointProviders = widget.providersMap['${widget.orden}'] ?? [];

    // final listSql = Provider.of<DBCheckPointsAppProviderAr02>(context).listsql;
    final listSql = checkPointProviders[0].listsql;
    //PUNTOSERVER DECONTROL 0
    // final listServer = Provider.of<TCheckP02Provider>(context).listAsistencia;
    final listServer = checkPointProviders[1].listAsistencia;

    List<TCheckPointsModel> checkpointList = isOffline ? listSql : listServer;

    return Scaffold(
      appBar: AppBar(
        title: H2Text(
          text: widget.orden.toString() + ') ' + widget.name,
          color: AppColors.backgroundLight,
        ),
        actions: [
          //INFORMACION DE CARRERA
          ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              style: buttonStyle2(),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Container()));
              },
              icon: SignalAPi(),
              label: H1Text(text: '${checkpointList.length}')),
        ],
      ),
      body: Center(
        child: AssetsDelayedDisplayYbasic(
          duration: 300,
          child: QrScannerAR0(
            runnerList: runnerList,
            idCheckPoints: widget.idCheckPoints,
            checkpointList: checkpointList,
            isOffline: isOffline,
            //FUnciones
            insertData: (offlineData) async {
              // await context
              //     .read<DBCheckPointsAppProviderAr02>()
              //     .insertData(offlineData, false);
              await checkPointProviders[0].insertData(offlineData);
            },
            updateData: (offlineData, int id) async {
              // await context
              //     .read<DBCheckPointsAppProviderAr02>()
              //     .updateData(offlineData, id, false);
              await checkPointProviders[0].updateData(offlineData, id);
            },
            saveProductosApp: (data) async {
              // await context.read<TCheckP02Provider>().saveProductosApp(data);
              await checkPointProviders[1].saveProductosApp(data);
            },
            editarEntrada: (data) async {
              // await context.read<TCheckP02Provider>().saveProductosApp(data);
              await checkPointProviders[1].saveProductosApp(data);
            },
            // Pasar la función de callback al widget hijo
            updateParent: updateParentState,
          ),
        ),
      ),
    );
  }
}

/// Widget para escanear QR y gestionar la asistencia de corredores
class QrScannerAR0 extends StatefulWidget {
  const QrScannerAR0({
    super.key,
    required this.runnerList, // Lista de corredores participantes
    required this.idCheckPoints,
    required this.checkpointList,
    required this.isOffline,
    //FUnciones CRUD
    required this.insertData,
    required this.updateData,
    required this.saveProductosApp,
    required this.editarEntrada,
    required this.updateParent, // Nueva función de callback
  });

  final List<ParticipantesModel> runnerList;
  final String idCheckPoints;
  final List<TCheckPointsModel> checkpointList;
  final bool isOffline;

  final Future<void> Function(TCheckPointsModel) insertData;
  final Future<void> Function(TCheckPointsModel, int) updateData;
  final Future<void> Function(TCheckPointsModel) saveProductosApp;
  final Future<void> Function(TCheckPointsModel) editarEntrada;
  final VoidCallback updateParent; // Nueva función de callback
  @override
  State<QrScannerAR0> createState() => _QrScannerAR0State();
}

class _QrScannerAR0State extends State<QrScannerAR0> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.height * .4;
    final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(width: 60).checkPointsSvg,
        H1Text(
          text: 'Puntos de control'.toUpperCase(),
          fontWeight: FontWeight.w900,
        ),
        P1Text(
          text: 'Escáner QR de Corredores',
        ),
        AppLoties(width: width).qrLoties,
        ElevatedButton.icon(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(10), // Elevación del botón
            backgroundColor: MaterialStatePropertyAll(
                AppColors.primaryRed), // Color de fondo del botón
          ),
          onPressed: () {
            // Llama al método para escanear QR
            _scanQRCode(
              runnerQrScanState: runnerQrScanState,
            );
            // Llamar la función de callback para notificar al padre
            widget.updateParent();
          },
          icon: AppSvg().checkPointsSvg,
          label: Padding(
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
      String nombre = runnerQrScanState.nombre;
      //verificamos que su id no sea nulo
      if (isRunner.id != null) {
        // Muestra un cuadro de diálogo con los detalles del corredor
        modalSheetDetallesCorredor(context);

        // Verifica si el usuario está en modo offline o en línea y maneja la asistencia
        //final bool isOffline; <= ya lo pasamos como Parametro
        //TODOS llamamos lista de checkpoints
        //final List<TCheckPointsModel> checkpointList;<= ya lo psamos como parametro
        // Verifica si ya existe una asistencia registrada del corredor
        TCheckPointsModel? puntoDeControl;

        try {
          //todos OJO AQUI, no considerar la fecha no es nesesario,
          //si el corredor debe registrasre un unica ves en la vida
          puntoDeControl = widget.checkpointList.firstWhere(
              (e) => e.idCorredor == isRunner.id
              // && e.fecha.day == DateTime.now().day,
              ,
              orElse: null);
          //guardamos Provider La asistencia en punto de control encontrado en provider
          runnerQrScanState.setScanerSaveCheckPoint(puntoDeControl);
        } catch (e) {
          print('Error al buscar la asistencia para hoy: $e');
        }

        //Otenemos la asistnecia de Provider
        TCheckPointsModel personScaner = runnerQrScanState.personScaner;
        // Actualiza o guarda la entrada dependiendo de la existencia previa
        if (puntoDeControl?.id != null) {
          //TODOS OJOS AL COMPARAR
          // Muestra un cuadro de diálogo informando que no se encontró el corredor
          bool isContinue = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextToSpeechService().speak(
                    'El corredor ya está registrado. ¿Actualizar hora?',
                  );
                  return AssetAlertDialogPlatform(
                    message:
                        '¿Actualizar la hora de marcación? Presione OK para confirmar.',
                    title: 'Registro Existente',
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              true); // Cierra el diálogo y permite reintentar
                        },
                        child: Text('No actualizar')), // Texto del botón
                  );
                },
              ) ??
              true;
          if (!isContinue) {
            widget.isOffline
                ? editarffline(
                    isRunner: isRunner,
                    personScaner: personScaner,
                    runnerQrScanState: runnerQrScanState)
                : editarEntrada(
                    isRunner: isRunner,
                    personScaner: personScaner,
                    runnerQrScanState:
                        runnerQrScanState); // Actualiza la entrada
            AssetAlertDialogPlatform.show(
                context: context,
                message: widget.isOffline
                    ? 'Registro actualizado localmente.'
                    : 'Registro actualizado en el servidor.',
                title: 'Registro Actualizado',
                child: widget.isOffline
                    ? AppSvg(width: 80).databaseBlue
                    : AppSvg(width: 80).serverBlue);
            SoundUtils.vibrate(); // Realiza una vibración
          }
        } else {
          // Reproduce un mensaje de texto usando el servicio de texto a voz
          TextToSpeechService().speak(
            '${nombre} ${isRunner.apellidos},' +
                'Dorsal: ${dorsal == 'N/A' ? 'No asignado' : dorsal}' +
                ' Distancia: ${isRunner.distancias}',
          );
          widget.isOffline
              ? enviaroffline(
                  isRunner: isRunner, runnerQrScanState: runnerQrScanState)
              : guardarEntrada(
                  isRunner: isRunner,
                  runnerQrScanState: runnerQrScanState); // Guarda la entrada
          AssetAlertDialogPlatform.show(
              context: context,
              message: widget.isOffline
                  ? 'Registro guardado localmente.'
                  : 'Registro guardado en el servidor.',
              title: 'Registro Exitoso',
              child: widget.isOffline
                  ? AppSvg(width: 80).databaseBlue
                  : AppSvg(width: 80).serverBlue);

          SoundUtils.vibrate(); // Realiza una vibración
        }
      } else {
        noSeEncontroCorredor(
          runnerQrScanState: runnerQrScanState,
        );
      }
    } catch (e) {
      print('Error $e');
      AssetAlertDialogPlatform.show(
          context: context, message: 'Error $e', title: 'Error');
    }
  }

  void noSeEncontroCorredor(
      {required RunnerQrScanState runnerQrScanState}) async {
    TextToSpeechService().speak(
      'No se encontró corredor',
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

  // Método para enviar datos offline a la base de datos
  Future<void> enviaroffline(
      {required ParticipantesModel isRunner,
      required RunnerQrScanState runnerQrScanState}) async {
    final TCheckPointsModel offlineData = TCheckPointsModel(
      id: '',
      created: DateTime.now(),
      updated: DateTime.now(),
      idCorredor: isRunner.id!,
      idCheckPoints: widget.idCheckPoints,
      fecha: DateTime.now(),
      estado: true,
      nombre: isRunner.nombre + " " + isRunner.apellidos,
      dorsal: isRunner.dorsal, // Dorsal del participante
    );

    // await context.read<DBCheckPointsAppProviderAr00>().insertData(offlineData);
    await widget.insertData(offlineData);
    runnerQrScanState.setScanerSaveCheckPoint(offlineData);
  }

  // Método para editar datos offline en la base de datos
  Future<void> editarffline(
      {required ParticipantesModel isRunner,
      required TCheckPointsModel personScaner,
      required RunnerQrScanState runnerQrScanState}) async {
    final TCheckPointsModel offlineData = TCheckPointsModel(
      id: personScaner.id,
      created: personScaner.created,
      updated: DateTime.now(),
      idCorredor: isRunner.id!,
      idCheckPoints: widget.idCheckPoints,
      fecha: DateTime.now(),
      estado: true,
      nombre: isRunner.nombre + " " + isRunner.apellidos,
      dorsal: isRunner.dorsal,
    );
    // await context
    //     .read<DBCheckPointsAppProviderAr00>()
    //     .updateData(offlineData, personScaner.idsql!);
    await widget.updateData(offlineData, personScaner.idsql!);
    runnerQrScanState.setScanerSaveCheckPoint(offlineData);
  }

  // Método para actualizar la entrada en el servidor
  Future<void> editarEntrada(
      {required ParticipantesModel isRunner,
      required TCheckPointsModel personScaner,
      required RunnerQrScanState runnerQrScanState}) async {
    final TCheckPointsModel editar = TCheckPointsModel(
      id: personScaner.id,
      idCorredor: isRunner.id!,
      idCheckPoints: widget.idCheckPoints,
      fecha: DateTime.now(),
      estado: true,
      nombre: isRunner.nombre + " " + isRunner.apellidos,
      dorsal: isRunner.dorsal,
    );
    // await context.read<TCheckP00Provider>().saveProductosApp(editar);
    await widget.saveProductosApp(editar);

    runnerQrScanState.setScanerSaveCheckPoint(editar);
  }

  // Método para guardar la entrada en el servidor
  Future<void> guardarEntrada(
      {required ParticipantesModel isRunner,
      required RunnerQrScanState runnerQrScanState}) async {
    final TCheckPointsModel guardar = TCheckPointsModel(
      id: '',
      idCorredor: isRunner.id!,
      idCheckPoints: widget.idCheckPoints,
      fecha: DateTime.now(),
      estado: true,
      nombre: isRunner.nombre + " " + isRunner.apellidos,
      dorsal: isRunner.dorsal,
    );
    // await context.read<TCheckP00Provider>().saveProductosApp(guardar);
    await widget.saveProductosApp(guardar);
    runnerQrScanState.setScanerSaveCheckPoint(guardar);
  }

  void modalSheetDetallesCorredor(BuildContext context) {
    // Reproduce un sonido cuando se encuentra un participante
    SoundUtils.playSound();
    showCustomBottonSheet(
        backgroundColor: Colors.white30,
        // sheetAnimationStyle: AnimationStyle(),
        context: context,
        builder: (BuildContext context) {
          final size = MediaQuery.of(context).size;
          final runnerQrScanState = Provider.of<RunnerQrScanState>(context);
          String dorsal = runnerQrScanState.dorsal;
          String nombre = runnerQrScanState.nombre;
          ParticipantesModel isRunner = runnerQrScanState.isRunner;
          TCheckPointsModel runnerChekpoints = runnerQrScanState.personScaner;
          return Container(
            margin: EdgeInsets.only(left:30, right: 30, bottom: 30),
            padding: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
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
                      child: FittedBox(
                        child: Column(
                          children: [
                            H1Text(
                                text: nombre + '\n' + isRunner.apellidos,
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
                              text: dorsal,
                              fontSize: 40,
                            ),
                            P3Text(
                              text: 'Número de dorsal',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                P2Text(text: 'Hora de marcación'.toUpperCase()),
                H2Text(text: formatFecha(runnerChekpoints.fecha)),
                H1Text(
                  text: formatFechaPDfhora(runnerChekpoints.fecha),
                  fontSize: 40,
                )
              ],
            ),
          );
        });
  }
}
