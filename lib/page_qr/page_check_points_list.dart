// import 'package:chaskis/models/model_runners_ar.dart';
import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:chasski/page_qr/check_points_list_routes.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_00.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_list_check_points_ar.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_list_check_points.dart'; 
import 'package:chasski/utils/format_fecha.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class CheckPotinsListPage extends StatefulWidget {
  const CheckPotinsListPage({super.key});
  @override
  State<CheckPotinsListPage> createState() => _CheckPotinsListPageState();
}

class _CheckPotinsListPageState extends State<CheckPotinsListPage> {
  String idtrabajo = '';
  late ExpandedTileController _controller;

  @override
  void initState() {
    //PONER TODAS LA BD-SQL INCIALIZADAS
    Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();

    Provider.of<DBCheckPointsAppProviderAr00>(context, listen: false)
        .initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    Provider.of<DBTListCheckPoitns_ARProvider>(context, listen: false)
        .initDatabase();
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      mostrarDialogoSeleccion();
    });
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);
  }

 
void mostrarDialogoSeleccion() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Para iOS (Cupertino Dialog)
        return CupertinoAlertDialog(
          title: Text('CHECK POINTS'),
          content: Text(
            'Por favor, selecciona un punto de control al que tengas permisos de acceso.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      } else {
        // Para Android (Material Dialog)
        return AlertDialog(
          title: Text('CHECK POINTS'),
          content: Text(
            'Por favor, selecciona un punto de control al que tengas permisos de acceso.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final dataCache = Provider.of<UsuarioProvider>(context);
    bool isffline = dataCache.isOffline;

    final listaCheckPServerList =
        Provider.of<TListCheckPoitnsProvider>(context).listAsistencia;
    final listaCheckPSQlList =
        Provider.of<DBTListCheckPoitns_ARProvider>(context).listsql;
    List<TListChekPoitnsModel> checkPList =
        isffline ? listaCheckPSQlList : listaCheckPServerList;
    //LISTA GRUPOS ALMACÉ
    checkPList.sort((a, b) => a.orden.compareTo(b.orden));

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 370),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(20),
                      child: H2Text(
                        text: 'PUNTOS DE CONTROL',
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                  dataCache.usuarioEncontrado!.rol == 'admin'
                      ? Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 370),
                            child: checkPList.isEmpty
                                ? H2Text(
                                    text: 'No hay datos disponibles',
                                    color: Colors.white,
                                    fontSize: 14,
                                  )
                                : ExpandedTileList.builder(
                                    itemCount: checkPList.length,
                                    itemBuilder: (context, index, controller) {
                                      final e = checkPList[index];
                                      //Color intercalado
                                      Color color = index % 2 == 0
                                          ? Color(0x1C747373)
                                          : Color(0x347D7C7C);
                                      return ExpandedTile(
                                        expansionAnimationCurve:
                                            Curves.easeInOut,
                                        theme: ExpandedTileThemeData(
                                          headerColor: color,
                                          // headerRadius: 14.0,
                                          headerPadding: EdgeInsets.all(14.0),
                                          headerSplashColor: Colors.white,
                                          contentBackgroundColor: Colors.white,
                                          contentPadding: EdgeInsets.all(20.0),
                                          // contentRadius: 12.0,
                                        ),
                                        controller: _controller,
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            H2Text(
                                              text: e.nombre,
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Table(
                                              border: TableBorder.all(
                                                  color: Colors.transparent,
                                                  width: 0.4),
                                              children: [
                                                headersRow(),
                                                contentTable(e),
                                              ],
                                            ),
                                          ],
                                        ),
                                        content: DelayedDisplay(
                                            delay: Duration(milliseconds: 300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    //BOTON  PAGINA SCANNER
                                                    Card(
                                                        color: Colors.blue,
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                              navigateToPageCheckPoint(
                                                                  e, context);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .qr_code_scanner,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: H2Text(
                                                              text: 'GO',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ))),
                                                    //BOTON DESCARGAER PDF LISTA DE CORREDORES
                                                    //BOTON  OTROS: INSUMOS PUESTO< INCIDENTES ETC T
                                                    //debe exportar la lista de corredores, los encargados del puesto y lista de insumos.
                                                    Card(
                                                        color: Colors.green,
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                              print(
                                                                  'Exportar PDF ');
                                                            },
                                                            icon: Icon(
                                                              Icons.download,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: H2Text(
                                                              text: 'PDF',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ))),
                                                       Card(
                                                        color: Colors.red,
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                              navigateToPageCheckPointOflline(e, context);
                                                            },
                                                            icon: Icon(
                                                              Icons.sync_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: H2Text(
                                                              text: 'Sync',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                            ))),
                                                  ],
                                                ),
                                                ContentCheckPoints(),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                          ),
                        )
                      : const Center(
                          child: H2Text(
                            text:
                                'Acceso restringido: Solo los administradores tienen permisos para este panel.',
                            fontSize: 13,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  TableRow contentTable(TListChekPoitnsModel e) {
    return TableRow(
      children: [
        H2Text(
          text: e.ubicacion,
          fontSize: 11,
          color: Colors.red,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: e.elevacion,
          fontSize: 11,
          color: Colors.red,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: formatFechaPDfhora(e.horaApertura),
          fontSize: 11,
          color: Colors.red,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: formatFechaPDfhora(e.horaCierre),
          fontSize: 11,
          color: Colors.red,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  TableRow headersRow() {
    return TableRow(
      children: [
        H2Text(
          text: 'ORDEN',
          fontSize: 10,
          color: Colors.white54,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'ELEVACIÓN',
          fontSize: 10,
          color: Colors.white54,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'APERTURA',
          fontSize: 10,
          color: Colors.white54,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'CIERRE',
          fontSize: 10,
          color: Colors.white54,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ContentCheckPoints extends StatelessWidget {
  const ContentCheckPoints({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: H2Text(
              text: 'PERSONAL',
              fontWeight: FontWeight.bold,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2Text(
                  text: 'Alberto Sanchez',
                  fontSize: 12,
                ),
                H2Text(
                  text: 'Enrrique Sanchez',
                  fontSize: 12,
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: H2Text(
              text: 'INSUMOS POR PUESTO',
              fontWeight: FontWeight.bold,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(10, (index) {
                  Color color = index % 2 == 0
                      ? Colors.black12
                      : Color.fromARGB(255, 249, 247, 247);

                  return Table(
                      // border: TableBorder.all(color: Colors.grey, width: 0.4),
                      children: [
                        if (index == 0) TableHeader(),
                        TableRow(
                          children: [
                            CellTable(color: color, text: 'Banderines'),
                            CellTable(color: color, text: '510'),
                            CellTable(color: color, text: 'Carro X0-23'),
                            CellTable(color: color, text: 'Check'),
                          ],
                        )
                      ]);
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container CellTable({Color? color, String? text}) {
    return Container(
      color: color,
      child: H2Text(
        text: text!,
        fontSize: 10,
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow TableHeader() {
    return TableRow(
      children: [
        H2Text(
          text: 'INSUMOS',
          fontSize: 10,
          // color: Colors.white54,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'CANTIDAD',
          fontSize: 10,
          // color: Colors.white54,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'DESPCIPCION',
          fontSize: 10,
          // color: Colors.white54,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'DEVOLUCIÓN',
          fontSize: 10,
          // color: Colors.white54,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
