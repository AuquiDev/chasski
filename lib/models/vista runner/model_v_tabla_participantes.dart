


import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';

class VTablaPartipantesModel {
    String? id;
    String? collectionId;
    String? collectionName;

    String idEvento;
    String idDistancia;
    String distancias;
     String dorsal;
    String nombre;
    String tiempoAcumulado;
    String tiempoTotal;
    String tiempoPartida1;
    String tiempo12;
    String tiempo23;
    String tiempo34;
    String tiempo45;
    String tiempo56;
    String tiempo67;
    String tiempo78;
    String tiempo89;
    String tiempo910;
    String tiempo1011;
    String tiempo1112;
    String tiempo1213;
    String tiempo13Meta;
    bool partida;
    DateTime partidaTime;
    String pointsPartida;
    bool punto1;
    DateTime punto1Time;
    String pointsPunto01;
    bool puntp2;
    DateTime punto2Time;
    String pointsPunto02;
    bool puntp3;
    DateTime punto3Time;
    String pointsPunto03;
    bool puntp4;
    DateTime punto4Time;
    String pointsPunto04;
    bool puntp5;
    DateTime punto5Time;
    String pointsPunto05;
    bool puntp6;
    DateTime punto6Time;
    String pointsPunto06;
    bool puntp7;
    DateTime punto7Time;
    String pointsPunto07;
    bool puntp8;
    DateTime punto8Time;
    String pointsPunto08;
    bool puntp9;
    DateTime punto9Time;
    String pointsPunto09;
    bool puntp10;
    DateTime punto10Time;
    String pointsPunto10;
    bool puntp11;
    DateTime punto11Time;
    String pointsPunto11;
    bool puntp12;
    DateTime punto12Time;
    String pointsPunto12;
    bool puntp13;
    DateTime punto13Time;
    String pointsPunto13;
    bool meta;
    DateTime metaTime;
    String pointsMeta;
    //CHECL LIST 
     DateTime fechaInfo01;
    bool estadoInfo01;
    String idChecList01;

    DateTime fechaDoc02;
    bool estadoDoc02;
    String idChecList02;

    DateTime fechaKits03; 
    bool estadoKits03;
    String idChecList03;

    DateTime fechaEquipaje04;
    bool estadoEquipaje04;
    String idChecList04;

    DateTime fechaBuses05;
    bool estadoBuses05;
    String idChecList05;

    DateTime fechaMedallas06;
    bool estadoMedallas06;
    String idChecList06;

    DateTime fechaRopaFin07;
    bool estadoRopaFin07;
    String idChecList07;

    DateTime fechaDevoRopa08;
    bool estadoDevoRopa08;
    String idChecList08;

    VTablaPartipantesModel({
         this.id,
         this.collectionId,
         this.collectionName,
        
        required this.idEvento,
        required this.idDistancia,
        required this.distancias,
        required this.dorsal,
        required this.nombre,
        required this.tiempoAcumulado,
        required this.tiempoTotal,
        required this.tiempoPartida1,
        required this.tiempo12,
        required this.tiempo23,
        required this.tiempo34,
        required this.tiempo45,
        required this.tiempo56,
        required this.tiempo67,
        required this.tiempo78,
        required this.tiempo89,
        required this.tiempo910,
        required this.tiempo1011,
        required this.tiempo1112,
        required this.tiempo1213,
        required this.tiempo13Meta,
        required this.partida,
        required this.partidaTime,
        required this.pointsPartida,
        required this.punto1,
        required this.punto1Time,
        required this.pointsPunto01,
        required this.puntp2,
        required this.punto2Time,
        required this.pointsPunto02,
        required this.puntp3,
        required this.punto3Time,
        required this.pointsPunto03,
        required this.puntp4,
        required this.punto4Time,
        required this.pointsPunto04,
        required this.puntp5,
        required this.punto5Time,
        required this.pointsPunto05,
        required this.puntp6,
        required this.punto6Time,
        required this.pointsPunto06,
        required this.puntp7,
        required this.punto7Time,
        required this.pointsPunto07,
        required this.puntp8,
        required this.punto8Time,
        required this.pointsPunto08,
        required this.puntp9,
        required this.punto9Time,
        required this.pointsPunto09,
        required this.puntp10,
        required this.punto10Time,
        required this.pointsPunto10,
        required this.puntp11,
        required this.punto11Time,
        required this.pointsPunto11,
        required this.puntp12,
        required this.punto12Time,
        required this.pointsPunto12,
        required this.puntp13,
        required this.punto13Time,
        required this.pointsPunto13,
        required this.meta,
        required this.metaTime,
        required this.pointsMeta,
        //CHECKLIST 
        required this.fechaInfo01,
        required this.estadoInfo01,
        required this.idChecList01,
        required this.fechaDoc02,
        required this.estadoDoc02,
        required this.idChecList02,
        required this.fechaKits03,
        required this.estadoKits03,
        required this.idChecList03,
        required this.fechaEquipaje04,
        required this.estadoEquipaje04,
        required this.idChecList04,
        required this.fechaBuses05,
        required this.estadoBuses05,
        required this.idChecList05,
        required this.fechaMedallas06,
        required this.estadoMedallas06,
        required this.idChecList06,
        required this.fechaRopaFin07,
        required this.estadoRopaFin07,
        required this.idChecList07,
        required this.fechaDevoRopa08,
        required this.estadoDevoRopa08,
        required this.idChecList08,
    });

