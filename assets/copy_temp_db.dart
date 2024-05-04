// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:incidencias_op/models/model_t_detalle_trabajo.dart';
// import 'package:incidencias_op/models/model_t_empleado.dart';
// import 'package:incidencias_op/models/model_t_asistencia.dart';
// import 'package:incidencias_op/sqllite/db_create_tables.dart';
// import 'package:incidencias_op/utils/parse_fecha_nula.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DBAsistenciaApp {
//   Database? _database;

//   DBAsistenciaApp._();
//   static final DBAsistenciaApp instance = DBAsistenciaApp._();

//   Future<Database> checkinDatabase() async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       _database = await initDataBase();
//       return _database!;
//     }
//   }

//   Future<Database> initDataBase() async {
//     // Directory directory = await getApplicationCacheDirectory();//asociada con la memoria cache
//     Directory directory = await getApplicationDocumentsDirectory();//asociada con la memoria Docuemnto
//     String path = join(directory.path, 'DBIncident.db');

//     return await openDatabase(
//       path,
//       version: 2,
//       onOpen: (db) {},
//       onCreate: (Database db, int version) async {
//        print('Database path: $path');
//        await DatabaseTablesDB.createTables(db);
//       },
//     );
//   }

//   // Future<void> createTables(Database db) async {
//   //   List<String> queries = [
//   //     '''
//   //     CREATE TABLE  tasistencias (
//   //       idsql INTEGER PRIMARY KEY AUTOINCREMENT,
//   //       id TEXT,
//   //       collectionId TEXT,
//   //       collectionName TEXT,
//   //       created TEXT,
//   //       updated TEXT,
//   //       id_empleados TEXT,
//   //       id_trabajo TEXT,
//   //       hora_entrada TEXT,
//   //       hora_salida TEXT,
//   //       nombre_personal TEXT,
//   //       actividad_rol TEXT,
//   //       detalles TEXT
//   //     );
//   //     ''',
//   //     '''
//   //     CREATE TABLE tdetalletrabajo (
//   //       idsql INTEGER PRIMARY KEY AUTOINCREMENT,
//   //       id TEXT,
//   //       collectionId TEXT,
//   //       collectionName TEXT,
//   //       created TEXT,
//   //       updated TEXT,
//   //       codigo_grupo TEXT,
//   //       id_restriccionAlimentos TEXT,
//   //       id_cantidad_paxguia TEXT,
//   //       id_itinerariodiasnoches TEXT,
//   //       id_tipogasto TEXT,
//   //       fecha_inicio TEXT,
//   //       fecha_fin TEXT,
//   //       descripcion TEXT,
//   //       costo_asociados REAL
//   //     );
//   //     ''',
//   //     '''
//   //     CREATE TABLE templeados (
//   //       idsql INTEGER PRIMARY KEY AUTOINCREMENT,
//   //       id TEXT,
//   //       collectionId TEXT,
//   //       collectionName TEXT,
//   //       created TEXT,
//   //       updated TEXT,
//   //       estado INTEGER,
//   //       id_rolesSueldo_Empleados TEXT,
//   //       nombre TEXT,
//   //       apellido_paterno TEXT,
//   //       apellido_materno TEXT,
//   //       sexo TEXT,
//   //       direccion_residencia TEXT,
//   //       lugar_nacimiento TEXT,
//   //       fecha_nacimiento TEXT,
//   //       correo_electronico TEXT,
//   //       nivel_escolaridad TEXT,
//   //       estado_civil TEXT,
//   //       modalidad_laboral TEXT,
//   //       cedula INTEGER,
//   //       cuenta_bancaria TEXT,
//   //       imagen TEXT,
//   //       cv_document TEXT,
//   //       telefono TEXT,
//   //       contrasena TEXT,
//   //       rol TEXT
//   //     );
//   //     '''
//   //   ];

//   //   for (String query in queries) {
//   //     await db.execute(query);
//   //   }
//   // }

//   Future<void> insertarProductos(TAsistenciaModel e) async {
//     Database db = await checkinDatabase();

