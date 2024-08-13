import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/provider/check%20point/online/provider__list_chkpoint.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql__list_chkpoint.dart';
import 'package:chasski/utils/conversion/asset_format_porcentaje_progrees.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/conversion/assets_format_parse_string_a_double.dart';

import 'package:flutter/material.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//LISTA DE CAMPOS A FILTRAR
final titlepage = 'PUNTOS DE CONTROL';

String selectField = 'idEvento';

final items = [
  'horaApertura',
  'horaCierre',
  'estado',
  'elevacion',
  'idEvento',
  'Todos'
];

class DBListCheckPointsArPage extends StatefulWidget {
  const DBListCheckPointsArPage({
    super.key,
  });

  @override
  State<DBListCheckPointsArPage> createState() =>
      _DBListCheckPointsArPageState();
}

class _DBListCheckPointsArPageState extends State<DBListCheckPointsArPage> {
  ScreenshotController screenshotController = ScreenshotController();
  //BUSCADOR
  late List<TListChekPoitnsModel> filterSearch = [];

  late TextEditingController _filterseachController;

  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    //INICAR TODAS LA BASE DE DATOS
    _filterseachController = TextEditingController();
    DatabaseInitializer.initializeDatabase(context);
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la lista del servidor para su descarga
    final serverProvider = Provider.of<TListCheckPoitnsProvider>(context);
    final listServer = serverProvider.listAsistencia;

    // Obtener y ordenar la lista de puntos de control desde la base de datos local
    final dbProviderSQL = Provider.of<DBTListCheckPoitnsProvider>(context);
    List<TListChekPoitnsModel> listaSQl = dbProviderSQL.listsql
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    // Determinar la lista de datos a mostrar: filtrada si hay criterios de búsqueda, de lo contrario, la lista ordenada
    List<TListChekPoitnsModel> searchProvider =
        (dbProviderSQL.filteredData.isEmpty && dbProviderSQL.searchText.isEmpty)
            ? listaSQl
            : dbProviderSQL.filteredData;

    //Los datos ya sea buscados se  Agruparan los datos por distancia utilizando la lista filtrada o la lista completa
    final groupedData = dbProviderSQL.groupByDistance(
        listParticipantes: searchProvider, filename: selectField);

