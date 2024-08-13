import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/page/empleado/offline/runner/cp___pdf_participantes.dart';
import 'package:chasski/utils/conversion/asset_format_porcentaje_progrees.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
// import 'package:chasski/widgets/assets_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepContent3 extends StatelessWidget {
  const StepContent3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);
    TEventoModel evento = dataEventcache.selectedEvent;

    final dataProvider = Provider.of<ParticipantesProviderSheety>(context);
    List<ParticipantesModel> listSheet = dataProvider.listParticipantes;

    final dataPoketbase = Provider.of<TParticipantesProvider>(context);
    final listPoketbase = dataPoketbase.listaRunner;
    final bool isSyn = dataPoketbase.isSyncing;

    // double progress = listPoketbase.length / listSheet.length;
    int total = (dataPoketbase.toBeOmited.length +
        dataPoketbase.toBeUpdate.length +
        dataPoketbase.toBeCreated.length);
    double progress = total / listSheet.length;

    String percentage = formatPercentage(progress);

    return (listSheet.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ElevatedButton.icon(
                        iconAlignment: IconAlignment.start,
                        onPressed: isSyn
                            ? null
                            : () async {
                                AssetAlertDialogPlatform.show(context: context, 
                                title: 'Alerta!', 
                                message: 'Por favor, no cierres esta página mientras se está sincronizando.'+
                                ' Espera hasta que termine para evitar posibles problemas o inconsistencias en los datos.'+
                                '\nPresiona OK para continuar con la sincronización.',
                                );
                                await dataPoketbase.sincServer(context,
                                    listSheet: listSheet, evento: evento);

                                 if (isSyn == false) {
                                    AssetAlertDialogPlatform.show(
                                        context: context,
                                        message:
                                            'La base de datos se ha descargado y almacenado localmente.' +
                                                ' ¿Quiere ver el reporte de la descarga?',
                                        title: 'Descarga completada',
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            PdfParticipantes(
                                              titlePDf: 'SYNC GOOGLE SHEET',
                                              toBeOmited: dataPoketbase.toBeOmited,
                                              toBeUpdate: dataPoketbase.toBeUpdate,
                                              toBeCreated: dataPoketbase.toBeCreated,
                                              toBeDeleted: [],
                                              tolocalExist:[],
                                              selectField: 'distancias',
                                              
                                            ),
                                          ],
                                        ));
                                  }
                              },
                        icon: isSyn
                            ? CircularProgressIndicator()
                            : AppSvg().configBlue,
                        label: Text(isSyn
                            ? "Sincronizando..."
                            : "Haga clic para sincronizar"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      H1Text(
                        text: '${listPoketbase.length}',
                        fontSize: 30,
                        color: AppColors.accentColor,
                      ),
                      P3Text(text: 'Total registros'),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 10),
              Consumer<TParticipantesProvider>(
                builder: (context, dataPoketbase, child) {
                  return Table(
                    children: [
                      TableRow(children: [
                        _buildtableRow(
                            svg: AppSvg(width: 20).serverBlue,
                            title: 'toSynced',
                            total: total),
                        _buildtableRow( 
                            svg: AppSvg(width: 20).monitorBlue,
                            title: 'toBeOmited',
                            total: dataPoketbase.toBeOmited.length),
                        _buildtableRow(
                            svg: AppSvg(width: 20).monitorBlue,
                            title: 'toBeUpdated',
                            total: dataPoketbase.toBeUpdate.length),
                        _buildtableRow(
                            svg: AppSvg(width: 20).monitorBlue,
                            title: 'toBeCreated',
                            total: dataPoketbase.toBeCreated.length),
                        _buildtableRow(
                            svg: AppSvg(width: 20).databaseBlue,
                            title: 'toSheets',
                            total: listSheet.length),
                      ]),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Consumer<TParticipantesProvider>(
                builder: (context, dataPoketbase, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 12,
                                backgroundColor: Colors.grey.withOpacity(.2),
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
                        Text(
                          'Progress: $percentage%',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Consumer<TParticipantesProvider>(
                builder: (context, dataPoketbase, child) {
                  int datossinaccion = dataPoketbase.toBeOmited.length;
                  int datocreados = dataPoketbase.toBeCreated.length;
                  int datoactualizados = dataPoketbase.toBeUpdate.length;
                  // int total = listPoketbase.length;
                  int total = (dataPoketbase.toBeOmited.length +
                      dataPoketbase.toBeUpdate.length +
                      dataPoketbase.toBeCreated.length);

                  double porcentajeOmitidos =
                      total > 0 ? datossinaccion / total * 100 : 0;
                  double porcentajeCreados =
                      total > 0 ? datocreados / total * 100 : 0;
                  double porcentajeActualizados =
                      total > 0 ? datoactualizados / total * 100 : 0;

                  String omitidos = porcentajeOmitidos.toStringAsFixed(2);
                  String creados = porcentajeCreados.toStringAsFixed(2);
                  String actualizados =
                      porcentajeActualizados.toStringAsFixed(2);

                  List<ChartData> chartData = [
                    ChartData('Omitidos', porcentajeOmitidos, Colors.red),
                    ChartData('Creados', porcentajeCreados, Colors.green),
                    ChartData(
                        'Actualizados', porcentajeActualizados, Colors.blue),
                  ];

                  return Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 350),
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
                      SizedBox(height: 20),
                      Text(
                        'Porcentaje de acciones:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildLegendItem('Omitidos', '$omitidos%', Colors.red),
                          buildLegendItem('Creados', '$creados%', Colors.green),
                          buildLegendItem(
                              'Actualizados', '$actualizados%', Colors.blue),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          )
        : P2Text(text: 'No puede continuar sin cargar la lista de corredores.');
  }

  Widget _buildtableRow(
      {required String title, required int total, required Widget svg}) {
    return Column(
      children: [
        svg,
        P3Text(
          text: title,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        H2Text(
          text: '${total}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
