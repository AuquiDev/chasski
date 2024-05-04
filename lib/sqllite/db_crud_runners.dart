
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
// import 'package:chaskis/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBRunners {
  
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   Future<void> insertarProductos(TRunnersModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'trunners',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_evento': e.idEvento,
        'id_distancia': e.idDistancia,
        'nombre': e.nombre,
        'apellidos': e.apellidos,
        'dorsal': e.dorsal,
        'pais': e.pais,
        'telefono': e.telefono,
        'estado': e.estado ? 1 : 0, // Convertir booleano a entero
        'genero': e.genero,
        'numeroDeDocumentos': e.numeroDeDocumentos,
        'tallaDePolo': e.tallaDePolo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TRunnersModel>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> respponse = await db.query('trunners');

    // print('Data from Database: $respponse');

    List<TRunnersModel> listData = List<TRunnersModel>.from(
        respponse.map((e) => convertirDatos(e)).toList());
    return listData;
  }

  Future<void> updateTable(TRunnersModel e, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

   await db.update(
      'trunners',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'id_evento': e.idEvento,
        'id_distancia': e.idDistancia,
        'nombre': e.nombre,
        'apellidos': e.apellidos,
        'dorsal': e.dorsal,
        'pais': e.pais,
        'telefono': e.telefono,
        'estado': e.estado ? 1 : 0, // Convertir booleano a entero
        'genero': e.genero,
        'numeroDeDocumentos': e.numeroDeDocumentos,
        'tallaDePolo': e.tallaDePolo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

   Future<void> deleteTable(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('trunners', where: 'idsql = ?', whereArgs: [idsql]);
  }

 // Borrar todos los datos
  Future<void> clearDataBase() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('trunners');
    await _databaseTablesDB.initDataBase();
  }

}


//ES como un FROMJSON personalizado
//ANTES DE MOSTRAR LOS DATOS DEBEMOS OCNVERTIRLOS compatible con el modelos para hcer el get .
// Método para convertir los datos del mapa a un objeto TRunnersModel
  TRunnersModel convertirDatos(Map<String, dynamic> json) {
    return TRunnersModel(
      idsql: json['idsql'],
      id: json["id"],
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      created: DateTime.parse(json["created"]),
      updated: DateTime.parse(json["updated"]),
      idEvento: json["id_evento"],
      idDistancia: json["id_distancia"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      dorsal: json["dorsal"],
      pais: json["pais"],
      telefono: json["telefono"],
      estado: json["estado"] == 1, // Convertir entero a booleano
      genero: json["genero"],
      numeroDeDocumentos: json["numeroDeDocumentos"],
      tallaDePolo: json["tallaDePolo"],
    );
}