    return DefaultTabController(
      length: groupedData.keys.length,
      child: Scaffold(
        appBar: AppBar(
           leadingWidth: 30,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
               children: [
            ElevatedButton.icon(
                onPressed: dbProviderSQL.offlineSync
                    ? null
                    : () async {
                        synedServerData(
                            dbProviderSQL: dbProviderSQL,
                            selectField: selectField);
                      },
                icon: dbProviderSQL.offlineSync
                    ? AssetsCircularProgreesIndicator()
                    : AppSvg(width: 20).configSyncBlue,
                label: P3Text(text: 'Sync\nServer')),
            SizedBox(width: 5),
            ElevatedButton.icon(
                onPressed: dbProviderSQL.offlineSaving
                    ? null
                    : () async {
                        downloadData(
                            dbProvider: dbProviderSQL,
                            listaDatos: listServer,
                            selectField: selectField);
                      },
                icon: dbProviderSQL.offlineSaving
                    ? AssetsCircularProgreesIndicator()
                    : AppSvg(width: 20).databaseBlue,
                label: P3Text(text: 'Guardar\nLocal')),
            SizedBox(
              width: 5,
            ),
            ElevatedButton.icon(
                onPressed: dbProviderSQL.isClearnAll
                    ? null
                    : () async {
                        deletedAll(dbProvider: dbProviderSQL);
                      },
                icon: dbProviderSQL.isClearnAll
                    ? AssetsCircularProgreesIndicator()
                    : const Icon(
                        Icons.delete,
                      ),
                label: P3Text(text: 'Borrar\nTodo')),
            Container(
              decoration: decorationBox(),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(5.0),
              child: H2Text(
                text: '${listaSQl.length}',
                 color: Colors.white,
              ),
            ),
          ],
         
            ),
          ) ,
          bottom: TabBar(
              labelColor: Colors.white,
              isScrollable: true,
              tabs: groupedData.keys.map((String distancias) {
                return Tab(
                  icon: H1Text(text: '${groupedData[distancias]?.length}'),
                  text: '$distancias',
                );
              }).toList()),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                          });
                          if (!isSearch) {
                            _filterseachController.clear();
                            dbProviderSQL.clearSearch(listaSQl);
                          }
                        },
                        icon: Icon(isSearch ? Icons.close : Icons.search)),
                    AssetsAnimationSwitcher(
                      duration: 600,
                      child: isSearch
                          ? Container(
                              padding: const EdgeInsets.all(8.0),
                              constraints: BoxConstraints(maxWidth: 250),
                              child: ClipRRect(
                                child: TextField(
                                  controller: _filterseachController,
                                  onChanged: (value) {
                                    dbProviderSQL.setSearchText(
                                        value, listaSQl);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Buscar',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                optionGroupField(
                                    context: context,
                                    listaDatos: listaSQl,
                                    dbProvider: dbProviderSQL);
                              },
                              icon: AppSvg(width: 20).menusvg,
                              label: H2Text(text: titlepage),
                            ),
                    )
                  ],
                ),
                listaSQl.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            AppSvg(width: 150).databaseBlue,
                            P3Text(text: 'Aùn no tienes datos locales'),
                          ],
                        ),
                      )
                    : Expanded(
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: groupedData.keys.map((String distancias) {
                              return ListView.builder(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * .2,
                                ),
                                itemCount: groupedData[distancias]?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final e = groupedData[distancias]![index];
                                  return Container(
                                    color: getColorByIndex(index),
                                    child: CardTCheckPointsModel(
                                        e: e, index: index),
                                  );
                                },
                              );
                            }).toList()),
                      ),
              ],
            ),
            AssetsAnimationSwitcher(
                duration: 600,
                child:
                    (dbProviderSQL.offlineSaving || dbProviderSQL.offlineSync)
                        ? Screenshot(
                            controller: screenshotController,
                            child: ProgreesCharWidgetAR(
                              listServer: listServer,
                              toBeOmited: dbProviderSQL.toBeOmited,
                              toBeUpdate: dbProviderSQL.toBeUpdate,
                              toBeCreated: dbProviderSQL.toBeCreated,
                              toBeDeleted: dbProviderSQL.toBeDeleted,
                              tolocalExist: dbProviderSQL.tolocalExist,
                              progreesLotes: dbProviderSQL.progreesLotes,
                            ))
                        : SizedBox())
            //todos Barra de progreso
          ],
        ),
      ),
    );
  }

  Widget buildLegendItem(String text, String peecent, Color color) {
    return FittedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                color: color,
              ),
              SizedBox(width: 2),
              P3Text(text: text),
            ],
          ),
          H3Text(text: peecent),
        ],
      ),
    );
  }

  void synedServerData({
    required DBTListCheckPoitnsProvider dbProviderSQL,
    required String selectField,
  }) async {
    await dbProviderSQL.syncLocalDataToServer(
        context: context, screenshotController: screenshotController);

    // final screenshot = await dbProviderSQL.captureWidget(
    //     screenshotController: screenshotController);

    if (dbProviderSQL.offlineSync == false) {
      AssetAlertDialogPlatform.show(
          context: context,
          message:
              'La base de datos se ha sincronizado y almacenado en el servidor.' +
                  ' ¿Quiere ver el reporte de la descarga?',
          title: 'Sincronización completada',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDfIncidentes(
              //   titlePDf: titlepage,
              //   toBeOmited: dbProviderSQL.toBeOmited,
              //   toBeUpdate: dbProviderSQL.toBeUpdate,
              //   toBeCreated: dbProviderSQL.toBeCreated,
              //   toBeDeleted: dbProviderSQL.toBeDeleted,
              //   tolocalExist: dbProviderSQL.tolocalExist,
              //   selectField: selectField,
              //   screenshot: screenshot,
              // ),
            ],
          ));
    }
  }

  //Todos descargar base de datos
  void downloadData({
    required DBTListCheckPoitnsProvider dbProvider,
    required List<TListChekPoitnsModel> listaDatos,
    required String selectField,
  }) async {
    await dbProvider.guardarEnSQlLite(
        listServer: listaDatos,
        context: context,
        screenshotController: screenshotController);

    // final screenshot = await dbProvider.captureWidget(
    //     screenshotController: screenshotController);

    if (dbProvider.offlineSaving == false) {
      AssetAlertDialogPlatform.show(
          context: context,
          message:
              'La base de datos se ha descargado y almacenado localmente.' +
                  ' ¿Quiere ver el reporte de la descarga?',
          title: 'Descarga completada',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PDfIncidentes(
              //   titlePDf: titlepage,
              //   toBeOmited: dbProvider.toBeOmited,
              //   toBeUpdate: dbProvider.toBeUpdate,
              //   toBeCreated: dbProvider.toBeCreated,
              //   toBeDeleted: dbProvider.toBeDeleted,
              //   tolocalExist: dbProvider.tolocalExist,
              //   selectField: selectField,
              //   screenshot: screenshot,
              // ),
            ],
          ));
    }
  }

  //Todos borrar todo
  void deletedAll({
    required DBTListCheckPoitnsProvider dbProvider,
  }) async {
    AssetAlertDialogPlatform.show(
        context: context,
        message:
            '¿Está seguro de que quiere borrar todos los datos almacenados localmente?' +
                ' Recuerde que necesitará Internet para volver recargar los datos.',
        title: 'Borrar base de datos',
        child: Table(
          children: [
            TableRow(children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No')),
              ElevatedButton(
                  onPressed: () async {
                    await dbProvider.cleartable();
                    Navigator.pop(context);
                  },
                  child: Text('Si')),
            ])
          ],
        ));
  }

  //Todos DrowpDown Slect field
  void optionGroupField({
    required BuildContext context,
    required List<TListChekPoitnsModel> listaDatos,
    required DBTListCheckPoitnsProvider dbProvider,
  }) {
    AssetAlertDialogPlatform.show(
        context: context,
        message:
            'Selecciona el tipo de clasificación para organizar los datos.',
        title: 'Opciones de Clasificación',
        child: Container(
          width: double.maxFinite,
          child: Material(
            child: DropdownButton<String>(
              value: selectField,
              borderRadius: BorderRadius.circular(10),
              items: List.generate(items.length, (index) {
                return DropdownMenuItem(
                  value: items[index],
                  child: P2Text(text: items[index]),
                  alignment: AlignmentDirectional.center,
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectField = value!;
                  dbProvider.groupByDistance(
                      listParticipantes: listaDatos, filename: selectField);
                });
              },
            ),
          ),
        ));
  }
}

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
  final List<TListChekPoitnsModel> listServer;
  final List<TListChekPoitnsModel> toBeOmited;
  final List<TListChekPoitnsModel> toBeUpdate;
  final List<TListChekPoitnsModel> toBeCreated;
  final List<TListChekPoitnsModel> toBeDeleted;
  final List<TListChekPoitnsModel> tolocalExist;
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
