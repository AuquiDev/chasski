
// import 'package:chaskis/models/model_runners_ar.dart';
import 'dart:convert';

import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:chasski/sqllite/bd%20created/db___create_data_base.dart';
// import 'package:chaskis/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBListCheckPoitns {
  
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   Future<void> insertarProductos(TListChekPoitnsModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'tlistcheckpointsar',
      {
       'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_evento': e.idEvento,
        'ubicacion': e.ubicacion,
        'nombre': e.nombre,
        'descripcion': e.descripcion,
        'elevacion': e.elevacion,
        'orden': e.orden,
        'hora_apertura': e.horaApertura.toIso8601String(),
        'hora_cierre': e.horaCierre.toIso8601String(),
        'estatus': e.estatus ? 1 : 0, // Convertir booleano a entero
         'items_list': e.itemsList != null ? jsonEncode(e.itemsList!.map((item) => item.toJson()).toList()) : null,
    'personal': e.personal != null ? jsonEncode(e.personal!.map((item) => item.toJson()).toList()) : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TListChekPoitnsModel>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> respponse = await db.query('tlistcheckpointsar');

    // print('Data from Database: $respponse');

    List<TListChekPoitnsModel> listData = List<TListChekPoitnsModel>.from(
        respponse.map((e) => convertirDatos(e)).toList());
    return listData;
  }

  Future<void> updateTable(TListChekPoitnsModel e, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

   await db.update(
      'tlistcheckpointsar',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_evento': e.idEvento,
        'ubicacion': e.ubicacion,
        'nombre': e.nombre,
        'descripcion': e.descripcion,
        'elevacion': e.elevacion,
        'orden': e.orden,
        'hora_apertura': e.horaApertura.toIso8601String(),
        'hora_cierre': e.horaCierre.toIso8601String(),
        'estatus': e.estatus ? 1 : 0, // Convertir booleano a entero
            'items_list': e.itemsList != null ? jsonEncode(e.itemsList!.map((item) => item.toJson()).toList()) : null,
    'personal': e.personal != null ? jsonEncode(e.personal!.map((item) => item.toJson()).toList()) : null,

      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }
//  'items_list': itemsList!.map((e) => e.toJson()).toList(),
//         'personal': personal!.map((e) => e.toJson()).toList(),
   Future<void> deleteTable(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tlistcheckpointsar', where: 'idsql = ?', whereArgs: [idsql]);
  }

 // Borrar todos los datos
  Future<void> clearDataBase() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tlistcheckpointsar');
    await _databaseTablesDB.initDataBase();
  }

}


//ES como un FROMJSON personalizado
//ANTES DE MOSTRAR LOS DATOS DEBEMOS OCNVERTIRLOS compatible con el modelos para hcer el get .
// Método para convertir los datos del mapa a un objeto TRunnersModel
  TListChekPoitnsModel convertirDatos(Map<String, dynamic> json) {
    return TListChekPoitnsModel(
      idsql: json['idsql'],
      id: json["id"],
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      created: DateTime.parse(json["created"]),
      updated: DateTime.parse(json["updated"]),
      idEvento: json["id_evento"],
      ubicacion: json["ubicacion"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      elevacion: json["elevacion"],
      orden: json["orden"],
      horaApertura: DateTime.parse(json["hora_apertura"]),
      horaCierre: DateTime.parse(json["hora_cierre"]),
      estatus: json["estatus"] == 1, // Convertir entero a booleano
       itemsList: json["items_list"] != null
        ? List<TProductosAppModel>.from(
            jsonDecode(json["items_list"]).map((x) => TProductosAppModel.fromJson(x)))
        : [],
    personal: json["personal"] != null
        ? List<TEmpleadoModel>.from(
            jsonDecode(json["personal"]).map((x) => TEmpleadoModel.fromJson(x)))
        : [],
    );
}