//     await db.insert(
//       'tasistencias',
//       {
//         'id': e.id,
//         'collectionId': e.collectionId,
//         'collectionName': e.collectionName,
//         'created': e.created?.toIso8601String(),
//         'updated': e.updated?.toIso8601String(),
//         'id_empleados': e.idEmpleados,
//         'id_trabajo': e.idTrabajo,
//         'hora_entrada': e.horaEntrada.toIso8601String(),
//         'hora_salida': e.horaSalida?.toIso8601String(),
//         'nombre_personal': e.nombrePersonal,
//         'actividad_rol': e.actividadRol,
//         'detalles': e.detalles,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<TAsistenciaModel>> getTable() async {
//     Database? db = await checkinDatabase();

//     List<Map<String, dynamic>> respponse = await db.query('tasistencias');

//     // print('Data from Database: $respponse');

//     List<TAsistenciaModel> listData = List<TAsistenciaModel>.from(
//         respponse.map((e) => convertirDatos(e)).toList());
//     return listData;
//   }

//   Future<void> updateTable(TAsistenciaModel e, int? idsql) async {
//     Database db = await checkinDatabase();

//     await db.update(
//       'tasistencias',
//       {
//         'id': e.id,
//         'collectionId': e.collectionId,
//         'collectionName': e.collectionName,
//         'created': e.created?.toIso8601String(),
//         'updated': e.updated?.toIso8601String(),
//         'id_empleados': e.idEmpleados,
//         'id_trabajo': e.idTrabajo,
//         'hora_entrada': e.horaEntrada.toIso8601String(),
//         'hora_salida': e.horaSalida?.toIso8601String(),
//         'nombre_personal': e.nombrePersonal,
//         'actividad_rol': e.actividadRol,
//         'detalles': e.detalles,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//       where: 'idsql = ?',
//       whereArgs: [idsql],
//     );
//   }

//   Future<void> deleteTable(int idsql) async {
//     Database db = await checkinDatabase();
//     await db.delete('tasistencias', where: 'idsql = ?', whereArgs: [idsql]);
//   }

//   //Borrar  todos los datos
//   Future<void> clearDataBase() async {
//     Database db = await checkinDatabase();
//     await db.delete('tasistencias');
//     await initDataBase();
//   }

//   //DETALLE DE TRABAJO: METODOS
//   Future<void> insertarDetalleTrabajo(TDetalleTrabajoModel e) async {
//     Database db = await checkinDatabase();

//     await db.insert(
//       'tdetalletrabajo',
//       {
//         'id': e.id,
//         'collectionId': e.collectionId,
//         'collectionName': e.collectionName,
//         'created': e.created?.toIso8601String(),
//         'updated': e.updated?.toIso8601String(),
//         'codigo_grupo': e.codigoGrupo,
//         'id_restriccionAlimentos': e.idRestriccionAlimentos,
//         'id_cantidad_paxguia': e.idCantidadPaxguia,
//         'id_itinerariodiasnoches': e.idItinerariodiasnoches,
//         'id_tipogasto': e.idTipogasto,
//         'fecha_inicio': e.fechaInicio.toIso8601String(),
//         'fecha_fin': e.fechaFin.toIso8601String(),
//         'descripcion': e.descripcion,
//         'costo_asociados': e.costoAsociados,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<TDetalleTrabajoModel>> getDetalleTrabajo() async {
//     Database? db = await checkinDatabase();

//     List<Map<String, dynamic>> response = await db.query('tdetalletrabajo');

//     List<TDetalleTrabajoModel> listData = List<TDetalleTrabajoModel>.from(
//       response.map((e) => convertirDetalleTrabajo(e)).toList(),
//     );
//     return listData;
//   }

//   Future<void> updateDetalleTrabajo(
//       TDetalleTrabajoModel detalle, int? idsql) async {
//     Database db = await checkinDatabase();

