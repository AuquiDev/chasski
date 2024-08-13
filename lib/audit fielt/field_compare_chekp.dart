
import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:chasski/utils/conversion/asset_format_porcentaje_progrees.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/conversion/assets_format_parse_string_a_double.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgreesCharWidgetAR extends StatelessWidget {
  const ProgreesCharWidgetAR({
    super.key,
    required this.listServer,
    required this.toBeOmited,
    required this.toBeUpdate,
    required this.toBeCreated,
    required this.toBeDeleted,
    required this.tolocalExist,
    required this.progreesLotes,
  });
  final List<TCheckPointsModel> listServer;
  final List<TCheckPointsModel> toBeOmited;
  final List<TCheckPointsModel> toBeUpdate;
  final List<TCheckPointsModel> toBeCreated;
  final List<TCheckPointsModel> toBeDeleted;
  final List<TCheckPointsModel> tolocalExist;
  final String progreesLotes;

  @override
  Widget build(BuildContext context) {
    // final sveProvider = Provider.of<TCheckP00Provider>(context);
    // final listServer = sveProvider.listAsistencia;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
      child: Opacity(
        opacity: .9,
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  //CONTAMOS CADA LISTA
                  int omitedCount = toBeOmited.length;
                  int creadoCount = toBeCreated.length;
                  int updatedCount = toBeUpdate.length;
                  int borrarCount = toBeDeleted.length;
                  int existSqlCount = tolocalExist.length;
                  //SUMAMOS EL TOTAL
                  int total = (omitedCount +
                      creadoCount +
                      updatedCount +
                      borrarCount +
                      existSqlCount);
                  print(
                      '$omitedCount  $creadoCount +  $updatedCount + $borrarCount +  $existSqlCount');
                  print('${listServer.length}');

                  double porcentlst(int lengt) {
                    return total > 0 ? lengt / total * 100 : 0;
                  }

                  double progress = total / listServer.length;
                  String percentage = formatPercentage(progress);
                  //PORCENTJE
                  String porcentajeOmitidos =
                      porcentlst(omitedCount).toStringAsFixed(2);
                  String porcentajeCreados =
                      porcentlst(creadoCount).toStringAsFixed(2);
                  String porcentajeActualizados =
                      porcentlst(updatedCount).toStringAsFixed(2);
                  String porcentajeBorrados =
                      porcentlst(borrarCount).toStringAsFixed(2);
                  String porcentajeExistSql =
                      porcentlst(existSqlCount).toStringAsFixed(2);

                  List<ChartData> chartData = [
                    ChartData('Omit.', parseToDouble(omitedCount), Colors.red),
                    ChartData('Cre.', parseToDouble(creadoCount).toDouble(),
                        Colors.green),
                    ChartData('Modif.', parseToDouble(updatedCount).toDouble(),
                        Colors.blue),
                    ChartData('Bor.', parseToDouble(borrarCount).toDouble(),
                        Colors.yellow),
                    ChartData('Ex.Local',
                        parseToDouble(existSqlCount).toDouble(), Colors.pink),
                  ];

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey.withOpacity(.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.indigo),
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Progress: $percentage%',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      P3Text(
                        text: progreesLotes,
                      ),
                      Container(
                        height: 170,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.action,
                              yValueMapper: (ChartData data, _) =>
                                  data.percentage,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Porcentaje de acciones:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildLegendItem(
                                'Omitidos', '$porcentajeOmitidos%', Colors.red),
                            buildLegendItem(
                                'Creados', '$porcentajeCreados%', Colors.green),
                            buildLegendItem('Actualizados',
                                '$porcentajeActualizados%', Colors.blue),
                            buildLegendItem('Borrados', '$porcentajeBorrados%',
                                Colors.yellow),
                            buildLegendItem('ExistSQL', '$porcentajeExistSql%',
                                Colors.pink),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Column contentDialog(
    {required BuildContext context,
    required TCheckPointsModel runnerSQL,
    required TCheckPointsModel runneServer,
    required int index,
    required String textBottonIsTrue,
    required String textBottonIsFalse}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            P3Text(text: 'Dato Local: ' + runnerSQL.idsql.toString()),
            CardTCheckPointsModel(e: runnerSQL, index: 1),
            if (index != -1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  P3Text(
                      text: runneServer.idsql == null
                          ? 'Dato Server'
                          : runneServer.idsql.toString()),
                  CardTCheckPointsModel(e: runneServer, index: 1),
                ],
              ),
          ],
        ),
      ),
      ButtonBar(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Eliminar
            child: P3Text(text: textBottonIsTrue),
          ),
          OutlinedButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Mantener locales
            child: P3Text(text: textBottonIsFalse),
          ),
        ],
      )
    ],
  );
}

