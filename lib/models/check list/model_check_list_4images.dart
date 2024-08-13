

import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';

class TChekListmodel04Images {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idCorredor;
    String idCheckList;
    
    String fileUrl;
    DateTime fecha;
    bool estado;
    String detalles;
    String nombre;
    String dorsal;
    // String? file;
    // String? deslinde;
    List<String>? images;//Para Docuemntos 

    TChekListmodel04Images({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idCorredor,
        required this.idCheckList,

        required this.fileUrl,
        required this.fecha,
        required this.estado,
        required this.detalles,
        required this.nombre,
        required this.dorsal,

        // this.file,
        // this.deslinde,
        this.images
    });

    factory TChekListmodel04Images.fromJson(Map<String, dynamic> json) => TChekListmodel04Images(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idCorredor: json["id_corredor"],
        idCheckList: json["id_check_list"],
        
        // file: (json["file"]).toString() ?? '',
        // deslinde: json["deslinde"].toString() ?? '',images 
        fileUrl: json["file_url"],
        fecha: parseDateTime(json["fecha"]),
        estado: json["estado"],
        detalles: json["detalles"],
        nombre: json["nombre"],
        dorsal: json["dorsal"],
        // FILES punto 2 deslinde de responsabilidad
        // file: json["file"] != null ? json["file"].toString() : '',
        // deslinde: json["deslinde"] != null ? json["deslinde"].toString() : '',
        //IMAGES en pertenencia de corredor punto 4
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created(),
        // "updated": updated(),
        "id_corredor": idCorredor,
        "id_check_list": idCheckList,
        
        "file_url": fileUrl,
        "fecha": fecha.toIso8601String(),
        "estado": estado,
        "detalles": detalles,
        "nombre": nombre,
        "dorsal": dorsal,

        // "file": (file),
        // "deslinde": deslinde,
        "images": images != null ? List<dynamic>.from(images!.map((x) => x)) : null,
    };
}

TChekListmodel04Images chekListDocDefaultImages() {
    return TChekListmodel04Images(
        idCorredor: 'idCorredor', 
        idCheckList: 'idCheckList', 
        fileUrl: '', 
        fecha: DateTime.now(), 
        estado: true, 
        detalles: 'detalles', 
        nombre: 'nombre', 
        dorsal: 'dorsal', 
        // file: '', 
        // deslinde: '', 
        images: []
        );
  }