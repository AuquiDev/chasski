// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:chasski/models/model_check_points.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_03.dart';
import 'package:chasski/provider/provider_t_checkp_ar_03.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chasski/offline/pdf_incidentes.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/utils/format_fecha.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DBCheckPoints03Page extends StatefulWidget {
  const DBCheckPoints03Page({
    super.key,
    required this.nombre
  });
 final String nombre;

  @override
  State<DBCheckPoints03Page> createState() => _DBCheckPoints03PageState();
}

class _DBCheckPoints03PageState extends State<DBCheckPoints03Page> {
  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;

  void _onScroll() {
    //devulve el valor del scrollDirection.
    setState(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //Scroll Arriba
        showAppBar = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //Scroll controller
    _scrollController.addListener(_onScroll);
    Provider.of<DBCheckPointsAppProviderAr03>(context, listen: false).initDatabase();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;
    // final isSavinSQL = Provider.of<DBAsistenciaAppProvider>(context).isSyncing;
    // final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
    // bool isavingProvider = isOffline ? isSavinSQL : isSavingSerer;

    final dbProducto = Provider.of<DBCheckPointsAppProviderAr03>(context);
    List<TCheckPointsModel> listaSQl = dbProducto.listsql
      ..sort(
        (a, b) => a.idsql!.compareTo(b.idsql!),
      );
    bool issavingCarga = dbProducto.offlineSaving;
    bool isdeletCarga = dbProducto.isSyncing;
    final dataProvider = Provider.of<TCheckP03Provider>(context);
    final listaDatos = dataProvider.listAsistencia;

    // final cacheProvider = Provider.of<UsuarioProvider>(context);
    // bool isoffline = cacheProvider.isOffline;
    final data = Provider.of<UsuarioProvider>(context, listen: false);
    bool isConected = data
        .isConnected; // Estado de Conexion a internet apra activar o desactivar botones

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      H2Text(
                            text: widget.nombre,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          H2Text(
                            text: 'CHECK POINT - PUNTO 3 ',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          SizedBox(),
                          Row(
                            children: [
                              H2Text(
                                text: '${listaSQl.length}',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              const H2Text(
                                text: ' registros.',
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                      showAppBar
                          ? DelayedDisplay(
                              delay: const Duration(milliseconds: 200),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/img/sincronizacion.png',
                                    height: 80,
                                  ),
                                  Card(
                                    color: Colors.black,
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 300),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                await dbProducto
                                                    .guardarEnSQlLite(
                                                        listaDatos, context);

                                                if (issavingCarga == false) {
                                                  mostrarAlertDialog(
                                                      context: context,
                                                      incidencias: dbProducto
                                                          .incidenciasCarga
                                                        ..sort((a, b) =>
                                                            a.compareTo(b)),
                                                      title:
                                                          'Almacenar Localmente');
                                                } else {}
                                              },
                                              child: Column(
                                                children: [
                                                  issavingCarga
                                                      ? const SizedBox(
                                                          width: 17,
                                                          height: 17,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : const Icon(
                                                          Icons.cloud_download,
                                                          size: 30,
                                                          color: Colors.teal,
                                                        ),
                                                  _labelText(label: 'Almacenar')
                                                ],
                                              )),
                                          const SizedBox(width: 30),
                                          isConected
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    await dbProducto
                                                        .syncLocalDataToServer(
                                                            context);
                                                    if (dbProducto
                                                            .offlineSync ==
                                                        false) {
                                                      mostrarAlertDialog(
                                                          context: context,
                                                          incidencias: dbProducto
                                                              .incidenciasSinc,
                                                          title:
                                                              'Sincronizar con el Servidor');
                                                    } else {}
                                                  },
                                                  child: Column(
                                                    children: [
                                                      dbProducto.offlineSync
                                                          ? const SizedBox(
                                                              width: 17,
                                                              height: 17,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .sync_outlined,
                                                              size: 30,
                                                              color: Color(
                                                                  0xFF02763E),
                                                            ),
                                                      _labelText(
                                                          label: 'Sincronizar')
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    const CircularProgressIndicator(),
                                                    _labelText(
                                                        label: 'Sincronizar')
                                                  ],
                                                ),
                                          const SizedBox(width: 30),
                                          GestureDetector(
                                            onTap: () async {
                                              await dbProducto.cleartable(
                                                  true); //Limipar  Base de datos.;
                                            },
                                            child: Column(
                                              children: [
                                                isdeletCarga
                                                    ? const SizedBox(
                                                        width: 17,
                                                        height: 17,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : const Icon(
                                                        Icons.delete,
                                                        size: 30,
                                                        color:
                                                            Color(0xFFF03520),
                                                      ),
                                                _labelText(label: 'Eliminar')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * .2,
                          ),
                          itemCount: listaSQl.length,
                          itemBuilder: (BuildContext context, int index) {
                            final e = listaSQl[index];

                            //Color intercalado
                            Color color = index % 2 == 0
                                ? const Color(0x3CE2E1E1)
                                : Color.fromARGB(126, 255, 255, 255);
                            return Card(
                                color: color,
                                child: DelayedDisplay(
                                    delay: const Duration(milliseconds: 200),
                                    child: CardAsistencia(e: e)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  H2Text _labelText({String? label}) {
    return H2Text(
      text: label!,
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      fontSize: 13,
    );
  }

  void mostrarAlertDialog(
      {BuildContext? context, List<String>? incidencias, String? title}) {
    QuickAlert.show(
      // autoCloseDuration: Duration(milliseconds: 300),
      width: 300,
      context: context!,
      type: QuickAlertType.info,
      title: ('Incidencias de $title'),
      text: '${incidencias!.length} regs.',
      widget: SingleChildScrollView(
        child: Column(children: [
          PDfIncidentes(
            incidencias: incidencias,
            title: title!,
          )
        ]),
      ),
    );
  }
}

class CardAsistencia extends StatelessWidget {
  const CardAsistencia({
    super.key,
    required this.e,
  });

  final TCheckPointsModel e;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H2Text(
                      text: e.nombre,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    H2Text(
                      text: e.dorsal,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    H2Text(
                      text:
                          '${e.fecha.year != 1998 ? formatFechaPDfhora(e.fecha) : "----"}',
                      fontSize: 14,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                    H2Text(
                      text: formatFecha(e.fecha),
                      fontSize: 10,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Icon(
        Icons.sync_outlined,
        size: 20,
        color: e.id!.isNotEmpty ? Colors.green : Colors.red,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  H2Text(
                    text: e.nombre,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                   H2Text(
                    text: 'DORSAL:   ${e.dorsal}',
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  e.id!.isEmpty
                      ? const H2Text(
                      text: 'Este registro solo está almacenado localmente en tu celular. ¡Sincronízalo ahora para que todos puedan verlo!',
                          color: Colors.blue,
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                          fontSize: 16,
                        )
                      : const SizedBox(),
                
                   H2Text(
                    text: 'ID:   ${e.id!}',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  H2Text(
                    text: 'IDSQL:  ${e.idsql!}',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              actions: [
                  H2Text(
                    text: 'CREATE :  ${formatFechaHoraNow(e.created!)}',
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                  H2Text(
                    text: 'UPDATE :${formatFechaHoraNow(e.updated!)}',
                    fontSize: 12,
                    maxLines: 2,
                    color: Colors.black45,
                  ),
                TextButton(
                  onPressed: () {
                    // Cerrar el AlertDialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
