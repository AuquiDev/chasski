import 'package:chasski/models/check%20point/model_list_check_points_ar.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp13_partida.dart';
import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/provider/producto/provider_t_productoapp.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp0_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp1_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp10_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp11_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp12_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp2_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp14_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp3_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp4_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp5_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp6_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp7_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp8_partida.dart';
import 'package:chasski/page/empleado/check%20poins/offline/puntos/cp9_partida.dart';
import 'package:chasski/page/empleado/qr%20lector/check%20points/qr_lector_global_checkpoints.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp1.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp10.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp11.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp12.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp13.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp2.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp14.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp3.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp4.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp5.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp6.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp7.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp8.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp9.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql__list_chkpoint.dart';
import 'package:chasski/provider/check%20point/online/provider_cp00.dart';
import 'package:chasski/provider/check%20point/online/provider_cp01.dart';
import 'package:chasski/provider/check%20point/online/provider_cp10.dart';
import 'package:chasski/provider/check%20point/online/provider_cp11.dart';
import 'package:chasski/provider/check%20point/online/provider_cp12.dart';
import 'package:chasski/provider/check%20point/online/provider_cp13.dart';
import 'package:chasski/provider/check%20point/online/provider_cp02.dart';
import 'package:chasski/provider/check%20point/online/provider_cp14.dart';
import 'package:chasski/provider/check%20point/online/provider_cp03.dart';
import 'package:chasski/provider/check%20point/online/provider_cp04.dart';
import 'package:chasski/provider/check%20point/online/provider_cp05.dart';
import 'package:chasski/provider/check%20point/online/provider_cp06.dart';
import 'package:chasski/provider/check%20point/online/provider_cp07.dart';
import 'package:chasski/provider/check%20point/online/provider_cp08.dart';
import 'package:chasski/provider/check%20point/online/provider_cp09.dart';
import 'package:chasski/provider/empleado/online/provider_t_empleado.dart';
import 'package:chasski/provider/check%20point/online/provider__list_chkpoint.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp0.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/conversion/assets_format_parse_string_a_double.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:flutter/material.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

typedef ProvidersMap = Map<String, List<dynamic>>;

class CheckPotinsListPage extends StatefulWidget {
  const CheckPotinsListPage({super.key});
  @override
  State<CheckPotinsListPage> createState() => _CheckPotinsListPageState();
}

class _CheckPotinsListPageState extends State<CheckPotinsListPage> {
  String idtrabajo = '';
  String nombre = '';

  late ExpandedTileController _controller;

  @override
  void initState() {
    super.initState();
    DatabaseInitializer.initializeDatabase(context);

    mostrarDialogoSeleccion();
    _controller = ExpandedTileController(isExpanded: false);
  }

