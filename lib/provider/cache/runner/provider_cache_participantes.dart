// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';

class CacheParticpantesProvider extends ChangeNotifier {
 // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

  ParticipantesModel? _runnerEncontrado;
  
//****************  CORREDOR LOGIN ****************  

  Future<void> cargarRunner() async {
    ParticipantesModel sharedParticipante = await sharedPrefs.getParticipante();
    _runnerEncontrado = sharedParticipante;
    notifyListeners();
  }

  // Obtener el usuario encontrado
  ParticipantesModel? get usuarioEncontrado => _runnerEncontrado;

   //**************** PDF FILE - CERTIF. MEDICO  **************** 
  File? _medicalCertificateFile;

  File? get medicalCertificateFile => _medicalCertificateFile;

  void setMedicalCertificateFile(File file) {
    print('FILE: $file');
    _medicalCertificateFile = file;
    notifyListeners();
  }

  //****************  PDF FILE GUARDADO - DESLINDE **************** 
  File? _pdfFile;

  File? get pdfFile => _pdfFile;

  void setPdfFile(File file) {
    _pdfFile = file;
    notifyListeners();
  }

  //****************  FOTO y FIRMA RUNNER **************** 
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
}
