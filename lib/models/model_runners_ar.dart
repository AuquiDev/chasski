
class TRunnersModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String idDistancia;
    String nombre;
    String apellidos;
    String dorsal;
    String pais;
    String telefono;
    bool estado;
    String genero;
    int numeroDeDocumentos;
    String tallaDePolo;

    TRunnersModel({
        this.idsql,
        this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idEvento,
        required this.idDistancia,
        required this.nombre,
        required this.apellidos,
        required this.dorsal,
        required this.pais,
        required this.telefono,
        required this.estado,
        required this.genero,
        required this.numeroDeDocumentos,
        required this.tallaDePolo,
    });

    factory TRunnersModel.fromJson(Map<String, dynamic> json) => TRunnersModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        idDistancia: json["id_distancia"],
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        dorsal: json["dorsal"],
        pais: json["pais"],
        telefono: json["telefono"],
        estado: json["estado"],
        genero: json["genero"],
        numeroDeDocumentos: json["numeroDeDocumentos"],
        tallaDePolo: json["tallaDePolo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "id_evento": idEvento,
        "id_distancia": idDistancia,
        "nombre": nombre,
        "apellidos": apellidos,
        "dorsal": dorsal,
        "pais": pais,
        "telefono": telefono,
        "estado": estado,
        "genero": genero,
        "numeroDeDocumentos": numeroDeDocumentos,
        "tallaDePolo": tallaDePolo,
    };
}