class CardTCheckPointsModel extends StatelessWidget {
  const CardTCheckPointsModel({
    super.key,
    required this.e,
    required this.index,
  });

  final TCheckPointsModel e;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        radius: 9,
        backgroundColor: e.estado ? Colors.green.shade500 : Colors.red,
        child: FittedBox(
          child: P1Text(
            text: (index + 1).toString(),
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
      minLeadingWidth: 5,
      subtitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: AssetsDelayedDisplayX(
          duration: 100,
          fadingDuration: 250,
          child: DataTable(
            dataRowHeight: 35,
            headingRowHeight: 20,
            sortAscending: true,
            columnSpacing: 40,
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Dorsal')),
              DataColumn(label: Text('Hora de Marcación')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('idCorredor')),
              DataColumn(label: Text('idCheckPoints')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Container(
                  width: 50,
                  child: P3Text(
                    text: e.id!,
                    selectable: true,
                  ),
                )),
                DataCell(Container(
                  width: 110,
                  child: P3Text(
                    text: getField(e.nombre),
                    selectable: true,
                  ),
                )),
                DataCell(P2Text(
                    text: getField(e.dorsal),
                    color: e.dorsal.toString().isEmpty
                        ? Colors.red
                        : Colors.black)),
                DataCell(Text(formatFechaPDfhora(e.fecha))),
                DataCell(Text(getField(e.estado))),
                DataCell(
                  P3Text(
                    text: getField(e.idCorredor),
                    selectable: true,
                  ),
                ),
                DataCell(
                  P3Text(
                    text: getField(e.idCheckPoints),
                    selectable: true,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      trailing: e.id.toString().isEmpty
          ? CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red.shade100,
              child: FittedBox(child: P2Text(text: 'SQL')),
            )
          : null,
    );
  }
}

bool isComratedField({
  required TCheckPointsModel X,
  required TCheckPointsModel Y,
}) {
 
  // Convert both dates to UTC and ignore milliseconds/microseconds
  DateTime dateX = (X.fecha).toUtc();
  DateTime dateY = (Y.fecha).toUtc();

  // // Optionally, if you don't care about the millisecond/microsecond part
  dateX = DateTime(dateX.year, dateX.month, dateX.day, dateX.hour, dateX.minute, dateX.second);
  dateY = DateTime(dateY.year, dateY.month, dateY.day, dateY.hour, dateY.minute, dateY.second);
   print(' ${X.fecha} != ${Y.fecha}');
  bool isModifiServer = (
      //X.id != Y.id ||
      // X.dorsal.toString() != Y.dorsal.toString() ||
      // X.nombre.toString() != Y.nombre.toString() ||
      X.idCorredor.toString() != Y.idCorredor.toString() ||
      X.idCheckPoints.toString() != Y.idCheckPoints.toString() ||
      // X.fecha != Y.fecha ||
       dateX != dateY ||
      X.estado != Y.estado ||
      (X.dorsal.toString() != Y.dorsal.toString() && !(X.dorsal == '' && Y.dorsal == null)) ||
      (X.nombre.toString() != Y.nombre.toString() && !(X.nombre == '' && Y.nombre == null))
      );

  return isModifiServer;
}
