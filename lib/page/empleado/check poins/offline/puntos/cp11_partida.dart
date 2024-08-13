import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/audit%20fielt/field_compare_chekp.dart';
import 'package:chasski/page/empleado/check%20poins/cp_pdf_partida.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp11.dart';
import 'package:chasski/provider/check%20point/online/provider_cp11.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/text/assets_textapp.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

//LISTA DE CAMPOS A FILTRAR
final titlepage = 'PUNTOS DE CONTROL';

String selectField = 'Hora marcación';

final items = [
  'estado',
  'idCheckPoints',
  'Hora marcación',
  'updated',
  'created',
  'Todos'
];
class SQLCheckPoint11 extends StatefulWidget {
  const SQLCheckPoint11({
    super.key,
   required this.nombre
  });
 final String nombre;

  @override
  State<SQLCheckPoint11> createState() => _SQLCheckPoint11State();
}

class _SQLCheckPoint11State extends State<SQLCheckPoint11> {
 ScreenshotController screenshotController = ScreenshotController();
  //BUSCADOR
  late List<TCheckPointsModel> filterSearch = [];

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
    final serverProvider = Provider.of<TCheckP011Provider>(context);
    final listServer = serverProvider.listAsistencia;

    // Obtener y ordenar la lista de puntos de control desde la base de datos local
    final dbProviderSQL = Provider.of<DBChPProvider11>(context);
    List<TCheckPointsModel> listaSQl = dbProviderSQL.listsql
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    // Determinar la lista de datos a mostrar: filtrada si hay criterios de búsqueda, de lo contrario, la lista ordenada
    List<TCheckPointsModel> searchProvider =
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
          ), bottom: TabBar(
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
                              label: H2Text(text: widget.nombre),
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
    required DBChPProvider11 dbProviderSQL,
    required String selectField,
  }) async {
    await dbProviderSQL.syncLocalDataToServer(
        context: context, screenshotController: screenshotController);

    final screenshot = await dbProviderSQL.captureWidget(
        screenshotController: screenshotController);

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
              PDfChekPoint(
                titlePDf: titlepage,
                toBeOmited: dbProviderSQL.toBeOmited,
                toBeUpdate: dbProviderSQL.toBeUpdate,
                toBeCreated: dbProviderSQL.toBeCreated,
                toBeDeleted: dbProviderSQL.toBeDeleted,
                tolocalExist: dbProviderSQL.tolocalExist,
                selectField: selectField,
                screenshot: screenshot,
              ),
            ],
          ));
    }
  }

  //Todos descargar base de datos
  void downloadData({
    required DBChPProvider11 dbProvider,
    required List<TCheckPointsModel> listaDatos,
    required String selectField,
  }) async {
    await dbProvider.guardarEnSQlLite(
        listServer: listaDatos,
        context: context,
        screenshotController: screenshotController);

    final screenshot = await dbProvider.captureWidget(
        screenshotController: screenshotController);

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
              PDfChekPoint(
                titlePDf: titlepage,
                toBeOmited: dbProvider.toBeOmited,
                toBeUpdate: dbProvider.toBeUpdate,
                toBeCreated: dbProvider.toBeCreated,
                toBeDeleted: dbProvider.toBeDeleted,
                tolocalExist: dbProvider.tolocalExist,
                selectField: selectField,
                screenshot: screenshot,
              ),
            ],
          ));
    }
  }

  //Todos borrar todo
  void deletedAll({
    required DBChPProvider11 dbProvider,
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
    required List<TCheckPointsModel> listaDatos,
    required DBChPProvider11 dbProvider,
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
