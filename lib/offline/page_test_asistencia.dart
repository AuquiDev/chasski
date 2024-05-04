// // ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:chasski/models/model_t_asistencia.dart';
// import 'package:chasski/models/model_t_detalle_trabajo.dart';
// import 'package:chasski/offline/pdf_incidentes.dart';
// import 'package:chasski/provider_cache/provider_cache.dart';
// import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
// import 'package:chasski/provider/provider_sql_tasitencia.dart';
// import 'package:chasski/provider/provider_t_asistencia.dart';
// import 'package:chasski/provider/provider_t_detalle_trabajo.dart';
// import 'package:chasski/utils/custom_text.dart';
// import 'package:chasski/utils/format_fecha.dart';
// import 'package:chasski/widgets/boton_style.dart';
// import 'package:chasski/widgets/state_signal_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// class DBAsistenciaPage extends StatefulWidget {
//   const DBAsistenciaPage({
//     super.key,
//   });

//   @override
//   State<DBAsistenciaPage> createState() => _DBAsistenciaPageState();
// }

// class _DBAsistenciaPageState extends State<DBAsistenciaPage> {
//   final ScrollController _scrollController = ScrollController();
//   bool showAppBar = true;

//   void _onScroll() {
//     //devulve el valor del scrollDirection.
//     setState(() {
//       if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         //Scroll Abajo
//         showAppBar = true;
//       } else if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         //Scroll Arriba
//         showAppBar = false;
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //Scroll controller
//     _scrollController.addListener(_onScroll);
//     Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //  final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;
//     // final isSavinSQL = Provider.of<DBAsistenciaAppProvider>(context).isSyncing;
//     // final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
//     // bool isavingProvider = isOffline ? isSavinSQL : isSavingSerer;

//     final dbProducto = Provider.of<DBAsistenciaAppProvider>(context);
//     List<TAsistenciaModel> listaSQl = dbProducto.listsql
//       ..sort(
        
//         (a, b) => a.idsql!.compareTo(b.idsql!),
//       );
//     bool issavingCarga = dbProducto.offlineSaving;
//     bool isdeletCarga = dbProducto.isSyncing;
//     final dataProvider = Provider.of<TAsistenciaProvider>(context);
//     final listaDatos = dataProvider.listAsistencia;

//     // final cacheProvider = Provider.of<UsuarioProvider>(context);
//     // bool isoffline = cacheProvider.isOffline;
//       final data =Provider.of<UsuarioProvider>(context, listen: false);
//       bool isConected = data.isConnected; // Estado de Conexion a internet apra activar o desactivar botones 

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
                 
//                   Column(
//                     children: [
//                       Image.asset('assets/img/sincronizacion.png',
//                           height: showAppBar ? 100 : 0),
//                       H2Text(
//                         text: 'Control de Asistencia'.toUpperCase(),
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       const H2Text(
//                         text: 'Sincronización de Datos',
//                         fontSize: 15,
//                       ),     
//                       showAppBar
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                     onTap: () async {
//                                       await dbProducto.guardarEnSQlLite(
//                                           listaDatos, context);

//                                       if (issavingCarga == false) {
//                                         mostrarAlertDialog(
//                                             context: context,
//                                             incidencias: dbProducto
//                                                 .incidenciasCarga
//                                               ..sort((a, b) => a.compareTo(b)),
//                                             title: 'Almacenar Localmente');
//                                       } else {}
//                                     },
//                                     child: Column(
//                                       children: [
//                                         issavingCarga
//                                             ? const SizedBox(
//                                                 width: 17,
//                                                 height: 17,
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               )
//                                             : const Icon(
//                                                 Icons.cloud_download,
//                                                 size: 50,
//                                                 color: Colors.blue,
//                                               ),
//                                         _labelText(label: 'Almacenar')
//                                       ],
//                                     )),
//                                 const SizedBox(width: 30),
//                                isConected ? GestureDetector(
//                                   onTap:  () async {
//                                     await dbProducto
//                                         .syncLocalDataToServer(context);
//                                     if (dbProducto.offlineSync == false) {
//                                       mostrarAlertDialog(
//                                           context: context,
//                                           incidencias:
//                                               dbProducto.incidenciasSinc,
//                                           title: 'Sincronizar con el Servidor');
//                                     } else {}
//                                   },
//                                   child: Column(
//                                     children: [
//                                       dbProducto.offlineSync
//                                           ? const SizedBox(
//                                               width: 17,
//                                               height: 17,
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             )
//                                           : const Icon(
//                                               Icons.sync_outlined,
//                                               size: 50,
//                                               color: Color(0xFF02763E),
//                                             ),
//                                       _labelText(label: 'Sincronizar')
//                                     ],
//                                   ),
//                                 ) : Column(
//                                   children: [
//                                     const CircularProgressIndicator(),
//                                      _labelText(label: 'Sincronizar')
//                                   ],
//                                 ),
//                                 const SizedBox(width: 30),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     await dbProducto.cleartable(
//                                         true); //Limipar  Base de datos.;
//                                   },
//                                   child: Column(
//                                     children: [
//                                       isdeletCarga
//                                           ? const SizedBox(
//                                               width: 17,
//                                               height: 17,
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             )
//                                           : const Icon(
//                                               Icons.delete,
//                                               size: 50,
//                                               color: Color(0xFFF03520),
//                                             ),
//                                       _labelText(label: 'Eliminar')
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             )
//                           : const SizedBox(),
//                     ],
//                   ),
//                    LengtRegistros(listaSQl: listaSQl),
//                 ],
//               ),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   constraints: const BoxConstraints(maxWidth: 600),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           padding: EdgeInsets.only(
//                             bottom: MediaQuery.of(context).size.height * .2,
//                           ),
//                           itemCount: listaSQl.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final e = listaSQl[index];

