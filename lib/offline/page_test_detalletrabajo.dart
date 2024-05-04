// ignore_for_file: use_build_context_synchronously

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chasski/models/model_t_detalle_trabajo.dart';
import 'package:chasski/offline/pdf_incidentes.dart';
import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
import 'package:chasski/provider/provider_t_detalle_trabajo.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/utils/format_fecha.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DBDetalletrabajoPage extends StatefulWidget {
  const DBDetalletrabajoPage({
    super.key,
  });

  @override
  State<DBDetalletrabajoPage> createState() => _DBDetalletrabajoPageState();
}

class _DBDetalletrabajoPageState extends State<DBDetalletrabajoPage> {
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
    _scrollController.addListener(_onScroll);
    Provider.of<DBDetalleGrupoProvider>(context, listen: false).initDatabase();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbProducto = Provider.of<DBDetalleGrupoProvider>(context);
    List<TDetalleTrabajoModel> listaSQl = dbProducto.listsql
      ..sort(
        (a, b) => a.updated!.compareTo(b.updated!),
      );
    bool issaving = dbProducto.offlineSaving;

    final dataProvider = Provider.of<TDetalleTrabajoProvider>(context);
    final listaDatos = dataProvider.listaDetallTrabajo;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/loadinLocal.png',
                          height: showAppBar ? 100 : 0),
                      H2Text(
                        text: 'Código de Grupos Operacioen Local'.toUpperCase(),
                        fontSize: 17,
                        maxLines: 2,
                        fontWeight: FontWeight.bold,
                      ),
                      const H2Text(
                        text: 'Almacenamiento local de Datos',
                        fontSize: 15,
                      ),
                      showAppBar
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await dbProducto.guardarEnSQlLite(
                                        listaDatos, context);

                                    if (issaving == false) {
                                      mostrarAlertDialog(
                                          context: context,
                                          incidencias: dbProducto
                                              .incidenciasCarga
                                            ..sort((a, b) => a.compareTo(b)),
                                          title: 'Carga de Datos');
                                    } else {}
                                  },
                                  child: Column(
                                    children: [
                                      issaving
                                          ? const SizedBox(
                                              width: 17,
                                              height: 17,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Icon(
                                              Icons.cloud_download,
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                      _labelText(label: 'Almacenar')
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () async {
                                    await dbProducto
                                        .cleartable(); //Limipar  Base de datos.;
                                  },
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        size: 50,
                                        color: Color(0xFFF03520),
                                      ),
                                      _labelText(label: 'Eliminar')
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                   LengtRegistros(listaSQl: listaSQl),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * .2,
                    ),
                    itemCount: listaSQl.length,
                    itemBuilder: (BuildContext context, int index) {
                      final e = listaSQl.reversed.toList()[index];
                      // Lógica para colorear el fondo del trailing basado en la fecha
                      DateTime hoy = DateTime.now();
                      DateTime inicio = e.fechaInicio;
                      DateTime fin = e.fechaFin;
                      DateTime hoySinHora =
                          DateTime(hoy.year, hoy.month, hoy.day);
                      DateTime inicioSinHora =
                          DateTime(inicio.year, inicio.month, inicio.day);
                      DateTime finSinHora =
                          DateTime(fin.year, fin.month, fin.day);
                      Color trailingBackgroundColor =
                          Colors.black; // Color por defecto
                      String grupoStatus = 'Codígo de Grupo';

                      if ((hoySinHora.isAfter(inicioSinHora) ||
                              hoySinHora.isAtSameMomentAs(inicioSinHora)) &&
                          (hoySinHora.isBefore(finSinHora) ||
                              hoySinHora.isAtSameMomentAs(finSinHora))) {
                        // Fecha está en rango, colorea el fondo
                        trailingBackgroundColor = Colors.red;
                        grupoStatus = 'Grupo en ruta!';
                      }
                      Color color = index % 2 == 0
                          ? const Color(0x3CE2E1E1)
                          : const Color(0xFFFFFFFF);
                      return Container(
                        color: color,
                        child: DelayedDisplay(
                          delay: const Duration(milliseconds: 400),
                          child: CardDetalleTrabajo(
                              e: e,
                              grupoStatus: grupoStatus,
                              trailingBackgroundColor: trailingBackgroundColor),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  H2Text _labelText({String? label}) {
    return H2Text(
      text: label!,
      color: Colors.black,
      fontSize: 14,
    );
  }
}

class LengtRegistros extends StatelessWidget {
  const LengtRegistros({
    super.key,
    required this.listaSQl,
  });

  final List<TDetalleTrabajoModel> listaSQl;

  @override
  Widget build(BuildContext context) {
    return Positioned(
       right: 10,
      top: 0,
      child: Column(
        children: [
          Row(
            children: [
              H2Text(
                text: '${listaSQl.length}',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              const H2Text(
                text: ' [ registros ]',
                fontSize: 10,
                color: Colors.pink,
              ),
            ],
          ),
          const OfflineSIgnalButon(),
        ],
      ),
    );
  }
}

class CardDetalleTrabajo extends StatelessWidget {
  const CardDetalleTrabajo({
    super.key,
    required this.e,
    required this.trailingBackgroundColor,
    required this.grupoStatus,
  });

  final TDetalleTrabajoModel e;
  final Color trailingBackgroundColor;
  final String grupoStatus;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Row(
        children: [
          Column(
            children: [
              H2Text(
                text: e.codigoGrupo,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: trailingBackgroundColor,
              ),
              H2Text(
                text: grupoStatus,
                fontSize: 10,
                color: trailingBackgroundColor,
              ),
            ],
          ),
          Flexible(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2Text(
                    text: 'PARTIDA   :  ${formatFecha(e.fechaInicio)}',
                    fontSize: 12,
                  ),
                  H2Text(
                    text: 'RETORNO :  ${formatFecha(e.fechaFin)}',
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.nature_sharp,
        color: e.id!.isNotEmpty ? Colors.green : Colors.red,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(e.codigoGrupo),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  H2Text(
                    text: 'id server :   ${e.id!}',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  H2Text(
                    text: 'id Local   :  ${e.idsql!}',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  e.id!.isEmpty
                      ? const H2Text(
                          text: 'Registro local\n!Sincroniza este registro!',
                          color: Colors.teal,
                          maxLines: 2,
                        )
                      : const SizedBox(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: H2Text(
                        text: e.descripcion,
                        fontSize: 12,
                        maxLines: 10,
                        color: Colors.black,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  H2Text(
                    text: 'Creado :  ${formatFechaHoraNow(e.created!)}',
                    fontSize: 12,
                  ),
                  H2Text(
                    text: 'Modificado :${formatFechaHoraNow(e.updated!)}',
                    fontSize: 12,
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
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
