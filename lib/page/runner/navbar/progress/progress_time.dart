import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/page/runner/navbar/progress/time_lines.dart';
import 'package:chasski/provider/check%20point/online/provider__list_chkpoint.dart';
import 'package:chasski/models/vista%20runner/model_v_tabla_participantes.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';
import 'package:chasski/utils/layuot/asset_table_custom.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressTimePoint extends StatefulWidget {
  const ProgressTimePoint({super.key, required this.filter});
  final VTablaPartipantesModel filter;

  @override
  State<ProgressTimePoint> createState() => _ProgressTimePointState();
}

class _ProgressTimePointState extends State<ProgressTimePoint> {
  @override
  Widget build(BuildContext context) {
    final filter = widget.filter;
    List<ProgreesLineTime> timeInterval = [
      ProgreesLineTime(
        puntoStar: filter.pointsPartida, //0
        fecha1: parseDateTime(filter.partidaTime),
        estado1: filter.partida,
//TODOS no toene tiempo acumulado ya no ha ypunto de partida, eso complica si el evneto es de 13k p 60k
//solo ufncioanria en 100k 
        time: filter.tiempoPartida1,

        puntoEnd: filter.pointsPunto01,
        fecha2: parseDateTime(filter.punto1Time),
        estado2: filter.punto1,
      ), //1
      ProgreesLineTime(
        puntoStar: filter.pointsPunto01,
        fecha1: parseDateTime(filter.punto1Time),
        estado1: filter.punto1,
        time: filter.tiempo12,
        puntoEnd: filter.pointsPunto02,
        fecha2: parseDateTime(filter.punto2Time),
        estado2: filter.puntp2,
      ),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto02,
          fecha1: parseDateTime(filter.punto2Time),
          estado1: filter.puntp2,
          time: filter.tiempo23,
          puntoEnd: filter.pointsPunto03,
          fecha2: parseDateTime(filter.punto3Time),
          estado2: filter.puntp3),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto03,
          fecha1: parseDateTime(filter.punto3Time),
          estado1: filter.puntp3,
          time: filter.tiempo34,
          puntoEnd: filter.pointsPunto04,
          fecha2: parseDateTime(filter.punto4Time),
          estado2: filter.puntp4),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto04,
          fecha1: parseDateTime(filter.punto4Time),
          estado1: filter.puntp4,
          time: filter.tiempo45,
          puntoEnd: filter.pointsPunto05,
          fecha2: parseDateTime(filter.punto5Time),
          estado2: filter.puntp5),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto05,
          fecha1: parseDateTime(filter.punto5Time),
          estado1: filter.puntp5,
          time: filter.tiempo56,
          puntoEnd: filter.pointsPunto06,
          fecha2: parseDateTime(filter.punto6Time),
          estado2: filter.puntp6),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto06,
          fecha1: parseDateTime(filter.punto6Time),
          estado1: filter.puntp6,
          time: filter.tiempo67,
          puntoEnd: filter.pointsPunto07,
          fecha2: parseDateTime(filter.punto7Time),
          estado2: filter.puntp7),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto07,
          fecha1: parseDateTime(filter.punto7Time),
          estado1: filter.puntp7,
          time: filter.tiempo78,
          puntoEnd: filter.pointsPunto08,
          fecha2: parseDateTime(filter.punto8Time),
          estado2: filter.puntp8),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto08,
          fecha1: parseDateTime(filter.punto8Time),
          estado1: filter.puntp8,
          time: filter.tiempo89,
          puntoEnd: filter.pointsPunto09,
          fecha2: parseDateTime(filter.punto9Time),
          estado2: filter.puntp9),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto09,
          fecha1: parseDateTime(filter.punto9Time),
          estado1: filter.puntp9,
          time: filter.tiempo910,
          puntoEnd: filter.pointsPunto10,
          fecha2: parseDateTime(filter.punto10Time),
          estado2: filter.puntp10),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto10,
          fecha1: parseDateTime(filter.punto10Time),
          estado1: filter.puntp10,
          time: filter.tiempo1011,
          puntoEnd: filter.pointsPunto11,
          fecha2: parseDateTime(filter.punto11Time),
          estado2: filter.puntp11),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto11,
          fecha1: parseDateTime(filter.punto11Time),
          estado1: filter.puntp11,
          time: filter.tiempo1112,
          puntoEnd: filter.pointsPunto12,
          fecha2: parseDateTime(filter.punto12Time),
          estado2: filter.puntp12),
      ProgreesLineTime(
          puntoStar: filter.pointsPunto12,
          fecha1: parseDateTime(filter.punto12Time),
          estado1: filter.puntp12,
          time: filter.tiempo1213,
          puntoEnd: filter.pointsPunto13,
          fecha2: parseDateTime(filter.punto13Time),
          estado2: filter.puntp13),
      ProgreesLineTime(
        puntoStar: filter.pointsPunto13,
        fecha1: parseDateTime(filter.punto13Time),
        estado1: filter.puntp13,
        time: filter.tiempo13Meta,
        puntoEnd: filter.pointsMeta,
        fecha2: parseDateTime(filter.metaTime),
        estado2: filter.meta,
      ),
    ];

    return DefaultTabController(
      length: timeInterval.length,
      child: Column(
        children: [
         widget.filter.distancias == '100K' ?  Column(
            children: [
              H1Text(
                text: 'TIEMPO ACUMULADO',
                color: Colors.grey.shade500,
              ),
              H1Text(
                text: widget.filter.tiempoAcumulado.toString(),
                fontSize: 40,
                fontWeight: FontWeight.w900,
                height: .9,
              ),
              P1Text(
                text: '(hh:mm:ss)',
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ],
          ):  SizedBox(),
          Expanded(
            child: CustomTable(
              headers: ['Punto A', 'Tiempo\n(hh:mm:ss)', 'Punto B'],
              onRowTap: (index) {
                // final e = timeInterval[index];
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailsPage(e: e),
                //   ),
                // );
              },
              rows: List.generate(
                timeInterval.length,
                (index) {
                 
                  final e = timeInterval[index];
                  TListChekPoitnsModel? puntoStar;
      
                  if (e.puntoStar.isNotEmpty) {
                    final listChl = Provider.of<TListCheckPoitnsProvider>(context)
                        .listAsistencia; 
                    puntoStar = listChl.firstWhere((a) => a.id == e.puntoStar);
                  }
      
                  TListChekPoitnsModel? puntoEnd;
      
                  if (e.puntoEnd.isNotEmpty) {
                    final listChl = Provider.of<TListCheckPoitnsProvider>(context)
                        .listAsistencia;
                    puntoEnd = listChl.firstWhere((a) => a.id == e.puntoEnd);
                  }
                  e.puntoStar = puntoStar?.nombre ?? '';
                  e.puntoEnd = puntoEnd?.nombre ?? '';
                  return [
                   e.fecha1.year !=1998 ?  '${e.puntoStar}' +
                        '\n\n' +
                        '${formatFecha(e.fecha1)}\n${formatFechaPDfhora(e.fecha1)}' : 'N/R',
                    '${e.time}',
                    e.fecha2.year !=1998 ?  '${e.puntoEnd}' +
                        '\n\n' +
                        '${formatFecha(e.fecha2)}\n${formatFechaPDfhora(e.fecha2)}' : 'N/R',
                  ];
                },
              ),
              rowTextStyle: TextStyle(fontSize: 14, color: Colors.black),
              headerColor: Colors.blueGrey[200],
              rowBorderColor: Colors.blueGrey[200],
            ),
          ),
        ],
      ),
    );
  }
}

// class DetailsPage extends StatelessWidget {
//   const DetailsPage({
//     super.key,
//     required this.e,
//   });
//   final ProgreesLineTime e;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: H1Text(text: e.puntoEnd),
//       ),
//     );
//   }
// }
