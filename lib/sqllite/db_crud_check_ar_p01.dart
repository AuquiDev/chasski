// import 'package:chaskis/models/model_t_asistencia.dart';
import 'package:chasski/models/model_check_points.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:chasski/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBCheckPointsAR01 {
  final DBLocalStorage _databaseTablesDB = DBLocalStorage.instance;

  Future<void> insertarProductos(TCheckPointsModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'check_points01',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_corredor': e.idCorredor, 
        'id_check_points': e.idCheckPoints,
        'fecha': e.fecha.toIso8601String(),
        'estado': e.estado ? 1 : 0,
        'nombre': e.nombre, 
        'dorsal': e.dorsal,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TCheckPointsModel>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> respponse = await db.query('check_points01');

    // print('Data from Database: $respponse');

    List<TCheckPointsModel> listData = List<TCheckPointsModel>.from(
        respponse.map((e) => convertirDatos(e)).toList());
    return listData;
  }

  Future<void> updateTable(TCheckPointsModel e, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'check_points01',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_corredor': e.idCorredor,
        'id_check_points': e.idCheckPoints,
        'fecha': e.fecha.toIso8601String(),
        'estado': e.estado ? 1 : 0,
        'nombre': e.nombre,
        'dorsal': e.dorsal,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

  Future<void> deleteTable(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('check_points01', where: 'idsql = ?', whereArgs: [idsql]);
  }

  //Borrar  todos los datos
  Future<void> clearDataBase() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('check_points01');
    await _databaseTablesDB.initDataBase();
  }
}

//ES como un FROMJSON personalizado
//ANTES DE MOSTRAR LOS DATOS DEBEMOS OCNVERTIRLOS compatible con el modelos para hcer el get .
TCheckPointsModel convertirDatos(Map<String, dynamic> json) {
  return TCheckPointsModel(
    idsql: json['idsql'],
    id: json["id"],
    collectionId: json["collectionId"],
    collectionName: json["collectionName"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    idCorredor: json['id_corredor'],
    idCheckPoints: json['id_check_points'],
    fecha: parseDateTime(json['fecha']),
    estado: json['estado'] == 1,
    nombre: json['nombre'],
    dorsal: json['dorsal'],
  );
}
