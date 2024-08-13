

import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';
import 'package:chasski/utils/conversion/assets_format_parse_string_a_double.dart';

class TProductosAppModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;
    //
  
    List<String>? imagen;
    String nombreProducto;
    String idCategoria;
    String idUbicacion;
    String marcaProducto;
    String idProveedor;
    String unidMedida;
    double? precioUnd;
    String? descripcion;
    DateTime fechaVencimiento;
    bool estado;
    double? entrada;
    double? salida;
    double? stock;
    String? moneda;

    TProductosAppModel({
        this.idsql,
        required this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.idCategoria,
        required this.idUbicacion,
        required this.idProveedor,
         this.imagen,
        required this.nombreProducto,
        required this.marcaProducto,
        required this.unidMedida,
        required this.precioUnd,
        required this.fechaVencimiento,
        required this.estado,
        this.descripcion, 
         this.entrada, 
         this.salida,  
        this.stock,
        this.moneda
    });
      
    factory TProductosAppModel.fromJson(Map<String, dynamic> json) => TProductosAppModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: json["created"],
        updated: json["updated"],

        nombreProducto: json["nombreProducto"] ?? '',
        idCategoria: json["idCategoria"],
        idUbicacion: json["idUbicacion"],
        imagen: List<String>.from(json["imagen"] ?? []), // manejo de nulos
        marcaProducto: json["marcaProducto"],
        idProveedor: json["idProveedor"],
        unidMedida: json["unidMedida"],
        precioUnd: parseToDouble(json["precioUnd"]),
        descripcion: json["descripcion"],
        fechaVencimiento: parseDateTime(json["fechaVencimiento"]),
        estado: json["estado"] ,
        entrada: parseToDouble(json["entrada"]),
        salida: parseToDouble(json["salida"]),
        stock: parseToDouble(json["stock"]),
        moneda: json['moneda']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "nombreProducto": nombreProducto,
        "idCategoria": idCategoria, 
        "idUbicacion": idUbicacion,
        // "imagen": imagen,
        "marcaProducto": marcaProducto,
        "idProveedor": idProveedor,
        "unidMedida": unidMedida,
        "precioUnd": precioUnd,
        "descripcion": descripcion,
        "fechaVencimiento": fechaVencimiento.toIso8601String(),
        "estado": estado,
        "entrada": entrada,
        "salida": salida,
        "stock": stock,
        "moneda":moneda
    };
}