  void mostrarDialogoSeleccion() {
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      AssetAlertDialogPlatform.show(
          context: context,
          title: ' Punto de Control',
          message: 'Asegúrate de configurar la opción correspondiente.',
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi,
                    color: Colors.green,
                  ),
                  Icon(
                    Icons.wifi_off_outlined,
                    color: Colors.red,
                  ),
                ],
              ),
              P3Text(
                text: 'Puedes trabajar con o sin internet.',
                textAlign: TextAlign.center,
              ),
            ],
          ));
      TextToSpeechService().speak('Puedes trabajar con o sin internet.' +
          'Asegúrate de configurar la opción correspondiente en el menú de opciones');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final dataCache = Provider.of<UsuarioProvider>(context);
    bool isffline = Provider.of<OfflineStateProvider>(context).isOffline;

    final listChPServer =
        Provider.of<TListCheckPoitnsProvider>(context).listAsistencia;
    final listChPSQL = Provider.of<DBTListCheckPoitnsProvider>(context).listsql;
    List<TListChekPoitnsModel> checkPList =
        isffline ? listChPSQL : listChPServer;

    checkPList.sort((a, b) => a.orden.compareTo(b.orden));
    final filter = checkPList.where((e) => e.estatus == true).toList();
    Map<String, List<dynamic>> providersMap = {
      '0': [
        Provider.of<DBChPProvider00>(context),
        Provider.of<TCheckP00Provider>(context),
        //Pagina
        SQLCheckPoint00(
          nombre: "0" + nombre,
        ),
      ],
      '1': [
        Provider.of<DBChPProvider01>(context),
        Provider.of<TCheckP01Provider>(context),
        //Pagina
        SQLCheckPoint01(
          nombre: "1" + nombre,
        ),
      ],
      '2': [
        Provider.of<DBChPProvider02>(context),
        Provider.of<TCheckP02Provider>(context),
        //Pagina
        SQLCheckPoint02(
          nombre: "2" + nombre,
        ),
      ],
      '3': [
        Provider.of<DBChPProvider03>(context),
        Provider.of<TCheckP03Provider>(context),
        //Pagina
        SQLCheckPoint03(
          nombre: "3" + nombre,
        ),
      ],
      '4': [
        Provider.of<DBChPProvider04>(context),
        Provider.of<TCheckP04Provider>(context),
        //Pagina
        SQLCheckPoint04(
          nombre: "4" + nombre,
        ),
      ],
      '5': [
        Provider.of<DBChPProvider05>(context),
        Provider.of<TCheckP05Provider>(context),
        //Pagina
        SQLCheckPoint05(
          nombre: "5" + nombre,
        ),
      ],
      '6': [
        Provider.of<DBChPProvider06>(context),
        Provider.of<TCheckP06Provider>(context),
        //Pagina
        SQLCheckPoint06(
          nombre: "6" + nombre,
        ),
      ],
      '7': [
        Provider.of<DBChPProvider07>(context),
        Provider.of<TCheckP07Provider>(context),
        //Pagina
        SQLCheckPoint07(
          nombre: "7" + nombre,
        ),
      ],
      '8': [
        Provider.of<DBChPProvider08>(context),
        Provider.of<TCheckP08Provider>(context),
        //Pagina
        SQLCheckPoint08(
          nombre: "8" + nombre,
        ),
      ],
      '9': [
        Provider.of<DBChPProvider09>(context),
        Provider.of<TCheckP09Provider>(context),
        //Pagina
        SQLCheckPoint09(
          nombre: "9" + nombre,
        ),
      ],
      '10': [
        Provider.of<DBChPProvider10>(context),
        Provider.of<TCheckP010Provider>(context),
        //Pagina
        SQLCheckPoint10(
          nombre: "10" + nombre,
        ),
      ],
      '11': [
        Provider.of<DBChPProvider11>(context),
        Provider.of<TCheckP011Provider>(context),
        //Pagina
        SQLCheckPoint11(
          nombre:  "11" +nombre,
        ),
      ],
      '12': [
        Provider.of<DBChPProvider12>(context),
        Provider.of<TCheckP012Provider>(context),
        //Pagina
        SQLCheckPoint12(
          nombre:  "12" +nombre,
        ),
      ],
      '13': [
        Provider.of<DBChPProvider13>(context),
        Provider.of<TCheckP013Provider>(context),
        //Pagina
        SQLCheckPoint13(
          nombre: "13" + nombre,
        ),
      ],
      '14': [
        Provider.of<DBChPProvider14>(context),
        Provider.of<TCheckP020METAProvider>(context),
        //Pagina
        SQLCheckPoint14(nombre:  "14" +nombre),
      ],
      // Agrega otros proveedores si es necesario
    };

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 20,
                color: Colors.grey.shade500,
                child: ListTile(
                  title: FittedBox(
                    child: H1Text(
                      text: 'PUNTOS DE CONTROL'.toUpperCase(),
                    ),
                  ),
                  leading: AppSvg(width: 80).checkPointsSvg,
                ),
              ),
              Center(
                child: Container(
                  child: filter.isEmpty
                      ? P2Text(
                          text: 'No hay datos disponibles',
                        )
                      : ExpandedTileList.builder(
                          itemCount: filter.length,
                          itemBuilder: (context, index, controller) {
                            final e = filter[index];
                            return ExpandedTile(
                              // enabled: false, inabilita el expanded, puede servir para usairos isn permiso
                              expansionAnimationCurve: Curves.easeInOut,
                              theme: ExpandedTileThemeData(
                                headerColor: getColorByIndex(index),
                                contentBackgroundColor: Colors.white,
                              ),
                              controller: _controller,
                              leading: Container(
                                width: MediaQuery.of(context).size.width * .13,
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      H1Text(text: e.orden.toString()),
                                      P2Text(
                                        text: e.ubicacion,
                                      ),
                                      P3Text(
                                        text: e.elevacion,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  nombre = e.nombre;
                                  idtrabajo = e.id!;
                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H2Text(
                                    text: e.nombre,
                                  ),
                                  FittedBox(
                                    child: P2Text(
                                      text: formatControlPointTimes(
                                          e.horaApertura, e.horaCierre),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              content: AssetsDelayedDisplayYbasic(
                                  duration: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      P2Text(
                                        text: '${e.descripcion}',
                                        textAlign: TextAlign.justify,
                                      ),
                                      Menuoptions(
                                        e: e,
                                        providersMap: providersMap,
                                      ),
                                      ContentCheckPoints(
                                        e: e,
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class Menuoptions extends StatelessWidget {
  const Menuoptions({
    super.key,
    required this.e,
    required this.providersMap,
  });

  final TListChekPoitnsModel e;
  final ProvidersMap providersMap;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        children: [
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              bool isstart = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AssetAlertDialogPlatform(
                        message:
                            'Comienza la marcación y el registro de corredores en los puntos de control.',
                        title: e.nombre,
                      );
                    },
                  ) ??
                  true;
              if (!isstart) {
                //SI es faslo hacemos
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QrLectoGlobalChekPoint(
                            idCheckPoints: e.id!,
                            name: e.nombre,
                            orden: e.orden,
                            providersMap: providersMap)));
              }
            },
            icon: AppLoties().qrLoties,
            label: P3Text(
              text: 'Iniciar',
            ),
          ),
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              bool proceed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AssetAlertDialogPlatform(
                        message:
                            'Exportar el informe detallado:\n- responsable\n- participantes.\n- insumos.',
                        title: e.nombre,
                        child: AppSvg().pdfSvg,
                      );
                    },
                  ) ??
                  true;

              if (!proceed) {
                // Crear apgian para exporta informe detallado de equipos y encargados
              }
            },
            icon: AppSvg().pdfSvg,
            label: P3Text(
              text: 'Exportar',
            ),
          ),
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              // Si el usuario confirma, navegamos a la página con los datos locales
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                final checkPointProviders = providersMap['${e.orden}'] ?? [];

                Widget pageWidget = checkPointProviders[2];
                return pageWidget;
              }));
              // navigateToPageCheckPointOflline(e, context);
            },
            icon: AppSvg().databaseBlue,
            label: P3Text(
              text: 'Local',
            ),
          ),
        ],
      ),
    );
  }
}

