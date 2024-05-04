// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:flutter/material.dart';
import 'package:chasski/models/model_t_asistencia.dart';
import 'package:chasski/models/model_t_detalle_trabajo.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/provider/provider_t_asistencia.dart';
import 'package:chasski/provider/provider_t_detalle_trabajo.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/utils/format_fecha.dart';
import 'package:provider/provider.dart';

class DetailsAsistencia extends StatefulWidget {
  const DetailsAsistencia({
    super.key,
    required this.e,
  });
  final TAsistenciaModel e;

  @override
  State<DetailsAsistencia> createState() => _DetailsAsistenciaState();
}

class _DetailsAsistenciaState extends State<DetailsAsistencia> {
  @override
  Widget build(BuildContext context) {
    final lisDetalleTrabajo =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
    TDetalleTrabajoModel obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in lisDetalleTrabajo) {
        if (data.id == widget.e.idTrabajo) {
          return data;
        }
      }
      return TDetalleTrabajoModel(
          codigoGrupo: '',
          idRestriccionAlimentos: '',
          idCantidadPaxguia: '',
          idItinerariodiasnoches: '',
          idTipogasto: '',
          fechaInicio: DateTime.now(),
          fechaFin: DateTime.now(),
          descripcion: '',
          costoAsociados: 0);
    }

    final v = obtenerDetalleTrabajo(widget.e.idTrabajo);

    final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;
    final isSavinSQL = Provider.of<DBAsistenciaAppProvider>(context).isSyncing;
    final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
    bool isavingProvider = isOffline ? isSavinSQL : isSavingSerer;
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: isavingProvider
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const OfflineSIgnalButon(),
                      H2Text(
                        text: 'Grupo:  ${v.codigoGrupo}',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      FittedBox(
                        child: H2Text(
                          text:
                              '${widget.e.nombrePersonal} | ${widget.e.actividadRol}',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: ListTile(
                          title: Column(
                            children: [
                              Image.asset(
                                'assets/img/andeanlodges.png',
                                width: 150,
                              ),
                              const H2Text(text: 'Detalles de la Asistencia'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: null,
                                      child: FittedBox(
                                        child: H2Text(
                                          text:
                                              'HORA ENTRADA\n${formatFechaHoraNow(widget.e.horaEntrada)}',
                                          fontSize: 10,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(),
                                  Flexible(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: null,
                                      child: FittedBox(
                                        child: H2Text(
                                          text:
                                              'HORA SALIDA\n${widget.e.horaSalida!.year != 1998 ? formatFechaHoraNow(widget.e.horaSalida!) : "No registrado"}',
                                          fontSize: 10,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              H2Text(
                                text:
                                    'Detalles:  ${widget.e.detalles.isNotEmpty ? widget.e.detalles : 'no se ha registrado detalles de asistencia.'}',
                                fontSize: 12,
                                maxLines: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          bool confirmDelete = await _confirmDelete(context);
                          if (confirmDelete) {
                            Navigator.pop(context);
                          } else {
                            print('No Elimiando');
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const H2Text(
                          text: '¿Desea eliminar este registro?',
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final isOffline =
        Provider.of<UsuarioProvider>(context, listen: false).isOffline;

    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                isOffline
                    ? await context
                        .read<DBAsistenciaAppProvider>()
                        .deleteData(widget.e.idsql!, true)
                    : await context
                        .read<TAsistenciaProvider>()
                        .deleteTAsistenciaApp(
                          widget.e.id!,
                        );
                Navigator.of(context).pop(true);
                snackDelete(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return result;
  }

  void snackDelete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: H2Text(
          text:
              '✅ Registro eliminado exitosamente. Vuelve a la página anterior para visualizar los cambios.',
          maxLines: 3,
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
