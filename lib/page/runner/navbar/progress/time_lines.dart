import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/provider/check%20point/online/provider__list_chkpoint.dart';
import 'package:chasski/page/runner/navbar/progress/home_progrees_runner.dart';
import 'package:chasski/models/vista%20runner/model_v_tabla_participantes.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/colors/assets_colors.dart';

import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class ProgreesLineTime {
  String puntoStar;
  DateTime fecha1;
  bool estado1;
  String time;
  String puntoEnd;
  DateTime fecha2;
  bool estado2;

  ProgreesLineTime({
    required this.puntoStar,
    required this.fecha1,
    required this.estado1,
    required this.time, //Intervalo de tiempo

    required this.puntoEnd,
    required this.fecha2,
    required this.estado2,
  });
}

class TimeRunner extends StatelessWidget {
  const TimeRunner({super.key, required this.filter});
  final VTablaPartipantesModel filter;

  @override
  Widget build(BuildContext context) {
    List<ProgreesLineTime> timeInterval = [
      ProgreesLineTime(
        puntoStar: filter.pointsPartida, //0
        fecha1: parseDateTime(filter.partidaTime),
        estado1: filter.partida,

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
    //TODOS anadir
    timeInterval.add(
      ProgreesLineTime(
        puntoStar: filter.pointsMeta,
        fecha1: parseDateTime(filter.metaTime),
        estado1: filter.meta,
        time: filter.tiempo13Meta,
        puntoEnd: filter.pointsMeta,
        fecha2: parseDateTime(filter.metaTime),
        estado2: filter.meta,
      ),
    );

    return Column(
      children: [
        filter.distancias == '100K'
            ? Column(
                children: [
                  H1Text(
                    text: 'TIEMPO ACUMULADO',
                    color: Colors.grey.shade500,
                  ),
                  H1Text(
                    text: filter.tiempoAcumulado.toString(),
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
              )
            : SizedBox(),
        Expanded(child: TimelineView(timeInterval: timeInterval)),
      ],
    );
  }
}

class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.timeInterval});
  final List<ProgreesLineTime> timeInterval;

  @override
  Widget build(BuildContext context) {
    // Contar el número de puntos de control completados
    int completedCountPoint = timeInterval.where((e) => e.estado1).length;
    int totalCountPoints = timeInterval.length;

    // Calcular el porcentaje de progreso
    double progressPercentagePoints =
        (totalCountPoints > 0 ? completedCountPoint / totalCountPoints : 0.0);
    return Stack(
      children: [
        ChelkListProgres(
          progressPercentage: progressPercentagePoints,
        ),
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100, top: 120),
          child: timeInterval.isEmpty
              ? Center(
                  child: H2Text(
                    text: 'No hay datos disponibles',
                    fontSize: 14,
                  ),
                )
              : FixedTimeline.tileBuilder(
                  builder: TimelineTileBuilder.connected(
                    indicatorPositionBuilder: (context, index) {
                      return .5;
                    },
                    connectionDirection: ConnectionDirection.after,
                    contentsAlign: ContentsAlign.alternating,
                    indicatorBuilder: (context, index) {
                      final e = timeInterval[index];
                      return Opacity(
                          opacity: e.estado1 ? 1 : .3,
                          child: _pointsIndictor(fecha1: e.fecha1));
                    },
                    connectorBuilder: (context, index, connectorType) {
                      return DashedLineConnector(
                        color: AppColors.primaryRed,
                      );
                    },
                    itemCount: timeInterval.length,
                    contentsBuilder: (context, index) {
                      final e = timeInterval[index];
                      TListChekPoitnsModel? puntoStar;

                      if (e.puntoStar.isNotEmpty) {
                        final listChl =
                            Provider.of<TListCheckPoitnsProvider>(context)
                                .listAsistencia;
                        puntoStar =
                            listChl.firstWhere((a) => a.id == e.puntoStar);
                      }

                      TListChekPoitnsModel? puntoEnd;

                      if (e.puntoEnd.isNotEmpty) {
                        final listChl =
                            Provider.of<TListCheckPoitnsProvider>(context)
                                .listAsistencia;
                        puntoEnd =
                            listChl.firstWhere((a) => a.id == e.puntoEnd);
                      }
                      e.puntoStar = puntoStar?.nombre ?? '';
                      e.puntoEnd = puntoEnd?.nombre ?? '';
                      return _cardLineTime(
                          puntoStar: e.puntoStar, time: e.time);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _cardLineTime({required String puntoStar, required String time}) {
    return AssetsDelayedDisplayYbasic(
      duration: 300,
      child: Container(
        decoration: decorationBox(color: Colors.white),
        constraints: BoxConstraints(maxWidth: 300, minWidth: 150),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          children: [
            P2Text(text: puntoStar, textAlign: TextAlign.center),
            SizedBox(height: 10),
            // H3Text(text: time),
            // P2Text(
            //   text: '(hh:mm:ss)',
            //   fontSize: 10,
            //   color: Colors.grey.shade700,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _pointsIndictor({required DateTime fecha1}) {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          P2Text(
            text: fecha1.year != 1998 ? formatFecha(fecha1) : 'N/R',
            fontSize: 12,
          ),
          H2Text(
            text: fecha1.year != 1998 ? formatFechaPDfhora(fecha1) : 'N/R',
          ),
          AppSvg().checkPSvg,
        ],
      ),
    );
  }
}