class ContentCheckPoints extends StatelessWidget {
  const ContentCheckPoints({super.key, required this.e});
  final TListChekPoitnsModel e;
  @override
  Widget build(BuildContext context) {
    List<TProductosAppModel> itemsList = e.itemsList ?? [];
    List<TEmpleadoModel> personal = e.personal ?? [];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Personal'),
              Tab(text: 'Insumos'),
            ],
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 400),
            child: TabBarView(
              children: [
                _buildPersonalAsignado(context, personal),
                _buildInsumoAsignado(context, itemsList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildInsumoAsignado(
      BuildContext context, List<TProductosAppModel> itemsList) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemInsumoList(e: e)));
              },
              child: P2Text(text: 'Añadir nuevo')),
          ...List.generate(itemsList.length, (index) {
            final a = itemsList[index];
            return Container(
              decoration: decorationBox(color: Colors.white),
              margin: EdgeInsets.all(5),
              child: ListTile(
                contentPadding: EdgeInsets.all(5),
                dense: true,
                visualDensity: VisualDensity.compact,
                title: H3Text(
                  text: a.nombreProducto + ' ' + a.unidMedida,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: P2Text(text: '${a.idCategoria}')),
                        H2Text(text: '${parseToformatearNumero(a.stock ?? 0)}'),
                        P3Text(text: ' und   '),
                      ],
                    ),
                  ],
                ),
                leading: IconButton(
                    onPressed: () async {
                      confirEliminProducto(context: context, producto: a);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.primaryRed,
                    )),
              ),
            );
          }),
        ],
      ),
    );
  }

  void confirEliminProducto(
      {required BuildContext context,
      required TProductosAppModel producto}) async {
    bool isDeleted = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AssetAlertDialogPlatform(
                message: '¿Confirmar eliminación?',
                title: 'Eliminar ${producto.nombreProducto}',
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('no eliminar')),
              );
            }) ??
        true;
    if (!isDeleted) {
      e.itemsList!.remove(producto);
      context.read<TListCheckPoitnsProvider>().saveProductosApp(e);
    }
  }

  SingleChildScrollView _buildPersonalAsignado(
      BuildContext context, List<TEmpleadoModel> personal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PersonalLis(e: e)));
              },
              child: P1Text(text: 'Añadir nuevo')),
          ...List.generate(personal.length, (index) {
            final a = personal[index];
            return Container(
              decoration: decorationBox(color: Colors.white),
              margin: EdgeInsets.all(5),
              child: ListTile(
                contentPadding: EdgeInsets.all(6),
                dense: true,
                visualDensity: VisualDensity.compact,
                title: H3Text(
                  text: a.nombre + ' ' + a.apellidos,
                ),
                subtitle: P2Text(
                  text: a.cargo,
                  textAlign: TextAlign.justify,
                ),
                // leading: AppSvg().personSvg,
                leading: IconButton(
                    onPressed: () async {
                      confimEliminacion(context: context, empleado: a);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.primaryRed,
                    )),
              ),
            );
          }),
        ],
      ),
    );
  }

  void confimEliminacion(
      {required BuildContext context, required TEmpleadoModel empleado}) async {
    bool isDeleted = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AssetAlertDialogPlatform(
                message: '¿Confirmar eliminación?',
                title: 'Eliminar ${empleado.nombre}',
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('no eliminar')),
              );
            }) ??
        true;

    if (!isDeleted) {
      e.personal!.remove(empleado);
      context.read<TListCheckPoitnsProvider>().saveProductosApp(e);
    }
  }
}

