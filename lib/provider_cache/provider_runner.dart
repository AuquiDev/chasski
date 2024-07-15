// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chasski/models/model_runners_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';

class RunnerProvider extends ChangeNotifier {
  //PDF FILE - CERTIF. MEDICO 
  File? _medicalCertificateFile;

  File? get medicalCertificateFile => _medicalCertificateFile;

  void setMedicalCertificateFile(File file) {
    print('FILE: $file');
    _medicalCertificateFile = file;
    notifyListeners();
  }

  //PDF FILE GUARDADO - DESLINDE 
   File? _pdfFile;

  File? get pdfFile => _pdfFile;

  void setPdfFile(File file) {
    _pdfFile = file;
    notifyListeners();
  }
  //FOTO y FIRMA RUNNER 
   Uint8List? _userPhotoBytes;
  Uint8List? _signatureImage;

  Uint8List? get userPhotoBytes => _userPhotoBytes;
  Uint8List? get signatureImage => _signatureImage;

  void setUserPhotoBytes(Uint8List bytes) {
    _userPhotoBytes = bytes;
    notifyListeners();
  }

  void setSignatureImage(Uint8List bytes) {
    _signatureImage = bytes;
    notifyListeners();
  }


  
  TRunnersModel? _runnerEncontrado;
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

//USUARIO LOGIN

  Future<void> cargarRunner() async {
    final id = await sharedPrefs.getID();
    final idEvento = await sharedPrefs.getIDEvento();
    final idDistancia = await sharedPrefs.getIDDistancia();
    final nombre = await sharedPrefs.getNombreRun();
    final apellidos = await sharedPrefs.getApellidos();
    final dorsal = await sharedPrefs.getDorsal();
    final pais = await sharedPrefs.getPais();
    final tallaDePolo = await sharedPrefs.getTallaPolo();
    final image = await sharedPrefs.getImageRun();
    final collectionId = await sharedPrefs.getCollectionID();

    _runnerEncontrado = TRunnersModel(
      id: id,
      idEvento: idEvento ?? '',
      idDistancia: idDistancia ?? '',
      nombre: nombre.toString(),
      apellidos: apellidos ?? '',
      dorsal: dorsal ?? '',
      pais: pais ?? '',
      telefono: '',
      estado: true,
      numeroDeDocumentos: 0,
      genero: '',
      tallaDePolo: tallaDePolo?? '',
      imagen: image,
      collectionId: collectionId,
    );

    notifyListeners();
  }

  // Obtener el usuario encontrado
  TRunnersModel? get usuarioEncontrado => _runnerEncontrado;

  void setusuarioLogin(TRunnersModel usuario) async {
    _runnerEncontrado = usuario;
    cargarRunner();
    notifyListeners();
  }

  // Método para limpiar el usuario encontrado
  void limpiarusuarioEncontrado() {
    _runnerEncontrado = null;
    notifyListeners();
  }

 




}