//                             //Color intercalado
//                             Color color = index % 2 == 0
//                                 ? const Color(0x3CE2E1E1)
//                                 : const Color(0xFFFFFFFF);
//                             return Container(
//                                 color: color,
//                                 child: DelayedDisplay(
//                                     delay: const Duration(milliseconds: 400),
//                                     child: CardAsistencia(e: e)));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   H2Text _labelText({String? label}) {
//     return H2Text(
//       text: label!,
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//   }

//   void mostrarAlertDialog(
//       {BuildContext? context, List<String>? incidencias, String? title}) {
//     QuickAlert.show(
//       // autoCloseDuration: Duration(milliseconds: 300),
//       width: 300,
//       context: context!,
//       type: QuickAlertType.info,
//       title: ('Incidencias de $title'),
//       text: '${incidencias!.length} regs.',
//       widget: SingleChildScrollView(
//         child: Column(children: [
//           PDfIncidentes(
//             incidencias: incidencias,
//             title: title!,
//           )
//         ]),
//       ),
//     );
//   }
// }

// class CardAsistencia extends StatelessWidget {
//   const CardAsistencia({
//     super.key,
//     required this.e,
//   });

//   final TAsistenciaModel e;

//   @override
//   Widget build(BuildContext context) {
//     final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
//     final listaGrupoAPi =
//         Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
//     final listaGrupoSQL = Provider.of<DBDetalleGrupoProvider>(context).listsql;

//     List<TDetalleTrabajoModel> listaGrupos =
//         isOffline ? listaGrupoSQL : listaGrupoAPi;
//     String obtenerDetalleTrabajo(String idTrabajo) {
//       for (var data in listaGrupos) {
//         if (data.id == idTrabajo) {
//           return data.codigoGrupo;
//         }
//       }
//       return '-';
//     }

//     final codigo = obtenerDetalleTrabajo(e.idTrabajo);
//     return ListTile(
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [

//           H2Text(
//             text: formatFechaPDfdiaMesAno(e.horaEntrada),
//             fontSize: 10,
//             maxLines: 2,
//             textAlign: TextAlign.center,
//             color: Colors.brown,
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     H2Text(
//                       text: e.nombrePersonal,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     H2Text(
//                       text: e.actividadRol,
//                       fontSize: 12,
//                     ),
//                   ],
//                 ),
//               ),

//               OutlinedButton(
//                 style: buttonStyle2(),
//                 onPressed: null,
//                 child: FittedBox(
//                   child: H2Text(
//                     text: 'ENTRADA\n${formatFechaPDfhora(e.horaEntrada)}',
//                     fontSize: 10,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     color: Colors.brown,
//                   ),
//                 ),
//               ),
//               OutlinedButton(
//                 style: buttonStyle2(),
//                 onPressed: null,
//                 child: FittedBox(
//                   child: H2Text(
//                     text:
//                         'SALIDA\n${e.horaSalida!.year != 1998 ? formatFechaPDfhora(e.horaSalida!) : "----"}',
//                     fontSize: 10,
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     color: Colors.brown,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       trailing: Column(
//         children: [
//           Icon(
//             Icons.nature_sharp,
//             color: e.id!.isNotEmpty ? Colors.green : Colors.red,
//           ),
//           FittedBox(
//             child: H2Text(
//               text: codigo,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: (e.id!.isNotEmpty && e.id! != null)
//                   ? const Color(0xFF2BB12F)
//                   : Colors.red,
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                title: H2Text(
//                  text: e.nombrePersonal,
//                  fontSize: 15,
//                  fontWeight: FontWeight.w600,
//                  color: Colors.pink,
//                  maxLines: 2,
//                ),
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   H2Text(
//                     text: 'rol:   ${e.actividadRol}',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   H2Text(
//                     text: 'id server :   ${e.id!}',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   H2Text(
//                     text: 'id Local   :  ${e.idsql!}',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   e.id!.isEmpty
//                       ? const H2Text(
//                           text: 'Registro local\n!Sincroniza este registro!',
//                           color: Colors.teal,
//                           maxLines: 2,
//                         )
//                       : const SizedBox(), 
//                        H2Text(
//                     text: 'Creado :  ${formatFechaHoraNow(e.created!)}',
//                     fontSize: 12,
//                   ),
//                    H2Text(
//                   text: 'Modificado :${formatFechaHoraNow(e.updated!)}',
//                   fontSize: 12,
//                   maxLines: 2,
//                 ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     // Cerrar el AlertDialog
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Aceptar'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class LengtRegistros extends StatelessWidget {
//   const LengtRegistros({
//     super.key,
//     required this.listaSQl,
//   });

//   final List<TAsistenciaModel> listaSQl;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//        right: 10,
//       top: 0,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               H2Text(
//                 text: '${listaSQl.length}',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.pink,
//               ),
//               const H2Text(
//                 text: ' [ registros ]',
//                 fontSize: 10,
//                 color: Colors.pink,
//               ),
//             ],
//           ),
//           const OfflineSIgnalButon(),
//         ],
//       ),
//     );
//   }
// }
