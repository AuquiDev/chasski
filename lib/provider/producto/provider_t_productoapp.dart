// ignore_for_file: avoid_print

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:chasski/poketbase/producto/t_productos_app.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';

class TProductosAppProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'producto_bd';

  List<TProductosAppModel> listProductos = [];

  TProductosAppProvider() {
    print('$collection_name Inicializado');
    getProductosAPP();
    realtime();
  }

  //SET y GETTER
  List<TProductosAppModel> get e => listProductos;

  void addTProductos(TProductosAppModel e) {
    listProductos.add(e);
    notifyListeners();
  }

  void updateTProductos(TProductosAppModel e) {
    listProductos[listProductos.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTProductos(TProductosAppModel e) {
    listProductos.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  //__________________________
  getProductosAPP() async {
    List<RecordModel> response =
        await TProductosApp.getProductoApp(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TProductosAppModel productos = TProductosAppModel.fromJson(e.data);
      addTProductos(productos);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postProductosProvider(
      {required BuildContext context,
      String? id,
      String? nombreProducto,
      String? idCategoria,
      String? idUbicacion,
      String? marcaProducto,
      String? idProveedor,
      String? unidMedida,
      double? precioUnd,
      String? descripcion,
      DateTime? fechaVencimiento,
      bool? estado,
      double? entrada,
      double? salida,
      double? stock}) async {
    isSyncing = true;
    notifyListeners();
    try {
      TProductosAppModel data = TProductosAppModel(
        id: '',
        nombreProducto: nombreProducto!,
        idCategoria: idCategoria!,
        idUbicacion: idUbicacion!,
        marcaProducto: marcaProducto!,
        idProveedor: idProveedor!,
        // imagen: imagen,
        unidMedida: unidMedida!,
        precioUnd: precioUnd!,
        descripcion: descripcion!,
        fechaVencimiento: fechaVencimiento!,
        estado: estado!,
        entrada: entrada,
        salida: salida,
        stock: stock,
      );
      // Aplicar el timeout correctamente
      await TProductosApp.postProductosApp(
              data: data, collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      AssetAlertDialogPlatform.show(
          context: context, message: 'Error: $e', title: 'Error al Guardar');
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateProductosProvider(
      {required BuildContext context,
      String? id,
      String? nombreProducto,
      String? idCategoria,
      String? idUbicacion,
      String? marcaProducto,
      String? idProveedor,
      String? unidMedida,
      double? precioUnd,
      String? descripcion,
      DateTime? fechaVencimiento,
      bool? estado,
      double? entrada,
      double? salida,
      double? stock}) async {
    isSyncing = true;
    notifyListeners();
    try {
      TProductosAppModel data = TProductosAppModel(
        id: id!,
        nombreProducto: nombreProducto!,
        idCategoria: idCategoria!,
        idUbicacion: idUbicacion!,
        marcaProducto: marcaProducto!,
        idProveedor: idProveedor!,
        // imagen: imagen,
        unidMedida: unidMedida!,
        precioUnd: precioUnd!,
        descripcion: descripcion!,
        fechaVencimiento: fechaVencimiento!,
        estado: estado!,
        entrada: entrada,
        salida: salida,
        stock: stock,
      );
      await TProductosApp.putProductosApp(
              id: id, data: data, collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      AssetAlertDialogPlatform.show(
          context: context, message: 'Error: $e', title: 'Error al Modificar');
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  bool isDeleted = false;
  deleteTProductosApp(String id) async {
    isDeleted = true;
    notifyListeners();
    try {
      await TProductosApp.deleteProductosApp(
              id: id, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(
      {required TProductosAppModel e, required BuildContext context}) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      print('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      print('Error al guardar los datos: $e');
    }
    if (e.id.isEmpty) {
      await postProductosProvider(
        context: context,
        id: '',
        nombreProducto: e.nombreProducto,
        idCategoria: e.idCategoria,
        idUbicacion: e.idUbicacion,
        marcaProducto: e.marcaProducto,
        idProveedor: e.idProveedor,
        unidMedida: e.unidMedida,
        precioUnd: e.precioUnd,
        descripcion: e.descripcion,
        fechaVencimiento: e.fechaVencimiento,
        estado: e.estado,
        entrada: e.entrada,
        salida: e.salida,
        stock: e.stock,
      );
    } else {
      await updateProductosProvider(
        context: context,
        id: e.id,
        nombreProducto: e.nombreProducto,
        idCategoria: e.idCategoria,
        idUbicacion: e.idUbicacion,
        marcaProducto: e.marcaProducto,
        idProveedor: e.idProveedor,
        unidMedida: e.unidMedida,
        precioUnd: e.precioUnd,
        descripcion: e.descripcion,
        fechaVencimiento: e.fechaVencimiento,
        estado: e.estado,
        entrada: e.entrada,
        salida: e.salida,
        stock: e.stock,
      );
    }
  }

  Future<void> realtime() async {
    // RealtimeService response = await TProductosApp.realmTimePocket();
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
          addTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        case 'update':
         configureRecordData();
          updateTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        case 'delete':
         configureRecordData();
          deleteTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

    //TODOS CLASIFICACION DE DATOS
  Map<String, List<TProductosAppModel>> groupByDistance(
      {required List<TProductosAppModel> listParticipantes,
      required String filename}) {
    Map<String, List<TProductosAppModel>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estado);
          break;
        case 'idCategoria':
          value = getField(e.idCategoria);
          break;
         case 'marcaProducto':
          value = getField(e.marcaProducto);
          break;
         case 'idUbicacion':
          value = getField(e.idUbicacion);
          break;
        case 'fechaVencimiento':
          value = formatDateTimeForGrouping(e.fechaVencimiento);
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
  List<TProductosAppModel> _filteredData = [];
  String _searchText = '';

  List<TProductosAppModel> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TProductosAppModel> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombreProducto
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.idProveedor
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TProductosAppModel> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }
}
