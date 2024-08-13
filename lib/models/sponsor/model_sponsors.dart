
class TSponsosModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String title;
    String description;
    String link;
    String? image;
    bool estatus;

    TSponsosModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.title,
        required this.description,
        required this.link,
         this.image,
        required this.estatus,
    });

    factory TSponsosModel.fromJson(Map<String, dynamic> json) => TSponsosModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),

        title: json["title"],
        description: json["description"],
        link: json["link"],
        image: json["image"],
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,

        "title": title,
        "description": description,
        "link": link,
        // "image": image,
        "estatus": estatus,
    };
}

TSponsosModel tSponsosModelDefault(){
  return TSponsosModel(
    title: "Title",
    description: "description",
    link: "",
    image: "",
    estatus: false,
  );
}
