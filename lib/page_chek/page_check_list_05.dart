// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:chasski/models/model_check_list_1.dart';
import 'package:chasski/provider/provider_t_checklist_05.dart';
// import 'package:chasski/provider/provider_t_checklist_01.dart';

import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/models/model_runners_ar.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:chasski/widgets/close_page_buton.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vibration/vibration.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:delayed_display/delayed_display.dart';

//PAGINA PARA SCANEAR QR
class QrPage05ChList extends StatefulWidget {
  const QrPage05ChList(
      {super.key, required this.idCheckList, required this.name});
  final String idCheckList;
  final String name;

  @override
  State<QrPage05ChList> createState() => _QrPage05ChListState();
}

class _QrPage05ChListState extends State<QrPage05ChList> {
  FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    // Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();
    // Provider.of<DBCheckPointsAppProviderAr00>(context, listen: false).initDatabase();
    // Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    //  Provider.of<DBTListCheckPoitns_ARProvider>(context, listen: false).initDatabase();
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      speackQr('Presione sobre la imagen QR para comenzar.');
    });
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener la reproducción de TTS
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isffline = Provider.of<UsuarioProvider>(context).isOffline;
    //LISTA OFFLINE
    final runnerServerList =
        Provider.of<TRunnersProvider>(context).listaRunner;
    // final runnerSQlList = Provider.of<DBRunnersAppProvider>(context).listsql;
    List<TRunnersModel> runnerList =
        // isffline ? runnerSQlList : 
        runnerServerList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white10,
                border: Border.all(
                    style: BorderStyle.solid, color: Color(0xD7AB0D0D)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 1200),
                    child: QrScannerAR0(
                      runnerList: runnerList,
                      idCheckList: widget.idCheckList,
                    ),
                  ),
                  //NO CAMBIAN 
                  H2Text(
                      text: 'QR SCANNER'.toUpperCase(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                  H2Text(
                      text: widget.name.toUpperCase(),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  H2Text(
                      text:
                          'Presione sobre la imagen para escanear corredor.',
                      fontSize: 12,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: Colors.white54),
                ],
              ),
            ),
          ),
           Positioned(
              right: 20,
              top: 20,
              child: SafeArea(child: OfflineSIgnalButon())),
          Positioned(left: 10, top: 10, child: ClosePageButon()),
        ],
      ),
    );
  }

  speackQr(text) async {
    await flutterTts.stop(); // Detener la reproducción de TTS
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode);
    await flutterTts.speak(text);
  }
}



///QR SCANNER
class QrScannerAR0 extends StatefulWidget {
  const QrScannerAR0({
    super.key,
    required this.runnerList,
    required this.idCheckList,
  });

  final List<TRunnersModel> runnerList;
  final String idCheckList;
  @override
  State<QrScannerAR0> createState() => _QrScannerAR0State();
}

class _QrScannerAR0State extends State<QrScannerAR0> {
  FlutterTts flutterTts = FlutterTts();
  TRunnersModel isPerson = TRunnersModel(
    id: '',
    idEvento: '-',
    idDistancia: '-',
    nombre: '-',
    apellidos: '-',
    dorsal: '-',
    pais: '-',
    telefono: '-',
    estado: true,
    genero: '-',
    numeroDeDocumentos: 0,
    tallaDePolo: '-',
  );

