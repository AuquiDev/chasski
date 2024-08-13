import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:chasski/poketbase/list%20check%20point/t_list_check_points_ar.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckPoitnsProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'ar_check_points';

  List<TListChekPoitnsModel> listAsistencia = [];

  TListCheckPoitnsProvider() {
    print('$collection_name Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TListChekPoitnsModel> get e => listAsistencia;

  void addAsistencia(TListChekPoitnsModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TListChekPoitnsModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TListChekPoitnsModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TListCheckPoitns_AR.getAsitenciaPk(
        collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TListChekPoitnsModel ubicaciones = TListChekPoitnsModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider(
      {String? id,
      String? idEvento,
      String? ubicacion,
      String? nombre,
      String? descripcion,
      String? elevacion,
      int? orden,
      DateTime? horaApertura,
      DateTime? horaCierre,
      bool? estatus,
      List<TEmpleadoModel>? personal,
      List<TProductosAppModel>? itemsList}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TListChekPoitnsModel data = TListChekPoitnsModel(
          id: '',
          idEvento: idEvento!,
          ubicacion: ubicacion!,
          nombre: nombre!,
          descripcion: descripcion!,
          elevacion: elevacion!,
          orden: orden!,
          horaApertura: horaApertura!,
          horaCierre: horaCierre!,
          estatus: estatus!,
          itemsList: itemsList!,
          personal: personal!);

      await TListCheckPoitns_AR.postAsistenciaPk(
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider(
      {String? id,
      String? idEvento,
      String? ubicacion,
      String? nombre,
      String? descripcion,
      String? elevacion,
      int? orden,
      DateTime? horaApertura,
      DateTime? horaCierre,
      bool? estatus,
      List<TEmpleadoModel>? personal,
      List<TProductosAppModel>? itemsList}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TListChekPoitnsModel data = TListChekPoitnsModel(
          id: id!,
          idEvento: idEvento!,
          ubicacion: ubicacion!,
          nombre: nombre!,
          descripcion: descripcion!,
          elevacion: elevacion!,
          orden: orden!,
          horaApertura: horaApertura!,
          horaCierre: horaCierre!,
          estatus: estatus!,
          itemsList: itemsList!,
          personal: personal!);

      await TListCheckPoitns_AR.putAsitneciaPk(
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
      await TListCheckPoitns_AR.deleteAsistentciaPk(
              id: id, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
      notifyListeners();
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TListChekPoitnsModel e) async {
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
        idEvento: e.idEvento,
        ubicacion: e.ubicacion,
        nombre: e.nombre,
        descripcion: e.descripcion,
        elevacion: e.elevacion,
        orden: e.orden,
        horaApertura: e.horaApertura,
        horaCierre: e.horaCierre,
        estatus: e.estatus,
        itemsList: e.itemsList,
        personal: e.personal,
      );
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idEvento: e.idEvento,
        ubicacion: e.ubicacion,
        nombre: e.nombre,
        descripcion: e.descripcion,
        elevacion: e.elevacion,
        orden: e.orden,
        horaApertura: e.horaApertura,
        horaCierre: e.horaCierre,
        estatus: e.estatus,
        itemsList: e.itemsList,
        personal: e.personal,
      );
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
          addAsistencia(TListChekPoitnsModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TListChekPoitnsModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TListChekPoitnsModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

 
  //TODOS CLASIFICACION DE DATOS
  Map<String, List<TListChekPoitnsModel>> groupByDistance(
      {required List<TListChekPoitnsModel> listParticipantes,
      required String filename}) {
    Map<String, List<TListChekPoitnsModel>> groupedData = {};
    String value; 
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estatus);
          break;
        case 'elevacion':
          value = getField(e.elevacion);
          break;
        case 'idEvento':
          value = getField(e.idEvento);
          break;
        case 'horaApertura':
           value = formatDateTimeForGrouping(e.horaApertura);
          break;
        case 'horaCierre':
          value = formatDateTimeForGrouping(e.horaCierre);
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
  List<TListChekPoitnsModel> _filteredData = [];
  String _searchText = '';

  List<TListChekPoitnsModel> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TListChekPoitnsModel> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombre
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.orden
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) || 
            e.elevacion
               .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) || 
            e.descripcion
             .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) || 
            e.ubicacion
             .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) 
         )
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TListChekPoitnsModel> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }
}