  get pais => null;
    // Setter para 'id'
      set setId(String value) {
        id = value;
      }
      // set setCreated(String value) {
      //    updated = value;
      // }

      // set setUpdated(String value) {
      //   updated = value;
      // }
      set setCollectionId(String value) {
        collectionId = value;
      }

      set setCollectionName(String value) {
        collectionName = value;
      }
    factory VTablaPartipantesModel.fromJson(Map<String, dynamic> json) => VTablaPartipantesModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        idEvento: json["id_evento"],
        idDistancia: json["id_distancia"],
        distancias: json["distancias"],
        dorsal: json["dorsal"],
        nombre: json["nombre"],
        tiempoAcumulado: json["tiempo_acumulado"] ?? "N/A",
        tiempoTotal: json["tiempo_total"],
        tiempoPartida1: json["tiempo_partida_1"],
        tiempo12: json["tiempo_1_2"],
        tiempo23: json["tiempo_2_3"],
        tiempo34: json["tiempo_3_4"],
        tiempo45: json["tiempo_4_5"],
        tiempo56: json["tiempo_5_6"],
        tiempo67: json["tiempo_6_7"],
        tiempo78: json["tiempo_7_8"],
        tiempo89: json["tiempo_8_9"],
        tiempo910: json["tiempo_9_10"],
        tiempo1011: json["tiempo_10_11"],
        tiempo1112: json["tiempo_11_12"],
        tiempo1213: json["tiempo_12_13"],
        tiempo13Meta: json["tiempo_13_meta"],

        partida: json["partida"],
        partidaTime: parseDateTime(json["partida_time"]),
        pointsPartida: json["points_partida"],
        
        punto1: json["punto1"],
        punto1Time: parseDateTime(json["punto1_time"]),
        pointsPunto01: json["points_punto01"],

        puntp2: json["puntp2"],
        punto2Time: parseDateTime(json["punto2_time"]),
        pointsPunto02: json["points_punto02"],

        puntp3: json["puntp3"],
        punto3Time: parseDateTime(json["punto3_time"]),
        pointsPunto03: json["points_punto03"],

        puntp4: json["puntp4"],
        punto4Time: parseDateTime(json["punto4_time"]),
        pointsPunto04: json["points_punto04"],

        puntp5: json["puntp5"],
        punto5Time: parseDateTime(json["punto5_time"]),
        pointsPunto05: json["points_punto05"],

        puntp6: json["puntp6"],
        punto6Time: parseDateTime(json["punto6_time"]),
        pointsPunto06: json["points_punto06"],

        puntp7: json["puntp7"],
        punto7Time: parseDateTime(json["punto7_time"]),
        pointsPunto07: json["points_punto07"],

        puntp8: json["puntp8"],
        punto8Time: parseDateTime(json["punto8_time"]),
        pointsPunto08: json["points_punto08"],

        puntp9: json["puntp9"],
        punto9Time: parseDateTime(json["punto9_time"]),
        pointsPunto09: json["points_punto09"],

        puntp10: json["puntp10"],
        punto10Time: parseDateTime(json["punto10_time"]),
        pointsPunto10: json["points_punto10"],

