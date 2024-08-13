import 'package:chasski/models/check%20list/model_list_check_list_ar.dart';
import 'package:chasski/provider/check%20list/provider__t_list_cheklist.dart';
import 'package:chasski/page/runner/navbar/progress/home_progrees_runner.dart';
import 'package:chasski/models/vista%20runner/model_v_tabla_participantes.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/conversion/assets_format_parse_fecha_nula.dart';
import 'package:chasski/utils/layuot/asset_table_custom.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckListControles extends StatelessWidget {
  const CheckListControles({super.key, required this.filter});
  final VTablaPartipantesModel filter;
  @override
  Widget build(BuildContext context) {
    List<ProgreesRunner> checkList = [
      ProgreesRunner(
          estatus: filter.estadoInfo01,
          fecha: parseDateTime(filter.fechaInfo01),
          punto: filter.idChecList01),
      ProgreesRunner(
          estatus: filter.estadoDoc02,
          fecha: parseDateTime(filter.fechaDoc02),
          punto: filter.idChecList02),
      ProgreesRunner(
          estatus: filter.estadoKits03,
          fecha: parseDateTime(filter.fechaKits03),
          punto: filter.idChecList03),
      ProgreesRunner(
          estatus: filter.estadoEquipaje04,
          fecha: parseDateTime(filter.fechaEquipaje04),
          punto: filter.idChecList04),
      ProgreesRunner(
          estatus: filter.estadoBuses05,
          fecha: parseDateTime(filter.fechaBuses05),
          punto: filter.idChecList05),
      ProgreesRunner(
          estatus: filter.estadoMedallas06,
          fecha: parseDateTime(filter.fechaMedallas06),
          punto: filter.idChecList06),
      ProgreesRunner(
          estatus: filter.estadoRopaFin07,
          fecha: parseDateTime(filter.fechaRopaFin07),
          punto: filter.idChecList07),
      ProgreesRunner(
          estatus: filter.estadoDevoRopa08,
          fecha: parseDateTime(filter.fechaDevoRopa08),
          punto: filter.idChecList08),
    ];
    // Contar el número de puntos de control completados
    int completedCountPoint = checkList.where((e) => e.estatus).length;
    int totalCountPoints = checkList.length;

    // Calcular el porcentaje de progreso
    double progressPercentagePoints =
        (totalCountPoints > 0 ? completedCountPoint / totalCountPoints : 0.0);
    return //si el evento esta inactivo o caabo solo para checkpoints
        DefaultTabController(
      length: checkList.length,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 110,
            child: FittedBox(
              child: Opacity(
                opacity: 0.1,
                child: ChelkListProgres(
                  progressPercentage: progressPercentagePoints,
                ),
              ),
            ),
          ),
          Column(
            children: [
              H1Text(
                text: 'Controles'.toUpperCase(),
                fontSize: 30,
                height: 1.3,
              ),
              H2Text(
                text: 'Antes y Después de la Carrera'.toUpperCase(),
              ),
              Expanded(
                child: CustomTable(
                  headers: ['Punto A', 'Tiempo\n(hh:mm:ss)'],
                  rows: List.generate(
                    checkList.length,
                    (index) {
                      final e = checkList[index];
                      TListChekListModel asistencia = checkListDefault();

                      if (e.punto.isNotEmpty) {
                        final listChl =
                            Provider.of<TListCheckListProvider>(context)
                                .listAsistencia;
                        asistencia = listChl.firstWhere((a) => a.id == e.punto);
                      }

                      return [
                        e.fecha.year == 1998
                            ? 'N/R'
                            : '${asistencia.nombre}\n' +
                                '${asistencia.ubicacion}\n\n' +
                                '${formatControlPointTimes(asistencia.horaApertura, asistencia.horaCierre)}',
                        e.fecha.year == 1998
                            ? 'N/R'
                            : '${formatFecha(e.fecha)}\n${formatFechaPDfhora(e.fecha)}'
                      ];
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
