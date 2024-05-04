

// ignore_for_file: prefer_if_null_operators

import 'package:chasski/models/model_runners_ar.dart';
import 'package:flutter/material.dart';
// import 'package:chaskis/models/model_t_asistencia.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/utils/format_fecha.dart';

class ContentCargaDatosRunners extends StatelessWidget {
  const ContentCargaDatosRunners({
    super.key,
    required this.listsql,
    required this.index,
    required this.e,
    required this.text,
    required this.comlun1,
    required this.column2,
  });

  final List<TRunnersModel> listsql;
  final int index;
  final TRunnersModel e;
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
                TableCell(child: _text(listsql[index].nombre)),
                TableCell(child: _text(e.nombre)),
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
                TableCell(child: _text(listsql[index].dorsal)),
                TableCell(child: _text(e.dorsal)),
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
                    child: _text(formatFechaHoraNow(listsql[index].created!))),
                TableCell(
                    child: _text(formatFechaHoraNow(
                        e.created!.subtract(const Duration(hours: 5))))),
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
                  text: 'Detalles',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ))),
                TableCell(child: _text(listsql[index].genero)),
                TableCell(child: _text(e.genero)),
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
