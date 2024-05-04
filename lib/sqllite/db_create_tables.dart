// database_helper.dart

import 'package:sqflite/sqflite.dart';

class DatabaseTablesDB {
  static Future<void> createTables(Database db) async {
    List<String> queries = [
      '''
      CREATE TABLE  tasistencias (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_empleados TEXT,
        id_trabajo TEXT,
        hora_entrada TEXT,
        hora_salida TEXT,
        nombre_personal TEXT,
        actividad_rol TEXT,
        detalles TEXT
      );
      ''',
      '''
      CREATE TABLE tdetalletrabajo (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        codigo_grupo TEXT,
        id_restriccionAlimentos TEXT,
        id_cantidad_paxguia TEXT,
        id_itinerariodiasnoches TEXT,
        id_tipogasto TEXT,
        fecha_inicio TEXT,
        fecha_fin TEXT,
        descripcion TEXT,
        costo_asociados REAL
      );
      ''',
      '''
      CREATE TABLE templeados (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        estado INTEGER,
        
        nombre TEXT,
        apellido_paterno TEXT,
        apellido_materno TEXT,
        sexo TEXT,
       
        cedula INTEGER,
        
        imagen TEXT,
        telefono TEXT,
        contrasena TEXT,
        rol TEXT
      );
      ''',
      '''
      CREATE TABLE tpersonal (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        nombre TEXT,
        rol TEXT,
        image TEXT
      );
    ''',
      '''
      CREATE TABLE trunners (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_evento TEXT,
        id_distancia TEXT,
        nombre TEXT,
        apellidos TEXT,
        dorsal TEXT,
        pais TEXT,
        telefono TEXT,
        estado INTEGER,
        genero TEXT,
        numeroDeDocumentos INTEGER,
        tallaDePolo TEXT
      );
    ''',
      '''
      CREATE TABLE tlistcheckpointsar (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_evento TEXT,
        ubicacion TEXT,
        nombre TEXT,
        descripcion TEXT,
        elevacion TEXT,
        orden INTEGER,
        hora_apertura TEXT,
        hora_cierre TEXT,
        estatus INTEGER,
        items_list TEXT
      );
      ''',
      '''
      CREATE TABLE check_points00 (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_corredor TEXT,
        id_check_points TEXT,
        fecha TEXT,
        estado INTEGER,
        nombre TEXT,
        dorsal TEXT
      );
    ''',
      '''
      CREATE TABLE check_points01 (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        id_corredor TEXT,
        id_check_points TEXT,
        fecha TEXT,
        estado INTEGER,
        nombre TEXT,
        dorsal TEXT
      );
    '''
    ];

    for (String query in queries) {
      await db.execute(query);
    }
  }
}
