import 'package:chasski/models/model_t_detalle_trabajo.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:chasski/utils/parse_fecha_nula.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBDetalleTrabajo {
  final DBLocalStorage _databaseTablesDB = DBLocalStorage.instance;

  //DETALLE DE TRABAJO: METODOS
  Future<void> insertarDetalleTrabajo(TDetalleTrabajoModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'tdetalletrabajo',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'codigo_grupo': e.codigoGrupo,
        'id_restriccionAlimentos': e.idRestriccionAlimentos,
        'id_cantidad_paxguia': e.idCantidadPaxguia,
        'id_itinerariodiasnoches': e.idItinerariodiasnoches,
        'id_tipogasto': e.idTipogasto,
        'fecha_inicio': e.fechaInicio.toIso8601String(),
        'fecha_fin': e.fechaFin.toIso8601String(),
        'descripcion': e.descripcion,
        'costo_asociados': e.costoAsociados,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TDetalleTrabajoModel>> getDetalleTrabajo() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> response = await db.query('tdetalletrabajo');

    List<TDetalleTrabajoModel> listData = List<TDetalleTrabajoModel>.from(
      response.map((e) => convertirDetalleTrabajo(e)).toList(),
    );
    return listData;
  }

  Future<void> updateDetalleTrabajo(
      TDetalleTrabajoModel detalle, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'tdetalletrabajo',
      {
        'id': detalle.id,
        'collectionId': detalle.collectionId,
        'collectionName': detalle.collectionName,
        'created': detalle.created?.toIso8601String(),
        'updated': detalle.updated?.toIso8601String(),
        'codigo_grupo': detalle.codigoGrupo,
        'id_restriccionAlimentos': detalle.idRestriccionAlimentos,
        'id_cantidad_paxguia': detalle.idCantidadPaxguia,
        'id_itinerariodiasnoches': detalle.idItinerariodiasnoches,
        'id_tipogasto': detalle.idTipogasto,
        'fecha_inicio': detalle.fechaInicio.toIso8601String(),
        'fecha_fin': detalle.fechaFin.toIso8601String(),
        'descripcion': detalle.descripcion,
        'costo_asociados': detalle.costoAsociados,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

  Future<void> deleteTdetalletrabajo(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tdetalletrabajo', where: 'idsql = ?', whereArgs: [idsql]);
  }

  //Borrar  todos los datos
  Future<void> clearDetalleTrabajo() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('tdetalletrabajo');
    await _databaseTablesDB.initDataBase();
  }
}

// Añadir una función para convertir datos de la tabla 'tdetalletrabajo'
TDetalleTrabajoModel convertirDetalleTrabajo(Map<String, dynamic> json) {
  return TDetalleTrabajoModel(
    idsql: json['idsql'],
    id: json["id"],
    collectionId: json["collectionId"],
    collectionName: json["collectionName"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    codigoGrupo: json["codigo_grupo"],
    idRestriccionAlimentos: json["id_restriccionAlimentos"],
    idCantidadPaxguia: json["id_cantidad_paxguia"],
    idItinerariodiasnoches: json["id_itinerariodiasnoches"],
    idTipogasto: json["id_tipogasto"],
    fechaInicio: parseDateTime(json["fecha_inicio"]),
    fechaFin: parseDateTime(json["fecha_fin"]),
    descripcion: json["descripcion"],
    costoAsociados: json["costo_asociados"],
  );
}