//     await db.update(
//       'tdetalletrabajo',
//       {
//         'id': detalle.id,
//         'collectionId': detalle.collectionId,
//         'collectionName': detalle.collectionName,
//         'created': detalle.created?.toIso8601String(),
//         'updated': detalle.updated?.toIso8601String(),
//         'codigo_grupo': detalle.codigoGrupo,
//         'id_restriccionAlimentos': detalle.idRestriccionAlimentos,
//         'id_cantidad_paxguia': detalle.idCantidadPaxguia,
//         'id_itinerariodiasnoches': detalle.idItinerariodiasnoches,
//         'id_tipogasto': detalle.idTipogasto,
//         'fecha_inicio': detalle.fechaInicio.toIso8601String(),
//         'fecha_fin': detalle.fechaFin.toIso8601String(),
//         'descripcion': detalle.descripcion,
//         'costo_asociados': detalle.costoAsociados,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//       where: 'idsql = ?',
//       whereArgs: [idsql],
//     );
//   }

//   Future<void> deleteTdetalletrabajo(int idsql) async {
//     Database db = await checkinDatabase();
//     await db.delete('tdetalletrabajo', where: 'idsql = ?', whereArgs: [idsql]);
//   }

//   //Borrar  todos los datos
//   Future<void> clearDetalleTrabajo() async {
//     Database db = await checkinDatabase();
//     await db.delete('tdetalletrabajo');
//     await initDataBase();
//   }

//   //METODOS EMPLEADO
//   Future<void> insertarEmpleado(TEmpleadoModel empleado) async {
//     Database db = await checkinDatabase();

//     await db.insert(
//       'templeados',
//       {
//         'id': empleado.id,
//         'collectionId': empleado.collectionId,
//         'collectionName': empleado.collectionName,
//         'created': empleado.created?.toIso8601String(),
//         'updated': empleado.updated?.toIso8601String(),
//         'estado': empleado.estado ? 1 : 0, // Convertir booleano a entero
//         'id_rolesSueldo_Empleados': empleado.idRolesSueldoEmpleados,
//         'nombre': empleado.nombre,
//         'apellido_paterno': empleado.apellidoPaterno,
//         'apellido_materno': empleado.apellidoMaterno,
//         'sexo': empleado.sexo,
//         'direccion_residencia': empleado.direccionResidencia,
//         'lugar_nacimiento': empleado.lugarNacimiento,
//         'fecha_nacimiento': empleado.fechaNacimiento?.toIso8601String(),
//         'correo_electronico': empleado.correoElectronico,
//         'nivel_escolaridad': empleado.nivelEscolaridad,
//         'estado_civil': empleado.estadoCivil,
//         'modalidad_laboral': empleado.modalidadLaboral,
//         'cedula': empleado.cedula.toInt(),
//         'cuenta_bancaria': empleado.cuentaBancaria,
//         'imagen': empleado.imagen,
//         'cv_document': empleado.cvDocument,
//         'telefono': empleado.telefono,
//         'contrasena': empleado.contrasena,
//         'rol': empleado.rol,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<TEmpleadoModel>> getEmpleados() async {
//     Database? db = await checkinDatabase();

//     List<Map<String, dynamic>> response = await db.query('templeados');

//     List<TEmpleadoModel> listData = List<TEmpleadoModel>.from(
//       response.map((e) => convertirEmpleado(e)).toList(),
//     );
//     return listData;
//   }

//   Future<void> updateEmpleado(TEmpleadoModel empleado, int? idsql) async {
//     Database db = await checkinDatabase();

//     await db.update(
//       'templeados',
//       {
//         'id': empleado.id,
//         'collectionId': empleado.collectionId,
//         'collectionName': empleado.collectionName,
//         'created': empleado.created?.toIso8601String(),
//         'updated': empleado.updated?.toIso8601String(),
//         'estado': empleado.estado ? 1 : 0, // Convertir booleano a entero
//         'id_rolesSueldo_Empleados': empleado.idRolesSueldoEmpleados,
//         'nombre': empleado.nombre,
//         'apellido_paterno': empleado.apellidoPaterno,
//         'apellido_materno': empleado.apellidoMaterno,
//         'sexo': empleado.sexo,
//         'direccion_residencia': empleado.direccionResidencia,
//         'lugar_nacimiento': empleado.lugarNacimiento,
//         'fecha_nacimiento': empleado.fechaNacimiento?.toIso8601String(),
//         'correo_electronico': empleado.correoElectronico,
//         'nivel_escolaridad': empleado.nivelEscolaridad,
//         'estado_civil': empleado.estadoCivil,
//         'modalidad_laboral': empleado.modalidadLaboral,
//         'cedula': empleado.cedula.toInt(),
//         'cuenta_bancaria': empleado.cuentaBancaria,
//         'imagen': empleado.imagen,
//         'cv_document': empleado.cvDocument,
//         'telefono': empleado.telefono,
//         'contrasena': empleado.contrasena,
//         'rol': empleado.rol,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//       where: 'idsql = ?',
//       whereArgs: [idsql],
//     );
//   }

