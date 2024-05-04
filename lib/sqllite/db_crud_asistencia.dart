
import 'package:chasski/models/model_t_asistencia.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:chasski/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBAsistencia {
  
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   Future<void> insertarProductos(TAsistenciaModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'tasistencias',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_empleados': e.idEmpleados,
        'id_trabajo': e.idTrabajo,
        'hora_entrada': e.horaEntrada.toIso8601String(),
        'hora_salida': e.horaSalida?.toIso8601String(),
        'nombre_personal': e.nombrePersonal,
        'actividad_rol': e.actividadRol,
        'detalles': e.detalles,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TAsistenciaModel>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> respponse = await db.query('tasistencias');

    // print('Data from Database: $respponse');

    List<TAsistenciaModel> listData = List<TAsistenciaModel>.from(
        respponse.map((e) => convertirDatos(e)).toList());
    return listData;
  }

  Future<void> updateTable(TAsistenciaModel e, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'tasistencias',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_empleados': e.idEmpleados,
        'id_trabajo': e.idTrabajo,
        'hora_entrada': e.horaEntrada.toIso8601String(),
        'hora_salida': e.horaSalida?.toIso8601String(),
        'nombre_personal': e.nombrePersonal,
        'actividad_rol': e.actividadRol,
        'detalles': e.detalles,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

  Future<void> deleteTable(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tasistencias', where: 'idsql = ?', whereArgs: [idsql]);
  }

  //Borrar  todos los datos
  Future<void> clearDataBase() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tasistencias');
    await _databaseTablesDB.initDataBase();
  }

}


//ES como un FROMJSON personalizado
//ANTES DE MOSTRAR LOS DATOS DEBEMOS OCNVERTIRLOS compatible con el modelos para hcer el get .
TAsistenciaModel convertirDatos(Map<String, dynamic> json) {
  return TAsistenciaModel(
    idsql: json['idsql'],
    id: json["id"],
    collectionId: json["collectionId"],
    collectionName: json["collectionName"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    idEmpleados: json["id_empleados"],
    idTrabajo: json["id_trabajo"],
    horaEntrada: parseDateTime(json["hora_entrada"]),
    horaSalida: parseDateTime(json["hora_salida"]),
    nombrePersonal: json["nombre_personal"],
    actividadRol: json["actividad_rol"],
    detalles: json["detalles"],
  );
}