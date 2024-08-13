// database_helper.dart

import 'package:sqflite/sqflite.dart';

class DatabaseTablesDB {
  static Future<void> createTables(Database db) async {
    List<String> queries = [
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
        apellidos TEXT,
        cargo TEXT,
        sexo TEXT,
        cedula INTEGER,
        imagen TEXT,
        telefono TEXT,
        contrasena TEXT,
        rol TEXT
      );
      ''',
      '''
      CREATE TABLE participantes (
        idsql INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        collectionId TEXT,
        collectionName TEXT,
        created TEXT,
        updated TEXT,
        idsheety INTEGER,
        id_evento TEXT,
        id_distancia TEXT,
        estado INTEGER,
        imagen TEXT,
        dorsal TEXT,
        contrasena TEXT,
        date TEXT,
        key INTEGER,
        title TEXT,
        nombre TEXT,
        apellidos TEXT,
        distancias TEXT,
        pais TEXT,
        email TEXT,
        telefono TEXT,
        numeroDeWhatsapp TEXT,
        tallaDePolo TEXT,
        fechaDeNacimiento TEXT,
        documento TEXT,
        numeroDeDocumentos TEXT,
        team TEXT,
        genero TEXT,
        rangoDeEdad TEXT,
        grupoSanguineo TEXT,
        haSidoVacunadoContraElCovid19 TEXT,
        alergias TEXT,
        nombreCompleto TEXT,
        parentesco TEXT,
        telefonoPariente TEXT,
        carrerasPrevias TEXT,
        porQueCorresElAndesRace TEXT,
        deCuscoAPartida TEXT,
        deCuscoAOllantaytambo TEXT,
        comoSupisteDeAndesRace TEXT
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
        items_list TEXT, -- JSON string
        personal TEXT -- JSON string si también usas listas
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
    ''',
      '''
      CREATE TABLE check_points02 (
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
      CREATE TABLE check_points03 (
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
      CREATE TABLE check_points04 (
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
      CREATE TABLE check_points05 (
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
      CREATE TABLE check_points06 (
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
      CREATE TABLE check_points07 (
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
      CREATE TABLE check_points08 (
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
      CREATE TABLE check_points09 (
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
      CREATE TABLE check_points010 (
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
      CREATE TABLE check_points011 (
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
      CREATE TABLE check_points012 (
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
      CREATE TABLE check_points013 (
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
      CREATE TABLE check_points0Meta (
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
