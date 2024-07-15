

// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:chasski/models/model_t_asistencia.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/utils/format_fecha.dart';

class ContentCargaDatos extends StatelessWidget {
  const ContentCargaDatos({
    super.key,
    required this.listsql,
    required this.index,
    required this.e,
    required this.text,
    required this.comlun1,
    required this.column2,
  });

  final List<TAsistenciaModel> listsql;
  final int index;
  final TAsistenciaModel e;
  final String text;
  final String comlun1;
  final String column2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        H2Text(
          text: text,
          fontSize: 12,
          maxLines: 7,
        ),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: '',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(
                    child: Center(
                        child: H2Text(
                  text: comlun1,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(
                    child: Center(
                        child: H2Text(
                  text: column2,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Modificación',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(
                    child: _text(formatFechaHoraNow(listsql[index].updated!))),
                TableCell(
                    child: _text(formatFechaHoraNow(
                        e.updated!.subtract(const Duration(hours: 5))))),
              ],
            ),
            
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Nombre',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(child: _text(listsql[index].nombrePersonal)),
                TableCell(child: _text(e.nombrePersonal)),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Actividad/rol',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(child: _text(listsql[index].actividadRol)),
                TableCell(child: _text(e.actividadRol)),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Hora Entrada',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(
                    child: _text(formatFechaHoraNow(listsql[index].horaEntrada))),
                TableCell(
                    child: _text(formatFechaHoraNow(
                        e.horaEntrada.subtract(const Duration(hours: 5))))),
              ],
            ),
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Hora Salida',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(
                    child: _text(formatFechaHoraNow(listsql[index].horaSalida!))),
                TableCell(
                    child: _text(formatFechaHoraNow(
                        e.horaSalida!.subtract(const Duration(hours: 5))))),
              ],
            ),
            
            TableRow(
              children: [
                const TableCell(
                    child: Center(
                        child: H2Text(
                  text: 'Detalles',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(child: _text(listsql[index].detalles)),
                TableCell(child: _text(e.detalles)),
              ],
            ),
           
          ],
        ),
      ],
    );
  }

  Center _text(text) => Center(
          child: H2Text(
        text: text != null ? text : '',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        maxLines: 3,
        textAlign: TextAlign.center,
      ));
}
