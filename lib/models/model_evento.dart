import 'package:chasski/utils/parse_fecha_nula.dart';

class TEventoModel {
  int? idsql; //Se añade con fines de uso en sqllite
  String? id;
  String? collectionId;
  String? collectionName;
  DateTime? created;
  DateTime? updated;

  String nombre;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool estatus;
  String? logo;
  String? logoSmall;

  String? proyectname;
  String? tokenSheety;
  String? hojaSheetname;

  TEventoModel({
    this.idsql,
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estatus,
    this.logo,
    this.logoSmall,

     this.proyectname,
     this.tokenSheety,
     this.hojaSheetname,
  });

  factory TEventoModel.fromJson(Map<String, dynamic> json) => TEventoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        nombre: json["nombre"],
        fechaInicio: parseDateTime(json["fecha_inicio"]),
        fechaFin: parseDateTime(json["fecha_fin"]),
        estatus: json["estatus"],
        logo: json["logo"],
        logoSmall: json["logo_small"],

        proyectname: json["proyectname"],
        tokenSheety: json["tokenSheety"],
        hojaSheetname: json["hojaSheetname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created.toIso8601String(),
        // "updated": updated.toIso8601String(),
        "nombre": nombre,
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_fin": fechaFin.toIso8601String(),
        "estatus": estatus,
        // "logo": logo,
        // "logo_small": logoSmall,

        "proyectname": proyectname,
        "tokenSheety": tokenSheety,
        "hojaSheetname": hojaSheetname,
      };
}


  TEventoModel eventdefault() {
    return TEventoModel(
          nombre: 'nombre',
          fechaInicio: DateTime.now(),
          fechaFin: DateTime.now(),
          estatus: true);
  }
