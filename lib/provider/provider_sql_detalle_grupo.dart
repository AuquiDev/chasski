// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:chasski/models/model_t_detalle_trabajo.dart';
import 'package:chasski/sqllite/db_crud_detalletrabajo.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:chasski/widgets/assets_textapp.dart';

 class DBDetalleGrupoProvider with ChangeNotifier {
  List<TDetalleTrabajoModel> listsql = []; //LISTA para alamcenar los datos

  List<TDetalleTrabajoModel> get data => listsql;
//Intancia del Crud de asistencai DB local.
  CrudDBDetalleTrabajo crudDb = CrudDBDetalleTrabajo();


  Future<void> initDatabase() async {
    
    //Instancai de Verificacion de existencai de la BASE DE DATOS DBLOcalStorage
    await DBLocalStorage.instance.checkinDatabase();
    listsql = await crudDb.getDetalleTrabajo();
    notifyListeners();
  }

  bool isSyncing = false;

  Future<void> insertData(TDetalleTrabajoModel e) async {
    isSyncing = true;
    notifyListeners();

    await crudDb.insertarDetalleTrabajo(e);

    //SIMULACION DE CARGA
    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await initDatabase();
    // notifyListeners();
  }

  Future<void> updateData(TDetalleTrabajoModel e, int? idsql) async {
    isSyncing = true;
    notifyListeners();

    await crudDb.updateDetalleTrabajo(e, idsql);

    //SIMULACION DE CARGA
    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await initDatabase();
    // notifyListeners();
  }

  Future<void> deleteData(int idsql) async {
    await crudDb.deleteTdetalletrabajo(idsql);
    await initDatabase();
    print('Delete LOcal');
    notifyListeners();
  }

  //BORRAR TODA LA BASE DE DATOS
  Future<void> cleartable() async {
    await crudDb.clearDetalleTrabajo();
    await initDatabase();
    notifyListeners();
  }

  List<String> incidenciasCarga = [];

//METODO GUARDAR EN SQLITE
  //No t e olvides de llamarlo en el metodo get
  bool offlineSaving = false;
  Future<void> guardarEnSQlLite(
      List<TDetalleTrabajoModel> api, BuildContext context) async {
    incidenciasCarga = [];
    //  listsql;//Provider.of<DBProductoAppProvider>(context, listen: false);

    offlineSaving = true;
    notifyListeners();

    for (var e in listsql) {
      // Verificar si el producto local no está en la lista de la API
      if (!api.any((x) => x.id == e.id)) {
        //! no se encuentra en la lista !api
        //El usuario decide si elimina sus datos locales o los elminar y carga todo lo existente del servidor.
        //Esto sirve en casos de que no quieras perder datos, que se esta ntrabajndo en el servidor.
        bool eliminar = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Eliminar de Datos Locales'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2Text(
                      text: 'Hemos detectado que el producto:',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    H2Text(
                      text: '"${e.codigoGrupo} | ${e.descripcion}"',
                      maxLines: 40,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const H2Text(
                      text:
                          'Está registrado en tu base de datos local pero no en el servidor. ¿Quisieras eliminarlo y cargar los datos existentes en el servidor?',
                      maxLines: 40,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // Eliminar
                    child: const Text('Eliminar'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // Mantener locales
                    child: const Text('Mantener locales'),
                  ),
                ],
              );
            });
        if (eliminar) {
          // El producto local no está en la lista de la API, eliminarlo
          await deleteData(e.idsql!);
          incidenciasCarga.add(
              'ELIMINADO => (ID: ${e.idsql!}): "${e.codigoGrupo}" ya no existe en el servidor y ha sido eliminado localmente.');
        } else {
          print('Mantener Dstos Locales');
        }
      }
    }

    for (var e in api) {
      // Verificar si el producto ya existe en la base de datos local
      final index = listsql.indexWhere((p) => e.id == p.id);
      if (index != -1) {
        // El producto ya existe, comparar fechas de modificación
        //Si la fecha de modificaion del servidor es mas reciente que la local.
        if (e.updated!.compareTo(listsql[index].updated!) > 0) {
          // Mostrar cuadro de diálogo de confirmación
          bool overwrite = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Conflicto de Datos'),
                // content: ContentCargaDatos(
                //   listsql: listsql,
                //   index: index,
                //   e: e,
                //   comlun1: 'BDLocal',
                //   column2: 'ServidorAPI',
                content: H2Text(
                  text: 'El producto local "${listsql[index].codigoGrupo}" ha sido modificado en el servidor resientemente en el servidor por "${e.codigoGrupo}".' +
                      ' ¿Desea sobrescribirlo con los datos más recientes? Nuevo dato: ${e.codigoGrupo}.\n',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // Sobrescribir
                    child: const Text('Sobrescribir'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // Mantener locales
                    child: const Text('Mantener locales'),
                  ),
                ],
              );
            },
          );
          // La fecha de modificación es más reciente, actualizar el producto
          // Aplicar la decisión del usuario
          if (overwrite) {
            await updateData(e, listsql[index].idsql);
            incidenciasCarga.add(
                'MODIFICADO => (ID: ${listsql[index].idsql}): "${e.codigoGrupo}" ha sido actualizado debido a cambios en el servidor.');
          } else {
            incidenciasCarga.add(
                'SIN MODIFICACIÓN => (ID: ${listsql[index].idsql}): "${e.codigoGrupo}" ya existe localmente y no ha experimentado cambios.');
          }
        } else {
// Si no se detectan cambios entre el servidor y la base de datos local, no se realiza ninguna actualización.
// Aquí explicamos que es posible haber realizado modificaciones al producto localmente,
// pero esto no impacta en la carga de datos. El usuario tiene la opción de recargar los datos sin perder las modificaciones locales.
// Para ello, se verifica si el producto fue modificado localmente; en caso afirmativo, se compara la fecha de modificación con la del servidor.
// Si la fecha del servidor es más reciente, se le pregunta al usuario si desea sobrescribir ese dato con la versión del servidor.
// En caso contrario, se evita la modificación, ya que la fecha de modificación más reciente es la local.

          incidenciasCarga.add(
              'SIN MODIFICACIÓN => (ID: ${listsql[index].idsql}): "${e.codigoGrupo}" ya existe localmente y no ha experimentado cambios.');
        }
      } else {
        // El producto no existe, insertar
        await insertData(e);
        incidenciasCarga.add(
            'CREADO NUEVO: "${e.codigoGrupo}" ha sido agregado exitosamente a la base de datos local.');
      }
    }
    offlineSaving = false;
    notifyListeners();
  }
}
