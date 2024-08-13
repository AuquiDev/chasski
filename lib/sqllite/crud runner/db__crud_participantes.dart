import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/sqllite/bd%20created/db___create_data_base.dart';
// import 'package:chasski/sqlliteCRUD/db_create_local_storage.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBParticipantes {
  
  final DBLocalStorage _databaseTablesDB = DBLocalStorage.instance;
  //GET 
  Future<List<ParticipantesModel>> getTable() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> response = await db.query('participantes');

    List<ParticipantesModel> listData = List<ParticipantesModel>.from(
        response.map((e) => convertirDatos(e)).toList());
    return listData;
  }
  //POST 
  Future<void> insertarParticipante(ParticipantesModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'participantes',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'idsheety': e.idsheety,
        'id_evento': e.idEvento,
        'id_distancia': e.idDistancia,
        'estado': e.estado == true ? 1 : 0, // Convertir booleano a entero
        'imagen': e.imagen,
        'dorsal': e.dorsal,
        'contrasena': e.contrasena,
        'date': e.date,
        'key': e.key,
        'title': e.title,
        'nombre': e.nombre,
        'apellidos': e.apellidos,
        'distancias': e.distancias,
        'pais': e.pais,
        'email': e.email,
        'telefono': e.telefono,
        'numeroDeWhatsapp': e.numeroDeWhatsapp,
        'tallaDePolo': e.tallaDePolo,
        'fechaDeNacimiento': e.fechaDeNacimiento,
        'documento': e.documento,
        'numeroDeDocumentos': e.numeroDeDocumentos,
        'team': e.team,
        'genero': e.genero,
        'rangoDeEdad': e.rangoDeEdad,
        'grupoSanguineo': e.grupoSanguineo,
        'haSidoVacunadoContraElCovid19': e.haSidoVacunadoContraElCovid19,
        'alergias': e.alergias,
        'nombreCompleto': e.nombreCompleto,
        'parentesco': e.parentesco,
        'telefonoPariente': e.telefonoPariente,
        'carrerasPrevias': e.carrerasPrevias,
        'porQueCorresElAndesRace': e.porQueCorresElAndesRace,
        'deCuscoAPartida': e.deCuscoAPartida,
        'deCuscoAOllantaytambo': e.deCuscoAOllantaytambo,
        'comoSupisteDeAndesRace': e.comoSupisteDeAndesRace,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
  //UPDATE 
  Future<void> updateTable(ParticipantesModel e, int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'participantes',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'idsheety': e.idsheety,
        'id_evento': e.idEvento,
        'id_distancia': e.idDistancia,
        'estado': e.estado == true ? 1 : 0, // Convertir booleano a entero
        'imagen': e.imagen,
        'dorsal': e.dorsal,
        'contrasena': e.contrasena,
        'date': e.date,
        'key': e.key,
        'title': e.title,
        'nombre': e.nombre,
        'apellidos': e.apellidos,
        'distancias': e.distancias,
        'pais': e.pais,
        'email': e.email,
        'telefono': e.telefono,
        'numeroDeWhatsapp': e.numeroDeWhatsapp,
        'tallaDePolo': e.tallaDePolo,
        'fechaDeNacimiento': e.fechaDeNacimiento,
        'documento': e.documento,
        'numeroDeDocumentos': e.numeroDeDocumentos,
        'team': e.team,
        'genero': e.genero,
        'rangoDeEdad': e.rangoDeEdad,
        'grupoSanguineo': e.grupoSanguineo,
        'haSidoVacunadoContraElCovid19': e.haSidoVacunadoContraElCovid19,
        'alergias': e.alergias,
        'nombreCompleto': e.nombreCompleto,
        'parentesco': e.parentesco,
        'telefonoPariente': e.telefonoPariente,
        'carrerasPrevias': e.carrerasPrevias,
        'porQueCorresElAndesRace': e.porQueCorresElAndesRace,
        'deCuscoAPartida': e.deCuscoAPartida,
        'deCuscoAOllantaytambo': e.deCuscoAOllantaytambo,
        'comoSupisteDeAndesRace': e.comoSupisteDeAndesRace,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }
  //DELETE 
  Future<void> deleteTable(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('participantes', where: 'idsql = ?', whereArgs: [idsql]);
  }

  //CLEAR ALL 
  Future<void> clearDataBase() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('participantes');
    await _databaseTablesDB.initDataBase();
  }

  
}

// Método para convertir los datos del mapa a un objeto ParticipantesModel
  ParticipantesModel convertirDatos(Map<String, dynamic> json) {
    return ParticipantesModel(
      idsql: json['idsql'],
      id: json['id'],
      collectionId: json['collectionId'],
      collectionName: json['collectionName'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      idsheety: json['idsheety'],
      idEvento: json['id_evento'],
      idDistancia: json['id_distancia'],
      estado: json['estado'] == 1, // Convertir entero a booleano
      imagen: json['imagen'],
      dorsal: json['dorsal'],
      contrasena: json['contrasena'],
      date: json['date'],
      key: json['key'],
      title: json['title'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      distancias: json['distancias'],
      pais: json['pais'],
      email: json['email'],
      telefono: json['telefono'],
      numeroDeWhatsapp: json['numeroDeWhatsapp'],
      tallaDePolo: json['tallaDePolo'],
      fechaDeNacimiento: json['fechaDeNacimiento'],
      documento: json['documento'],
      numeroDeDocumentos: json['numeroDeDocumentos'],
      team: json['team'],
      genero: json['genero'],
      rangoDeEdad: json['rangoDeEdad'],
      grupoSanguineo: json['grupoSanguineo'],
      haSidoVacunadoContraElCovid19: json['haSidoVacunadoContraElCovid19'],
      alergias: json['alergias'],
      nombreCompleto: json['nombreCompleto'],
      parentesco: json['parentesco'],
      telefonoPariente: json['telefonoPariente'],
      carrerasPrevias: json['carrerasPrevias'],
      porQueCorresElAndesRace: json['porQueCorresElAndesRace'],
      deCuscoAPartida: json['deCuscoAPartida'],
      deCuscoAOllantaytambo: json['deCuscoAOllantaytambo'],
      comoSupisteDeAndesRace: json['comoSupisteDeAndesRace'],
    );
  }