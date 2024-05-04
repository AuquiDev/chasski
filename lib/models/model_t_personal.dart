
class TPersonalModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String nombre;
    String rol;
    String? image;

    TPersonalModel({
        this.idsql,
        this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.nombre,
        required this.rol,
         this.image,
    });

    factory TPersonalModel.fromJson(Map<String, dynamic> json) => TPersonalModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),

        nombre: json["nombre"],
        rol: json["rol"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "nombre": nombre,
        "rol": rol,
        "image": image,
    };
}
