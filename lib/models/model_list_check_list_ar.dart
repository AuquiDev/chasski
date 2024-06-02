
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/models/model_t_productos_app.dart';
import 'package:chasski/utils/parse_fecha_nula.dart';

class TListChekListModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String nombre;
    String descripcion;
    String ubicacion;
    int orden;
    DateTime horaApertura;
    DateTime horaCierre;
    bool estatus;
    List<TProductosAppModel>? itemsList;
    List<TEmpleadoModel>? personal;

    TListChekListModel({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idEvento,
        required this.nombre,
        required this.descripcion,
        required this.ubicacion,
        required this.orden,
        required this.horaApertura,
        required this.horaCierre,
        required this.estatus,
         this.itemsList,
        this.personal
    });

    factory TListChekListModel.fromJson(Map<String, dynamic> json) => TListChekListModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        ubicacion: json["ubicacion"],
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
        // "created": created(),
        // "updated": updated(),
        "id_evento": idEvento,
        "nombre": nombre,
        "descripcion": descripcion,
        "ubicacion": ubicacion,
        "orden": orden,
        "hora_apertura": horaApertura.toIso8601String(),
        "hora_cierre": horaCierre.toIso8601String(),
        "estatus": estatus,
       'items_list': itemsList!.map((e) => e.toJson()).toList(),
        'personal': personal!.map((e) => e.toJson()).toList(),
    };
}
