
// import 'package:chaskis/models/model_runners_ar.dart';
import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
// import 'package:chaskis/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBListCheckPoitns {
  
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   Future<void> insertarProductos(TListCheckPoitns_ARModels e) async {
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
        'items_list': e.itemsList,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TListCheckPoitns_ARModels>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> respponse = await db.query('tlistcheckpointsar');

    // print('Data from Database: $respponse');

    List<TListCheckPoitns_ARModels> listData = List<TListCheckPoitns_ARModels>.from(
        respponse.map((e) => convertirDatos(e)).toList());
    return listData;
  }

  Future<void> updateTable(TListCheckPoitns_ARModels e, int? idsql) async {
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
        'items_list': e.itemsList,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

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
  TListCheckPoitns_ARModels convertirDatos(Map<String, dynamic> json) {
    return TListCheckPoitns_ARModels(
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
      itemsList: json["items_list"],
    );
}