import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/provider/distancia/provider_t_distancias_ar.dart';
import 'package:chasski/provider/evento/provider_t_evento_ar.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/runners/offline/provider_sql___participantes.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/widget/doc%20runner%20pdf/runner_qr_generate.dart';
import 'package:flutter/material.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

//LISTA DE CAMPOS A FILTRAR
final titlepage = 'QR CORREDORES';

String selectField = 'distancias';

final items = [
  'distancias',
  'tallaDePolo',
  'genero',
  'rangoDeEdad',
  'grupoSanguineo',
  'created',
  'pais',
  'Todos'
];

class QrListaRunners extends StatefulWidget {
  const QrListaRunners({super.key});

  @override
  State<QrListaRunners> createState() => _QrListaRunnersState();
}


class _QrListaRunnersState extends State<QrListaRunners> {
  String idtrabajo = '';
  
  late TextEditingController _filterseachController;

  bool isSearch = false;

  // Lista para mantener el estado de expansión de los tiles
  // Set<int> expandedIndexes = Set<int>();
  // late ExpandedTileController _controller;
   // Mapa para mantener los controladores de expansión por índice
  Map<int, ExpandedTileController> expandedControllers = {};
  

  @override
  void initState() {
    super.initState();
    _filterseachController = TextEditingController();
    DatabaseInitializer.initializeDatabase(context);
    // _controller = ExpandedTileController(isExpanded: false);
  }

