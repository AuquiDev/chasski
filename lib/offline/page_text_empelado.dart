// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/offline/pdf_incidentes.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DBEmpleadoPage extends StatefulWidget {
  const DBEmpleadoPage({
    super.key,
  });

  @override
  State<DBEmpleadoPage> createState() => _DBEmpleadoPageState();
}

class _DBEmpleadoPageState extends State<DBEmpleadoPage> {
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
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
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
    final dbProducto = Provider.of<DBEMpleadoProvider>(context);
    List<TEmpleadoModel> listaSQl = dbProducto.listsql
      ..sort((a, b) => a.idsql!.compareTo(b.idsql!));
    bool issaving = dbProducto.offlineSaving;

    final dataProvider = Provider.of<TEmpleadoProvider>(context);
    final listaDatos = dataProvider.listaEmpleados;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                 
                  Column(
                    children: [
                      Image.asset('assets/img/loadinLocal.png',
                          height: showAppBar ? 100 : 0),
                      H2Text(
                        text: 'Usuarios Local'.toUpperCase(),
                        fontSize: 17,
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
                            Color color = index % 2 == 0
                                ? const Color(0x3CE2E1E1)
                                : const Color(0xFFFFFFFF);
                            return Container(
                              color: color,
                              child: DelayedDisplay(
                                delay: const Duration(milliseconds: 400),
                                child: e.rol != 'admin'
                                    ? ListTile(
                                        title: H2Text(
                                          text:
                                              'Usuario: ${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2Text(
                                              text: 'cédula :  ${e.cedula}',
                                              fontSize: 12,
                                            ),
                                            H2Text(
                                              text:
                                                  'contraseña :  ${e.contrasena}',
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                        leading: ImageEmeplado(
                                          e: e,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            );
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

class ImageEmeplado extends StatelessWidget {
  const ImageEmeplado({
    super.key,
    required this.e,
  });

  final TEmpleadoModel e;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xffF6F3EB),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.black12, width: .5)),
        height: 30,
        width: 30,
        child: CachedNetworkImage(
          imageUrl: e.imagen != null &&
                  e.imagen is String &&
                  e.imagen!.isNotEmpty
              ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons
              .error), // Widget a mostrar si hay un error al cargar la imagen
          // fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LengtRegistros extends StatelessWidget {
  const LengtRegistros({
    super.key,
    required this.listaSQl,
  });

  final List<TEmpleadoModel> listaSQl;

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
