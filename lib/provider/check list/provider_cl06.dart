// ignore_for_file: avoid_print


import 'package:chasski/models/check%20list/model_check_list_1.dart';
import 'package:chasski/poketbase/check%20list/t_checklist_global_service.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckList06Provider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';
    //IMPORTANTE 
  String collection_name = 'ar_chl_6_entrega_medallas';

 List<TChekListmodel01> listAsistencia = [];

  TCheckList06Provider() {
    print('$collection_name Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TChekListmodel01> get e => listAsistencia;

  void addAsistencia(TChekListmodel01 e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TChekListmodel01 e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TChekListmodel01 e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TCheckListGlobalService.getPk(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TChekListmodel01 ubicaciones =  TChekListmodel01.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal }) async {
    try {
      isSyncing = true;
      notifyListeners();
      TChekListmodel01 data = TChekListmodel01(
          id: '',
          idCorredor: idCorredor!,
          idCheckList: idCheckList!,
          fecha: fecha!,
          estado: estado!,
          nombre: nombre!,
          dorsal: dorsal!);

      await TCheckListGlobalService.postPk(
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal  }) async {
    try {
      isSyncing = true;
      notifyListeners();
      TChekListmodel01 data = TChekListmodel01(
          id: id!,
          idCorredor: idCorredor!,
          idCheckList: idCheckList!,
          fecha: fecha!,
          estado: estado!,
          nombre: nombre!,
          dorsal: dorsal!);

      await TCheckListGlobalService.putPK(
              id: id, data: data, collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name UPDATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  bool isDeleted = false;
  deleteTAsistenciaApp(String id) async {
    isDeleted = true;
    notifyListeners();
    try {
      await TCheckListGlobalService.deletePk(
              collectionName: collection_name, id: id)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TChekListmodel01 e) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      print('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      print('Error al guardar los datos: $e');
    }
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
          id: '',
          idCorredor: e.idCorredor,
          idCheckList: e.idCheckList,
          fecha: e.fecha,
          estado: e.estado,
          nombre: e.nombre,
          dorsal: e.dorsal);
    } else {
      await updateTAsistenciaProvider(
          id: e.id,
          idCorredor: e.idCorredor,
          idCheckList: e.idCheckList,
          fecha: e.fecha,
          estado: e.estado,
          nombre: e.nombre,
          dorsal: e.dorsal);
    }
  }

  Future<void> realtime() async {
    await pb.collection('$collection_name').subscribe('*', (e) {
      print('REALTIME $collection_name -> ${e.action}');
      void configureRecordData() {
        e.record!.data['id'] = e.record!.id;
        e.record!.data['created'] = DateTime.parse(e.record!.created);
        e.record!.data['updated'] = DateTime.parse(e.record!.updated);
        e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
        actionRealm = e.action;
        notifyListeners();
      }

      switch (e.action) {
        case 'create':
          configureRecordData();
          addAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

 
   //TODOS CLASIFICACION DE DATOS
  Map<String, List<TChekListmodel01>> groupByDistance(
      {required List<TChekListmodel01> listParticipantes,
      required String filename}) {
    Map<String, List<TChekListmodel01>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estado);
          break;
        case 'idCheckList':
          value = getField(e.idCheckList);
          break;
        case 'Hora marcación':
          value = formatDateTimeForGrouping(e.fecha);
          break;
        case 'updated':
          value = formatDateTimeForGrouping(e.updated!);
          break;
        case 'created':
          value = formatDateTimeForGrouping(e.created!);
          break;
        default:
          value = 'Todos';
      }
      if (!groupedData.containsKey(value)) {
        groupedData[value] = [];
      } 
      groupedData[value]?.add(e);
    } // Ordenar las claves y sus listas
    final sortedGroupedData = Map.fromEntries(groupedData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)) // Ordenar por claves
        );
    return sortedGroupedData;
  }

  //SEARCH FILE
  List<TChekListmodel01> _filteredData = [];
  String _searchText = '';

  List<TChekListmodel01> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TChekListmodel01> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombre
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.dorsal
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TChekListmodel01> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }
}
