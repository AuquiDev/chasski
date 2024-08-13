class TEmpleadoModel {
  int? idsql; //Se añade con fines de uso en sqllite
  String? id;
  String? collectionId;
  String? collectionName;
  DateTime? created;
  DateTime? updated;

  bool estado;
  String nombre;
  String apellidos;
  String cargo;
  String sexo;
  int cedula;
  String? imagen;
  String telefono;
  String contrasena;
  String rol;

  TEmpleadoModel({
    this.idsql,
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    required this.estado,
    required this.nombre,
    required this.apellidos,
    required this.cargo,
    required this.sexo,
    required this.cedula,
    this.imagen,
    required this.telefono,
    required this.contrasena,
    required this.rol,
  });

  factory TEmpleadoModel.fromJson(Map<String, dynamic> json) => TEmpleadoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        estado: json["estado"],
        nombre: json["nombre"],
        apellidos: json["apellidos"] ?? '',
        cargo: json["cargo"] ?? '',
        sexo: json["sexo"],
        cedula: json["cedula"],
        imagen: json["imagen"],
        telefono: json["telefono"],
        contrasena: json["contrasena"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "estado": estado,
        "nombre": nombre,
        "apellidos": apellidos,
        "cargo": cargo,
        "sexo": sexo,
        "cedula": cedula,
        // "imagen": imagen,
        "telefono": telefono,
        "contrasena": contrasena,
        "rol": rol,
      };
}

TEmpleadoModel tEmpleadoModelDefault() {
  return TEmpleadoModel(
    estado: false,
    nombre: "N/A",
    apellidos: "N/A",
    cargo: "N/A",
    sexo: "-",
    cedula: 0,
    imagen: null,
    telefono: "",
    contrasena: "",
    rol: "",
  );
}