   void clearExpandedState() {
    expandedControllers.clear(); // Limpiar todos los controladores
  }
  @override
  Widget build(BuildContext context) {
    //********************** PROVIDER  */
    bool isffline = Provider.of<OfflineStateProvider>(context).isOffline;
    final serverProvider = Provider.of<TParticipantesProvider>(context);
    final dbProviderSQL = Provider.of<DBParticiapntesAppProvider>(context);
    //**********************  LISTA GENERAL DE DATOS  */
    final personalServerList = serverProvider.listaRunner;
    final personSQlList = dbProviderSQL.listsql;
    List<ParticipantesModel> personalList =
        isffline ? personSQlList : personalServerList;
    //**********************  DATOS FILTRADOS  */
    final filterSQL = dbProviderSQL.filteredData;
    final filterServer = serverProvider.filteredData;

    List<ParticipantesModel> filterData = isffline ? filterSQL : filterServer;
    //**********************  STRING DE BUSCADOR  */
    final searchTextSQL = dbProviderSQL.searchText;
    final searchTextServer = serverProvider.searchText;

    String searchText = isffline ? searchTextSQL : searchTextServer;
    //LISTA GRUPOS ALMACÉ
    final searchProvider =
        filterData.isEmpty && searchText.isEmpty ? personalList : filterData;
    //**********************  STRING DE BUSCADOR  */
    Map<String, List<ParticipantesModel>> groupedDataServer =
        serverProvider.groupByDistance(
            listParticipantes: searchProvider, filename: selectField);
    Map<String, List<ParticipantesModel>> groupedDataSQL =
        dbProviderSQL.groupByDistance(
            listParticipantes: searchProvider, filename: selectField);
    Map<String, List<ParticipantesModel>> groupedData =
        isffline ? groupedDataSQL : groupedDataServer;

    return DefaultTabController(
      length: groupedData.keys.length,
      child: Scaffold(
          appBar: AppBar(
            leading:  IconButton(
                    onPressed: () {
                      //  expandedIndexes.clear(); // Limpiar el estado de expansión al cambiar el campo
                     clearExpandedState(); // Limpiar el estado de expansión al cambiar el campo

                      setState(() {
                        isSearch = !isSearch;
                      });
                      if (!isSearch) {
                        _filterseachController.clear();
                        isffline
                            ? dbProviderSQL.clearSearch(personalList)
                            : serverProvider.clearSearch(personalList);
                      }
                    },
                    icon: Icon(isSearch ? Icons.close : Icons.search)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               
                AssetsAnimationSwitcher(
                  duration: 600,
                  child: isSearch
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          constraints: BoxConstraints(maxWidth: 200),
                          child: ClipRRect(
                            child: TextField(
                              controller: _filterseachController,
                              onChanged: (value) {
                                //  expandedIndexes.clear(); // Limpiar el estado de expansión al cambiar el campo
                                clearExpandedState(); // Limpiar el estado de expansión al cambiar el campo

                                isffline
                                    ? dbProviderSQL.setSearchText(
                                        value, personalList)
                                    : serverProvider.setSearchText(
                                        value, personalList);
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
                          iconAlignment: IconAlignment.end,
                          onPressed: () {
                            //  expandedIndexes.clear(); // Limpiar el estado de expansión al cambiar el campo
                                                  clearExpandedState(); // Limpiar el estado de expansión al cambiar el campo

                            optionGroupField(
                                context: context,
                                listaDatos: personalList,
                                dbProvider: dbProviderSQL,
                                serverProvider: serverProvider,
                                isffline: isffline);
                          },
                          icon: AppSvg(width: 20).menusvg,
                          label: H2Text(text: titlepage),
                        ),
                )
              ],
            ),
            actions: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: H2Text(
                    text: '${personalList.length}',
                  ),
                ),
              ),
            ],
            bottom: TabBar(
                labelColor: Colors.white,
                isScrollable: true,
                tabs: groupedData.keys.map((String distancias) {
                  return Tab(
                    icon: H1Text(
                        text: '${groupedData[distancias]?.length}', height: .5),
                    text: '$distancias',
                  );
                }).toList()),
          ),
          body: Column(
            children: [
              personalList.isEmpty
                  ? H2Text(
                      text: 'No hay datos disponibles',
                    )
                  : Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: groupedData.keys.map(
                          (String distancias) {
                            return ListView.builder(
                              itemCount: groupedData[distancias]!.length,
                              itemBuilder: (context, index) {
                                // Crear un controlador para cada índice si no existe
                                if (!expandedControllers.containsKey(index)) {
                                  expandedControllers[index] =
                                      ExpandedTileController(
                                          isExpanded: false);
                                }

                                final e = groupedData[distancias]![index];
                                final distanProvider =
                                    Provider.of<TDistanciasArProvider>(context,
                                            listen: false)
                                        .listAsistencia;

                                final distancia = distanProvider.firstWhere(
                                  (d) => d.id == e.idDistancia,
                                  orElse: () => distanciasDefault(),
                                );

                                final eventProvider =
                                    Provider.of<TEventoArProvider>(context,
                                            listen: false)
                                        .listDistancia;

                                final evento = eventProvider.firstWhere(
                                  (evento) => evento.id == e.idEvento,
                                  orElse: () => eventdefault(),
                                );

                                // Utilizar ValueKey para mantener el estado del ExpandedTileController
                                return ExpandedTile(
                                  key: ValueKey('${e.id}-${distancias}'),
                                  expansionAnimationCurve: Curves.elasticOut,
                                  theme: ExpandedTileThemeData(
                                    headerColor: getColorByIndex(index),
                                    headerPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  // controller: ExpandedTileController(
                                  //   isExpanded: expandedIndexes.contains(index),
                                  // ),
                                  controller: expandedControllers[index]!,
                                  leading: Container(
                                      width: 50, child: H2Text(text: e.dorsal)),
                                  title: AssetsDelayedDisplayX(
                                    duration: 300,
                                    fadingDuration: 300,
                                    child: H3Text(
                                      text: e.title + ' ' + e.apellidos,
                                    ),
                                  ),
                                  content: AssetsDelayedDisplayYbasic(
                                      duration: 300,
                                      child: PageQrGenerateRunner(
                                          e: e,
                                          distancia: distancia,
                                          evento: evento)),
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
            ],
          )),
    );
  }

  void optionGroupField(
      {required BuildContext context,
      required List<ParticipantesModel> listaDatos,
      required DBParticiapntesAppProvider dbProvider,
      required TParticipantesProvider serverProvider,
      required bool isffline}) {
     clearExpandedState();   
    AssetAlertDialogPlatform.show(
        context: context,
        message:
            'Selecciona el tipo de clasificación para organizar los datos.',
        title: 'Opciones de Clasificación',
        child: Container(
          width: double.maxFinite,
          child: Material(
            color: Colors.transparent,
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
                //  expandedIndexes.clear(); // Limpiar el estado de expansión al cambiar el campo
                setState(() {
                  selectField = value!;
                   clearExpandedState(); // Limpia el estado de expansión
                  isffline
                      ? dbProvider.groupByDistance(
                          listParticipantes: listaDatos, filename: selectField)
                      : serverProvider.groupByDistance(
                          listParticipantes: listaDatos, filename: selectField);
                });
              },
            ),
          ),
        ));
  }
}

