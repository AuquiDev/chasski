
import 'package:chasski/models/check%20list/model_check_list_1.dart';
import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:flutter/material.dart';
//todos ESTE PROVIDER SE USA PARA SCANER QR. es un metodo en el cual se hacen pvarios pasao para guardar o editar un registro
class RunnerQrScanState with ChangeNotifier {
  // List<File>? _images;

  // List<File>? get images => _images;

  // void setImagesPetenencias(List<File> file) {
  //   print('FILE IMAGES : $file');
  //   _images = file;
  //   notifyListeners();
  // }

  //*******************************CHECK POINTS  ******************************/ 
 
  TCheckPointsModel _personScaner = tCheckPointsModelDefault();

 
  TCheckPointsModel get personScaner => _personScaner;

 
  void setScanerSaveCheckPoint(TCheckPointsModel scaner) {
    _personScaner = scaner;
    notifyListeners();
  }

  //*******************************CHECK LIST  ******************************/ 
 TChekListmodel01 _personScanerCheckList = tchekListmodel01Default();

 
 TChekListmodel01 get personScanerCheckList => _personScanerCheckList;

 
  void setScanerSaveCheckList(TChekListmodel01 scaner) {
    _personScanerCheckList = scaner;
    notifyListeners();
  }

  //*******************************CHECK LIST FILE  ******************************/ 
 
 TChekListmodel02File _personScanerCheckListFile = chekListDocDefault();

 
 TChekListmodel02File get personScanerCheckListFile => _personScanerCheckListFile;

 
  void setScanerSaveCheckListFile(TChekListmodel02File scaner) {
    _personScanerCheckListFile = scaner;
    notifyListeners();
  }



  //*****************************GENERALRUNNER FIELD  ******************************/ 
  ParticipantesModel _isRunner = participantesModelDefault();
  ParticipantesModel get isRunner => _isRunner;
  void setRunner(ParticipantesModel runner) {
    _isRunner = runner;
    notifyListeners();
  }

   // Función para buscar un participante por su ID
  void buscarRunnerIdScaneado({ required String idScanerQr,
  required List<ParticipantesModel> listData}) {
   final runnerEncontrado =  listData.firstWhere(
      (runner) => runner.id == idScanerQr,
      orElse: () => participantesModelDefault(),
    );
    setRunner(runnerEncontrado);
    toBeDorsal(runnerEncontrado);
    toBeNombre(runnerEncontrado);
    notifyListeners();
  }

  String dorsal = '';
  // Función para obtener el dorsal del participante o 'N/A' si no está disponible
  void toBeDorsal(ParticipantesModel e) {
    String valueDorsal = (e.dorsal.toString().isEmpty ||
            e.dorsal == null ||
            e.dorsal == '')
        ? 'N/A'
        : e.dorsal.toString();
  
    dorsal = valueDorsal;
    _isRunner.dorsal = valueDorsal; // Asignar valor a _isRunner
    notifyListeners(); 
  }
  
  String nombre= '';
  // Función para obtener el nombre del participante o usar el título si no está disponible
  void toBeNombre(ParticipantesModel e) {
    String valueNombre = (e.nombre.toString().isEmpty ||
            e.nombre == null ||
            e.nombre == '')
        ? e.title
        : e.nombre;
    nombre = valueNombre;
    _isRunner.nombre = valueNombre; // Asignar valor a _isRunner
    notifyListeners(); 
    
  }

 
}
