

import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';

class TListChekPoitnsModel {
   int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String ubicacion;
    String nombre;
    String descripcion;
    String elevacion;
    int orden;
    DateTime horaApertura;
    DateTime horaCierre;
    bool estatus;
    // String? itemsList;
    // String? personal;
    List<TProductosAppModel>? itemsList;
    List<TEmpleadoModel>? personal;

    TListChekPoitnsModel({
        this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idEvento,
        required this.ubicacion,
        required this.nombre,
        required this.descripcion,
        required this.elevacion,
        required this.orden,
        required this.horaApertura,
        required this.horaCierre,
        required this.estatus,
        List<TProductosAppModel>? itemsList, // Cambia esto
    List<TEmpleadoModel>? personal, // Cambia esto
})  : itemsList = itemsList ?? [], // Inicializa con una lista vacía si es null
      personal = personal ?? []; // Inicializa con una lista vacía si es null

    factory TListChekPoitnsModel.fromJson(Map<String, dynamic> json) => TListChekPoitnsModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        ubicacion: json["ubicacion"],
        nombre: json["nombre"], 
        descripcion: json["descripcion"],
        elevacion: json["elevacion"],
        orden: json["orden"],
        horaApertura: parseDateTime(json["hora_apertura"]),
        horaCierre: parseDateTime(json["hora_cierre"]),
        estatus: json["estatus"],
         itemsList: json["items_list"] != null
         ? List<TProductosAppModel>.from(json["items_list"].map((x) => TProductosAppModel.fromJson(x)))
         : [],
         personal: json["personal"] != null
         ? List<TEmpleadoModel>.from(json["personal"].map((x) => TEmpleadoModel.fromJson(x)))
         : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "id_evento": idEvento,
        "ubicacion": ubicacion,
        "nombre": nombre,
        "descripcion": descripcion,
        "elevacion": elevacion,
        "orden": orden,
        "hora_apertura": horaApertura.toIso8601String(),
          "hora_cierre": horaCierre.toIso8601String(),
        "estatus": estatus,
        'items_list': itemsList!.map((e) => e.toJson()).toList(),
        'personal': personal!.map((e) => e.toJson()).toList(),
  //       'items_list': itemsList != null ? itemsList!.map((e) => e.toJson()).toList() : [],
  // 'personal': personal != null ? personal!.map((e) => e.toJson()).toList() : [],
    };
}

TListChekPoitnsModel tListChekPoitnsModelDefault() {
  return TListChekPoitnsModel(
      idEvento: '',
      ubicacion: '',
      nombre: 'N/A',
      descripcion: 'N/A',
      elevacion: 'N/A',
      orden: 0,
      horaApertura: parseDateTime(''),
      horaCierre: parseDateTime(''),
      estatus: false,
      itemsList: [],
      personal: []
  );
}