        puntp11: json["puntp11"],
        punto11Time: parseDateTime(json["punto11_time"]),
        pointsPunto11: json["points_punto11"],

        puntp12: json["puntp12"],
        punto12Time: parseDateTime(json["punto12_time"]),
        pointsPunto12: json["points_punto12"],

        puntp13: json["puntp13"],
        punto13Time: parseDateTime(json["punto13_time"]),
        pointsPunto13: json["points_punto13"],
        
        meta: json["meta"],
        metaTime: parseDateTime(json["meta_time"]),
        pointsMeta: json["points_meta"],
        //CHCEKLIST 
        fechaInfo01: parseDateTime(json["fecha_info_01"]),
        estadoInfo01: json["estado_info_01"],
        idChecList01: json["idChecList01"],
        fechaDoc02: parseDateTime(json["fecha_doc_02"]),
        estadoDoc02: json["estado_doc_02"],
        idChecList02: json["idChecList02"],
        fechaKits03: parseDateTime(json["fecha_kits_03"]),
        estadoKits03: json["estado_kits_03"],
        idChecList03: json["idChecList03"],
        fechaEquipaje04: parseDateTime(json["fecha_equipaje_04"]),
        estadoEquipaje04: json["estado_equipaje_04"],
        idChecList04: json["idChecList04"],
        fechaBuses05: parseDateTime(json["fecha_buses_05"]),
        estadoBuses05: json["estado_buses_05"],
        idChecList05: json["idChecList05"],
        fechaMedallas06: parseDateTime(json["fecha_medallas_06"]),
        estadoMedallas06: json["estado_medallas_06"],
        idChecList06: json["idChecList06"],
        fechaRopaFin07: parseDateTime(json["fecha_ropaFin_07"]),
        estadoRopaFin07: json["estado_ropaFin_07"],
        idChecList07: json["idChecList07"],
        fechaDevoRopa08: parseDateTime(json["fecha_devo_ropa_08"]),
        estadoDevoRopa08: json["estado_devo_ropa_08"],
        idChecList08: json["idChecList08"],
    );

   

    
}

 VTablaPartipantesModel vistaParticipantesDefault() {
  return VTablaPartipantesModel(
    id: null,
    idEvento: '',
    idDistancia: '',
    distancias: '',
    dorsal: '',
    nombre: '',
    tiempoAcumulado: '',
    tiempoTotal: '',
    tiempoPartida1: '',
    tiempo12: '',
    tiempo23: '',
    tiempo34: '',
    tiempo45: '',
    tiempo56: '',
    tiempo67: '',
    tiempo78: '',
    tiempo89: '',
    tiempo910: '',
    tiempo1011: '',
    tiempo1112: '',
    tiempo1213: '',
    tiempo13Meta: '',
    partida: false,
    partidaTime: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPartida: '',
    punto1: false,
    punto1Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto01: '',
    puntp2: false,
    punto2Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto02: '',
    puntp3: false,
    punto3Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto03: '',
    puntp4: false,
    punto4Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto04: '',
    puntp5: false,
    punto5Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto05: '',
    puntp6: false,
    punto6Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto06: '',
    puntp7: false,
    punto7Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto07: '',
    puntp8: false,
    punto8Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto08: '',
    puntp9: false,
    punto9Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto09: '',
    puntp10: false,
    punto10Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto10: '',
    puntp11: false,
    punto11Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto11: '',
    puntp12: false,
    punto12Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto12: '',
    puntp13: false,
    punto13Time: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsPunto13: '',
    meta: false,
    metaTime: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    pointsMeta: '',
    fechaInfo01: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoInfo01: false,
    idChecList01: '',
    fechaDoc02: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoDoc02: false,
    idChecList02: '',
    fechaKits03: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoKits03: false,
    idChecList03: '',
    fechaEquipaje04: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoEquipaje04: false,
    idChecList04: '',
    fechaBuses05: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoBuses05: false,
    idChecList05: '',
    fechaMedallas06: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoMedallas06: false,
    idChecList06: '',
    fechaRopaFin07: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoRopaFin07: false,
    idChecList07: '',
    fechaDevoRopa08: DateTime.now(), // Puedes elegir un valor predeterminado apropiado
    estadoDevoRopa08: false,
    idChecList08: '',
  );
}
