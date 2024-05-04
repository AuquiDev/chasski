
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:sqflite/sqflite.dart';

class CrudDBEmpleado {
  final DBLocalStorage _databaseTablesDB =  DBLocalStorage.instance;

   //METODOS EMPLEADO
  Future<void> insertarEmpleado(TEmpleadoModel e) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.insert(
      'templeados',
      {
        'id': e.id,
        'collectionId': e.collectionId,
        'collectionName': e.collectionName,
        'created': e.created?.toIso8601String(),
        'updated': e.updated?.toIso8601String(),
        'estado': e.estado ? 1 : 0, // Convertir booleano a entero
        'nombre': e.nombre,
        'apellido_paterno': e.apellidoPaterno,
        'apellido_materno': e.apellidoMaterno,
        'sexo': e.sexo,
        'cedula': e.cedula.toInt(),
        'imagen': e.imagen,
        'telefono': e.telefono,
        'contrasena': e.contrasena,
        'rol': e.rol,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TEmpleadoModel>> getEmpleados() async {
    Database? db = await _databaseTablesDB.checkinDatabase();

    List<Map<String, dynamic>> response = await db.query('templeados');

    List<TEmpleadoModel> listData = List<TEmpleadoModel>.from(
      response.map((e) => convertirEmpleado(e)).toList(),
    );
    return listData;
  }

  Future<void> updateEmpleado(TEmpleadoModel empleado, int? idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();

    await db.update(
      'templeados',
      {
        'id': empleado.id,
        'collectionId': empleado.collectionId,
        'collectionName': empleado.collectionName,
        'created': empleado.created?.toIso8601String(),
        'updated': empleado.updated?.toIso8601String(),
        'estado': empleado.estado ? 1 : 0, // Convertir booleano a entero
        'nombre': empleado.nombre,
        'apellido_paterno': empleado.apellidoPaterno,
        'apellido_materno': empleado.apellidoMaterno,
        'sexo': empleado.sexo,
        'cedula': empleado.cedula.toInt(),
        'imagen': empleado.imagen,
        'telefono': empleado.telefono,
        'contrasena': empleado.contrasena,
        'rol': empleado.rol,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'idsql = ?',
      whereArgs: [idsql],
    );
  }

// Eliminar un empleado por su idsql
  Future<void> deleteEmpleado(int idsql) async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('templeados', where: 'idsql = ?', whereArgs: [idsql]);
  }

// Borrar todos los empleados
  Future<void> clearEmpleados() async {
    Database db = await _databaseTablesDB.checkinDatabase();
    await db.delete('templeados');
    await _databaseTablesDB.initDataBase();
  }
}




//EMPLEADO
TEmpleadoModel convertirEmpleado(Map<String, dynamic> json) {
  return TEmpleadoModel(
    idsql: json['idsql'],
    id: json['id'],
    collectionId: json['collectionId'],
    collectionName: json['collectionName'],
    created: DateTime.parse(json['created']),
    updated: DateTime.parse(json['updated']),
    estado: json['estado'] ==1,
    nombre: json['nombre'],
    apellidoPaterno: json['apellido_paterno'],
    apellidoMaterno: json['apellido_materno'],
    sexo: json['sexo'],
    cedula: json['cedula'].toInt(),
    imagen: json['imagen'],
    telefono: json['telefono'],
    contrasena: json['contrasena'],
    rol: json['rol'],
  );
}