// // Eliminar un empleado por su idsql
//   Future<void> deleteEmpleado(int idsql) async {
//     Database db = await checkinDatabase();
//     await db.delete('templeados', where: 'idsql = ?', whereArgs: [idsql]);
//   }

// // Borrar todos los empleados
//   Future<void> clearEmpleados() async {
//     Database db = await checkinDatabase();
//     await db.delete('templeados');
//     await initDataBase();
//   }
// }

// //ES como un FROMJSON personalizado
// //ANTES DE MOSTRAR LOS DATOS DEBEMOS OCNVERTIRLOS compatible con el modelos para hcer el get .
// TAsistenciaModel convertirDatos(Map<String, dynamic> json) {
//   return TAsistenciaModel(
//     idsql: json['idsql'],
//     id: json["id"],
//     collectionId: json["collectionId"],
//     collectionName: json["collectionName"],
//     created: DateTime.parse(json["created"]),
//     updated: DateTime.parse(json["updated"]),
//     idEmpleados: json["id_empleados"],
//     idTrabajo: json["id_trabajo"],
//     horaEntrada: parseDateTime(json["hora_entrada"]),
//     horaSalida: parseDateTime(json["hora_salida"]),
//     nombrePersonal: json["nombre_personal"],
//     actividadRol: json["actividad_rol"],
//     detalles: json["detalles"],
//   );
// }

// // Añadir una función para convertir datos de la tabla 'tdetalletrabajo'
// TDetalleTrabajoModel convertirDetalleTrabajo(Map<String, dynamic> json) {
//   return TDetalleTrabajoModel(
//     idsql: json['idsql'],
//     id: json["id"],
//     collectionId: json["collectionId"],
//     collectionName: json["collectionName"],
//     created: DateTime.parse(json["created"]),
//     updated: DateTime.parse(json["updated"]),
//     codigoGrupo: json["codigo_grupo"],
//     idRestriccionAlimentos: json["id_restriccionAlimentos"],
//     idCantidadPaxguia: json["id_cantidad_paxguia"],
//     idItinerariodiasnoches: json["id_itinerariodiasnoches"],
//     idTipogasto: json["id_tipogasto"],
//     fechaInicio: parseDateTime(json["fecha_inicio"]),
//     fechaFin: parseDateTime(json["fecha_fin"]),
//     descripcion: json["descripcion"],
//     costoAsociados: json["costo_asociados"],
//   );
// }

// //EMPLEADO
// TEmpleadoModel convertirEmpleado(Map<String, dynamic> json) {
//   return TEmpleadoModel(
//     idsql: json['idsql'],
//     id: json['id'],
//     collectionId: json['collectionId'],
//     collectionName: json['collectionName'],
//     created: DateTime.parse(json['created']),
//     updated: DateTime.parse(json['updated']),
//     estado: json['estado'] ==1,
//     idRolesSueldoEmpleados: json['id_rolesSueldo_Empleados'],
//     nombre: json['nombre'],
//     apellidoPaterno: json['apellido_paterno'],
//     apellidoMaterno: json['apellido_materno'],
//     sexo: json['sexo'],
//     direccionResidencia: json['direccion_residencia'],
//     lugarNacimiento: json['lugar_nacimiento'],
//     fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
//     correoElectronico: json['correo_electronico'],
//     nivelEscolaridad: json['nivel_escolaridad'],
//     estadoCivil: json['estado_civil'],
//     modalidadLaboral: json['modalidad_laboral'],
//     cedula: json['cedula'].toInt(),
//     cuentaBancaria: json['cuenta_bancaria'],
//     imagen: json['imagen'],
//     cvDocument: json['cv_document'],
//     telefono: json['telefono'],
//     contrasena: json['contrasena'],
//     rol: json['rol'],
//   );
// }
