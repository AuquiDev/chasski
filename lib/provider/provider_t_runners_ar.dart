// ignore_for_file: avoid_print


import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/poketbase/t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
// import 'package:chaskis/poketbase/t_asistencia.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class TRunnersProvider with ChangeNotifier { 
  List<TRunnersModel> listaRunner = [];

  TRunnersProvider() {
    print('RUNNERS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TRunnersModel> get e => listaRunner;

  void addAsistencia(TRunnersModel e) {
    listaRunner.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TRunnersModel e) {
    listaRunner[listaRunner.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TRunnersModel e) {
    listaRunner.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TRunners.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TRunnersModel ubicaciones =  TRunnersModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? idDistancia,
    String? nombre,
    String? apellidos,
    String? dorsal,
    String? pais,
    String? telefono,
    bool? estado,
    String? genero,
    int? numeroDeDocumentos,
    String? tallaDePolo, }) async {
    isSyncing = true;
    notifyListeners();
    TRunnersModel data = TRunnersModel(
        id: '',
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      nombre: nombre!,
      apellidos: apellidos!,
      dorsal: dorsal!,
      pais: pais!,
      telefono: telefono!,
      estado: estado!,
      genero: genero!,
      numeroDeDocumentos: numeroDeDocumentos!,
      tallaDePolo: tallaDePolo!,
        );

    await TRunners.postAsistenciaPk(data, );

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? idDistancia,
    String? nombre,
    String? apellidos,
    String? dorsal,
    String? pais,
    String? telefono,
    bool? estado,
    String? genero,
    int? numeroDeDocumentos,
    String? tallaDePolo, 
     File? imagenFile}) async {
    isSyncing = true;
    notifyListeners();
    TRunnersModel data = TRunnersModel(
        id: id!,
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      nombre: nombre!,
      apellidos: apellidos!,
      dorsal: dorsal!,
      pais: pais!,
      telefono: telefono!,
      estado: estado!,
      genero: genero!,
      numeroDeDocumentos: numeroDeDocumentos!,
      tallaDePolo: tallaDePolo!,);

    await TRunners.putAsitneciaPk(id: id, data: data,imagen:imagenFile );

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TRunners.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TRunnersModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEvento: e.idEvento,
        idDistancia: e.idDistancia,
        nombre: e.nombre,
        apellidos: e.apellidos,
        dorsal: e.dorsal,
        pais: e.pais,
        telefono: e.telefono,
        estado: e.estado,
        genero: e.genero,
        numeroDeDocumentos: e.numeroDeDocumentos,
        tallaDePolo: e.tallaDePolo,
      );
      print('POST RUNNERS API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idEvento: e.idEvento,
        idDistancia: e.idDistancia,
        nombre: e.nombre,
        apellidos: e.apellidos,
        dorsal: e.dorsal,
        pais: e.pais,
        telefono: e.telefono,
        estado: e.estado,
        genero: e.genero,
        numeroDeDocumentos: e.numeroDeDocumentos,
        tallaDePolo: e.tallaDePolo,
      );
      print('PUT RUNNERS API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_corredores').subscribe('*', (e) {
      print('REALTIME Runners ${e.action}');
      print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

  bool islogin = false;

void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('song/gota.mp3')); // Ruta a tu archivo de sonido
  }
  //Metodo de Autentificacion
  Future<bool> login({ BuildContext? context, int? cedulaDNI,
  // String? idUsuario
  }) async {
    islogin = true;
    notifyListeners();
    // ignore: unused_local_variable
    int userindex = -1;
    try {
      //CONDICIONALOFFLINE aumentamos este codigo para asignar el valor de la listausuarios en modo offline.
      // bool isOffline =   Provider.of<UsuarioProvider>(context!, listen: false).isOffline;

      // final listaRunnerSQL = Provider.of<DBRunnersAppProvider>(context, listen: false).listsql;

      // listaRunner = isOffline ? listaRunnerSQL : listaRunner;
      //Esta bsuqueda devulece un umeor, si el numero estabne en leindex es decir de 0 a mas , si es menor de 0 el usuairo n oexiste.
      userindex = listaRunner.indexWhere((e) {
       
        bool ismath = (
          e.numeroDeDocumentos.toString().toLowerCase() ==  
          cedulaDNI.toString().toLowerCase() 
          // &&  e.telefono == idUsuario
          );
       
        if (ismath) {
          // Si se encuentra el usuario, establecerlo en UsuarioProvider
          Provider.of<RunnerProvider>(context!, listen: false)  .setusuarioLogin(e);
          // Guardar la información del usuario en SharedPreferences
          SharedPrefencesGlobal().saveIDEvento(e.idEvento);
          SharedPrefencesGlobal().saveIDDistancia(e.idDistancia);///
          SharedPrefencesGlobal().saveID(e.id!);
          SharedPrefencesGlobal().saveNombreRun(e.nombre);
          SharedPrefencesGlobal().saveApellidos(e.apellidos);
          SharedPrefencesGlobal().saveDorsal(e.dorsal);
          SharedPrefencesGlobal().savePais(e.pais);
          SharedPrefencesGlobal().saveTallaPolo(e.tallaDePolo);
          
         
          SharedPrefencesGlobal().saveImageRun(e.imagen!);
          SharedPrefencesGlobal().saveCollectionID(e.collectionId!);
        }
        return ismath;
      });
   
      //Hacer un sonido si el usuario ha sido en contrado
      if (userindex != -1) {
        playSound();
      }
    } catch (e) {
      userindex = -1;
        
    }
    
    // Simular una carga con un temporizador
    await Future.delayed(const Duration(seconds: 2));
   
    // Lógica de navegación o mensaje de error
    if (userindex != -1) {
        print('ESTATE IF: $islogin');
      islogin = true;
      notifyListeners();
      // Configurar un temporizador para cambiar islogin a false después de 2 segundos
      Timer(const Duration(seconds: 4), () {
        islogin = false;
        notifyListeners();
      });
      return islogin;
    } else {
      print('ESTATE ELSE: $islogin - $userindex');
      islogin = false;
      notifyListeners();
      return islogin;
    }
  }
}
