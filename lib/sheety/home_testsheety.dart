import 'package:chasski/sheety/model_participantes.dart';
import 'package:chasski/sheety/pokertbaseSinc/provider_t_participantes.dart';
import 'package:chasski/sheety/provider_sheety.dart';
import 'package:chasski/sheety/sheety_isempty_count.dart';
import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/widget/runner_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SheetyPageParticipantes extends StatefulWidget {
  const SheetyPageParticipantes({super.key});

  @override
  State<SheetyPageParticipantes> createState() =>
      _SheetyPageParticipantesState();
}

class _SheetyPageParticipantesState extends State<SheetyPageParticipantes> {
  String selectedField = 'title'; // Campo seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ParticipantesDataProvider>(context);
    List<ParticipantesModel> listSheet = dataProvider.listParticipantes;
    final dataEmty = countEmptyFields(listSheet, selectedField);

    final dataPoketbase = Provider.of<TParticipantesProvider>(context);
    List<ParticipantesModel> listPoketbase = dataPoketbase.listaRunner;
    final bool isSyn = dataPoketbase.isSyncing;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          H2Text(text: 'Análisis de Datos Vacíos'),
          P3Text(
              text:
                  'Seleccione un campo para verificar la presencia de datos vacíos o nulos.'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             
              ElevatedButton(
                  onPressed: isSyn
                      ? null
                      : () async {
                          await dataPoketbase.sincServer(listSheet: listSheet);
                        },
                  child: isSyn
                      ? CircularProgressIndicator()
                      : Text('Sinc Sheety to  Server')),
            ],
          ),
          H2Text(text: '${listPoketbase.length}'),
          Consumer<TParticipantesProvider>(
              builder: (context, dataPoketbase, child) {
            return Table(children: [
              TableRow(children: [
                P3Text(text: 'Total'),
                P3Text(text: 'toBeDeleted'),
                P3Text(text: 'toBeUpdated'),
                P3Text(text: 'toBeCreated'),
                P3Text(text: 'listSheet'),
              ]),
              TableRow(children: [
                H2Text(text: '${listPoketbase.length}'),
                H2Text(text: '${dataPoketbase.toBeDeleted.length}'),
                H2Text(text: '${dataPoketbase.toBeUpdate.length}'),
                H2Text(text: '${dataPoketbase.toBeCreated.length}'),
                H2Text(text: '${listSheet.length}'),
              ])
            ]);
          }),
          Consumer<TParticipantesProvider>(
            builder: (context, dataPoketbase, child) {
              double progress =
                  dataPoketbase.listaRunner.length / listSheet.length;
              // int percentage = (progress * 100).round();
              // String percentage = (progress * 100).toStringAsFixed(3);
              String percentage = _formatPercentage(progress);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Circular Progress Indicator with percentage
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // SizedBox(width: 10),
                    Text(
                      'Progress: $percentage%',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer<TParticipantesProvider>(
            builder: (context, dataPoketbase, child) {
              // Calcular porcentajes
              int datossinaccion = dataPoketbase.toBeDeleted.length;
              int datocreados = dataPoketbase.toBeCreated.length;
              int datoactualizados = dataPoketbase.toBeUpdate.length;

              int total = datossinaccion + datocreados + datoactualizados;

              double porcentajeEliminados = datossinaccion / total * 100;
              double porcentajeCreados = datocreados / total * 100;
              double porcentajeActualizados = datoactualizados / total * 100;

              // Datos para el gráfico
              List<_ChartData> chartData = [
                _ChartData('Omitidos', porcentajeEliminados, Colors.red),
                _ChartData('Creados', porcentajeCreados, Colors.green),
                _ChartData('Actualizados', porcentajeActualizados, Colors.blue),
              ];

              return Column(
                children: [
                  // Gráfico de tipo pie
                  Container(
                    height: 200, // Altura deseada
                    width: double.infinity, // Ancho deseado
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(), // Eje X para categorías
                      series: <CartesianSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (_ChartData data, _) => data.action,
                          yValueMapper: (_ChartData data, _) => data.percentage,
                          pointColorMapper: (_ChartData data, _) => data.color,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Porcentaje de acciones:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem('Eliminados', Colors.red),
                      _buildLegendItem('Creados', Colors.green),
                      _buildLegendItem('Actualizados', Colors.blue),
                    ],
                  ),
                ],
              );
            },
          ),
          Table(
            columnWidths: {
              0: FractionColumnWidth(.7),
              1: FractionColumnWidth(.3),
            },
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DropdownButton<String>(
                    value: selectedField,
                    items: fields.map((String field) {
                      return DropdownMenuItem<String>(
                        value: field,
                        child: Text(field),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedField = newValue!;
                      });
                    },
                  ),
                ),
                Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: P2Text(
                        text: dataEmty.toString(),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                        maxLines: 2,
                      ),
                    )),
              ])
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  dataPoketbase.toBeUpdate.length, //listPoketbase.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                final e = dataPoketbase.toBeUpdate[index];

                // isFieldEmpty(selectedField, e);

                // // Verifica si el campo seleccionado está vacío o nulo
                // if (!isFieldEmpty(selectedField, e)) return Container();

                // Si el campo está vacío o nulo, muestra el ListTile
                return AssetsDelayedDisplayYbasic(
                  curve: Curves.elasticOut, //Curves.easeInOutCubicEmphasized,
                  fadingDuration: 500,
                  duration: 200,
                  child: ListTile(
                    onTap: dataPoketbase.isSyncing
                        ? null
                        : () async {
                            // await dataPoketbase.saveProductosApp(e);
                            dataPoketbase.toBeDeleted.clear();
                            dataPoketbase.toBeUpdate.clear();
                            dataPoketbase.toBeCreated.clear();
                          },
                    leading: P3Text(text: e.key.toString()),
                    title: H2Text(text: e.title!),
                    subtitle: H2Text(text: e.apellidos),
                    trailing: AssetsDelayedDisplayX(
                      curve:
                          Curves.elasticOut, //Curves.easeInOutCubicEmphasized,
                      fadingDuration: 900,
                      duration: 200,
                      child: CircleAvatar(
                        child: Text(e.idsheety.toString()),
                        // dataPoketbase.isSyncing
                        //     ? CircularProgressIndicator()
                        //     : Text(e.idsheety.toString()),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para formatear el porcentaje
  String _formatPercentage(double value) {
    if (value == 1.0) {
      // Cuando el progreso es completo, mostrar 100%
      return '100';
    } else {
      // Convertir a porcentaje como cadena, mostrando decimales solo si son necesarios
      String formattedPercentage = (value * 100)
          .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
      return formattedPercentage.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    }
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class _ChartData {
  final String action;
  final double percentage;
  final Color color;

  _ChartData(this.action, this.percentage, this.color);
}