  bool isParticle = false;
  void particleinsta() {
    setState(() {
      isParticle = true;
    });

    // Después de 2 segundos, establece isParticle en false
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isParticle = false;
      });
    });
  }

  //PERSONAL Asistencia Encontrado
  TChekListmodel01 personScaner = TChekListmodel01(
    id: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    idCorredor: '',
    idCheckList: '',
    fecha: DateTime.now(),
    estado: true,
    nombre: '',
    dorsal: '',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _scanQRCode(); //SCANNER QR
        particleinsta();
      },
      child: FadeOutParticle(
        disappear: isParticle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/img/qr_imgs.png',
            width: 220,
          ),
        ),
      ),
    );
  }

  Future<bool> hasVibrator() async {
    return (await Vibration.hasVibrator()) ?? false;
  }

  Future<void> vibrate() async {
    if (await hasVibrator()) {
      Vibration.vibrate(duration: 500);
    }
  }

  void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer
        .play(AssetSource('song/tono.mp3')); // Ruta a tu archivo de sonido
  }

  //SCANEAR QR
  Future<void> _scanQRCode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", 'Cancelar', true, ScanMode.DEFAULT);

      List<String> personalData =
          barcodeScanRes.split('|'); //Conveirte el String en una lista
      String idpersonal = personalData[0]; //El primer Elemento de la lista

      TRunnersModel person = widget.runnerList.firstWhere(
        (p) => p.id == idpersonal,
        orElse: () => TRunnersModel(
          idEvento: '-',
          idDistancia: '-',
          nombre: 'nombre',
          apellidos: '-',
          dorsal: 'dorsal',
          pais: '-',
          telefono: '-',
          estado: true,
          genero: '-',
          numeroDeDocumentos: 0,
          tallaDePolo: '-',
        ),
      );

      setState(() {
        isPerson = person;
      });

      if (person.id != null) {
        playSound();

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Marcación Exitosa',
          text: 'DORSAL: ${isPerson.dorsal}.\nNOMBRE: ${isPerson.nombre + isPerson.apellidos}.',
          confirmBtnColor: Colors.green,
          confirmBtnText: 'OK',
          width: 300,
          onConfirmBtnTap: () {
            _scanQRCode(); //SCANNER QR
            particleinsta();
            Navigator.pop(context);
          },
        );
        speackQr(
          'Dorsal Numero:${isPerson.dorsal}.   \n: ${isPerson.nombre + isPerson.apellidos}.',
        );
        //SIQREXISTE guardamos en la Base de datos
        // final listSql =   Provider.of<DBCheckPointsAppProviderAr00>(context, listen: false).listsql;
        final listServer = Provider.of<TCheckList05Provider>(context, listen: false).listAsistencia;
        final isOffline =  Provider.of<UsuarioProvider>(context, listen: false).isOffline;
        // Verificamos si el usuario ya tiene una asistencia registrada para hoy
        TChekListmodel01? asistenciaPersonal;
        try {
          asistenciaPersonal = 
          // isOffline
          //     ? listSql.firstWhere(
          //         (e) {
          //           print('List SQl : ${e.nombre}');
          //           return e.nombre == isPerson.nombre &&
          //               e.fecha.day == DateTime.now().day;
          //         },
          //       )
          //     : 
              listServer.firstWhere(
                  (e) {
                    print('List SERVER : ${e.nombre}');
                    return e.nombre == isPerson.nombre &&
                        e.fecha.day == DateTime.now().day;
                  },
                );
          vibrate();
          setState(() {
            personScaner = asistenciaPersonal!;
          });
        } catch (e) {
          print('Error al buscar la asistencia para hoy: $e');
        }

        // Comprobamos si la asistencia para hoy existe y tiene un ID no nulo
        if (asistenciaPersonal?.id != null) {
          // isOffline ? editarffline() : 
          editarEntrada();
          print('Asistencia editada');
        } else {
          // isOffline ? enviaroffline() : 
          guardarEntrada();
          print('Asistencia guardada');
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'No se encontró corredor',
          confirmBtnColor: Color(0xFFD3271A),
          confirmBtnText: 'Ok',
          width: 300,
          onConfirmBtnTap: () {
            _scanQRCode(); //SCANNER QR
            particleinsta();
            Navigator.pop(context);
          },
        );
        speackQr(
          'No se encontró corredor',
        );
      }
    } catch (e) {
      print('Error $e');
    }
  }

  speackQr(text) async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setSharedInstance(true);
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.defaultMode);
    await flutterTts.speak(text);
  }

  // //SQLLITE
  // Future<void> enviaroffline() async {
  //   // final user =
  //   //     Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
  //   final TCheckPointsModel offlineData = TCheckPointsModel(
  //     id: '',
  //     created: DateTime.now(),
  //     updated: DateTime.now(),
  //     idCorredor: isPerson.id!,
  //     idCheckPoints: widget.idCheckPoints,
  //     fecha: DateTime.now(),
  //     estado: true,
  //     // nombre: isPerson.nombre + ' ' + isPerson.apellidos,
  //      nombre: isPerson.nombre,
  //     dorsal: isPerson.dorsal,
  //   );
  //   await context.read<DBCheckPointsAppProviderAr00>().insertData(offlineData, true);
  // }

  // Future<void> editarffline() async {
  //   final TCheckPointsModel offlineData = TCheckPointsModel(
  //     id: personScaner.id,
  //     created: personScaner.created,
  //     updated: DateTime.now(),
  //     idCorredor: isPerson.id!,
  //     idCheckPoints: widget.idCheckPoints,
  //     fecha: DateTime.now(),
  //     estado: true,
  //     // nombre: isPerson.nombre + ' ' + isPerson.apellidos,
  //      nombre: isPerson.nombre,
  //     dorsal: isPerson.dorsal,
  //   );
  //   print('EDIT DATA : offlinee ${personScaner.id}');
  //   await context
  //       .read<DBCheckPointsAppProviderAr00>()
  //       .updateData(offlineData, personScaner.idsql!, true);
  // }

//SERVER
  Future<void> editarEntrada() async {
    await context.read<TCheckList05Provider>().updateTAsistenciaProvider(
          id: personScaner.id,
          idCorredor: isPerson.id!,
          idCheckList: widget.idCheckList,
          fecha: DateTime.now(),
          estado: true,
          // nombre: isPerson.nombre + ' ' + isPerson.apellidos,
          nombre: isPerson.nombre,
          dorsal: isPerson.dorsal,
        );
  }

  Future<void> guardarEntrada() async {
    await context.read<TCheckList05Provider>().postTAsistenciaProvider(
          id: '',
          idCorredor: isPerson.id!,
          idCheckList: widget.idCheckList,
          fecha: DateTime.now(),
          estado: true,
          // nombre: isPerson.nombre + ' ' + isPerson.apellidos,
           nombre: isPerson.nombre,
          dorsal: isPerson.dorsal,
        );
  }
}