class PersonalLis extends StatelessWidget {
  const PersonalLis({
    super.key,
    required this.e,
  });
  final TListChekPoitnsModel e;
  @override
  Widget build(BuildContext context) {
    final listaEmpleados =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados;
    //FILTRAS LOS TRUE
    final filter = listaEmpleados.where((e) => e.estado == true).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir a ${e.nombre}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  // final a = listaEmpleados[index];
                  return Divider();
                },
                itemCount: filter.length,
                itemBuilder: (context, index) {
                  final a = filter[index];
                  return ListTile(
                    onTap: () async {
                      editarDatos(context: context, a: a);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H2Text(
                              text: a.nombre,
                            ),
                            P2Text(text: a.apellidos),
                          ],
                        ),
                        GLobalImageUrlServer(
                          width: 60,
                          height: 60,
                          image: a.imagen ?? "",
                          collectionId: a.collectionId ?? '',
                          id: a.id ?? '',
                          borderRadius: BorderRadius.circular(100),
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        P2Text(text: a.cargo, textAlign: TextAlign.justify),
                        SizedBox(height: 10),
                        P2Text(
                          text: 'Telf. ${a.telefono}',
                          color: AppColors.accentColor,
                        ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> editarDatos(
      {required BuildContext context, required TEmpleadoModel a}) async {
    //Verificamso que sea diferente de null
    if (e.personal == null) {
      e.personal = [];
    }
    //Preguntamos si ya existe
    bool isExit = e.personal!.any((item) => item.id == a.id);
    print('Personal contains ${a.nombre}: $isExit');

    if (!isExit) {
      e.personal!.add(a); // Agrega el elemento a la lista
      await context.read<TListCheckPoitnsProvider>().saveProductosApp(e);
      TextToSpeechService().speak('Cambios aplicados.');
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'Desear editar este registro?',
          title: 'Guardar ; ${a.nombre}');
    } else {
      TextToSpeechService().speak('Este registro ya existe.');
    }
  }
}

class ItemInsumoList extends StatelessWidget {
  const ItemInsumoList({
    super.key,
    required this.e,
  });
  final TListChekPoitnsModel e;
  @override
  Widget build(BuildContext context) {
    final listProductos =
        Provider.of<TProductosAppProvider>(context).listProductos;
    //FILTRAS LOS TRUE
    final filter = listProductos.where((e) => e.estado == true).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir a ${e.nombre}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  // final a = listaEmpleados[index];
                  return Divider();
                },
                itemCount: filter.length,
                itemBuilder: (context, index) {
                  final a = filter[index];
                  return ListTile(
                    onTap: () async {
                      editarDatosProductos(context: context, a: a);
                    },
                    trailing: GLobalImageUrlServer(
                      width: MediaQuery.of(context).size.width * .13,
                      height: MediaQuery.of(context).size.width * .13,
                      image: (a.imagen != null && a.imagen!.isNotEmpty)
                          ? a.imagen!.first
                          : '',
                      collectionId: a.collectionId ?? '',
                      id: a.id,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    title: H2Text(
                      text: a.nombreProducto + ' (${a.unidMedida})',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        P2Text(text: a.idCategoria),
                        P2Text(text: a.marcaProducto),
                        P1Text(
                          text: '${a.moneda}  ${a.precioUnd}',
                          height: 2,
                        ),
                        H3Text(
                          text: 'STOCK: ' +
                              parseToformatearNumero(a.stock ?? 0).toString(),
                          height: 2,
                        ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> editarDatosProductos(
      {required BuildContext context, required TProductosAppModel a}) async {
    //Preguntamos si ya existe
    bool isExit = e.itemsList!.any((item) => item.id == a.id);

    if (!isExit) {
      //No existe se crea
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'Añadir como insumo?',
          title: '${a.nombreProducto}',
          child: FormAddInsumo(producto: a, checkpoint: e));
    } else {
      //Existe se edita
      TextToSpeechService().speak('Este registro ya existe.');
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'Deseas Editarlo?',
          title: '${a.nombreProducto}',
          child: FormAddInsumo(producto: a, checkpoint: e));
    }
  }
}

class FormAddInsumo extends StatefulWidget {
  const FormAddInsumo({
    super.key,
    required this.producto,
    required this.checkpoint,
  });
  final TProductosAppModel producto;
  final TListChekPoitnsModel checkpoint;

  @override
  State<FormAddInsumo> createState() => _FormAddInsumoState();
}

class _FormAddInsumoState extends State<FormAddInsumo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _stockController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _stockController.text = widget.producto.stock.toString();
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un valor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      widget.producto.stock =
                          double.parse(_stockController.text);
                    });
                    // Encuentra el producto existente y actualiza sus valores
                    final index = widget.checkpoint.itemsList!
                        .indexWhere((item) => item.id == widget.producto.id);
                    if (index != -1) {
                      widget.checkpoint.itemsList![index] = widget.producto;
                    } else {
                      // Agrega el nuevo producto a la lista
                      widget.checkpoint.itemsList!.add(widget.producto);
                    }
                    await context
                        .read<TListCheckPoitnsProvider>()
                        .saveProductosApp(widget.checkpoint);
                    TextToSpeechService().speak('Cambios aplicados.');
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
