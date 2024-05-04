// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_adjacent_string_concatenation

import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:chasski/offline/t_comparativa_list_check_points_ar.dart';
import 'package:chasski/provider/provider_t_list_check_ar.dart';
import 'package:chasski/sqllite/db_crud_list_checkpoints_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/sqllite/db_create_local_storage.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:provider/provider.dart';

class DBTListCheckPoitns_ARProvider with ChangeNotifier {
  List<TListCheckPoitns_ARModels> listsql = []; //LISTA para alamcenar los datos

  List<TListCheckPoitns_ARModels> get data => listsql;

  //Intancia del Crud de asistencai DB local.
  CrudDBListCheckPoitns crudDb = CrudDBListCheckPoitns();


  Future<void> initDatabase() async {

    //Instancai de Verificacion de existencai de la BASE DE DATOS DBLOcalStorage
    await DBLocalStorage.instance.checkinDatabase();
    
    listsql = await crudDb.getTable();
    notifyListeners();
  }
  bool isSyncing = false;
  
  Future<void> insertData(TListCheckPoitns_ARModels e,bool loading) async {
    isSyncing = true;
    notifyListeners();

    await crudDb.insertarProductos(e);

    //SIMULACION DE CARGA: PREGUNTAMOS SI QUIERE QUE CARGUE SINO NULL
     loading ? await Future.delayed(const Duration(seconds: 2)) : null;
    isSyncing = false;
    notifyListeners();
    await initDatabase();
    // notifyListeners();
  }

  Future<void> updateData(TListCheckPoitns_ARModels e, int? idsql, bool loading) async {
    isSyncing = true;
    notifyListeners();

    await crudDb.updateTable(e, idsql);

    //SIMULACION DE CARGA: PREGUNTAMOS SI QUIERE QUE CARGUE SINO NULL
   loading ? await Future.delayed(const Duration(seconds: 2)) : null;
    isSyncing = false;
    notifyListeners();
    await initDatabase();
    // notifyListeners();
  }

  Future<void> deleteData(int idsql, bool loading ) async {
     isSyncing = true;
    notifyListeners();

    await crudDb.deleteTable(idsql);
    //SIMULACION DE CARGA: PREGUNTAMOS SI QUIERE QUE CARGUE SINO NULL
   loading ? await Future.delayed(const Duration(seconds: 2)) : null;
     isSyncing = false;
    notifyListeners();
    await initDatabase();
    print('Delete LOcal');
    notifyListeners();
  }
  
  //BORRAR TODA LA BASE DE DATOS
  Future<void> cleartable( bool loading) async {
     isSyncing = true;
    notifyListeners();

    await crudDb.clearDataBase();
     //SIMULACION DE CARGA: PREGUNTAMOS SI QUIERE QUE CARGUE SINO NULL
   loading ? await Future.delayed(const Duration(seconds: 2)) : null;
   
     isSyncing = false;
    notifyListeners();

    await initDatabase();
    notifyListeners();
  }

  List<String> incidenciasCarga = [];

//METODO GUARDAR EN SQLITE
  //No t e olvides de llamarlo en el metodo get
  bool offlineSaving = false;
  Future<void> guardarEnSQlLite( List<TListCheckPoitns_ARModels> api, BuildContext context) async {
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
                      text:
                          '"${e.nombre} | ${e.ubicacion}"',
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
          await deleteData(e.idsql!, false);
          incidenciasCarga.add(
              'ELIMINADO => (ID: ${e.idsql!}): "${e.nombre}" ya no existe en el servidor y ha sido eliminado localmente.');
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
                content: ContentCargaDatosListCheckpoints(
                  listsql: listsql,
                  index: index,
                  e: e,
                  comlun1: 'BDLocal',
                  column2: 'ServidorAPI',
                  text: 'El producto local "${listsql[index].nombre}" ha sido modificado en el servidor resientemente en el servidor por "${e.nombre}".' +
                      ' ¿Desea sobrescribirlo con los datos más recientes? Nuevo dato: ${e.nombre}.\n',
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
            await updateData(e, listsql[index].idsql, false);
            incidenciasCarga.add(
                'MODIFICADO => (ID: ${listsql[index].idsql}): "${e.nombre}" ha sido actualizado debido a cambios en el servidor.');
          } else {
            incidenciasCarga.add(
                'SIN MODIFICACIÓN => (ID: ${listsql[index].idsql}): "${e.nombre}" ya existe localmente y no ha experimentado cambios.');
          }
        } else {
// Si no se detectan cambios entre el servidor y la base de datos local, no se realiza ninguna actualización.
// Aquí explicamos que es posible haber realizado modificaciones al producto localmente,
// pero esto no impacta en la carga de datos. El usuario tiene la opción de recargar los datos sin perder las modificaciones locales.
// Para ello, se verifica si el producto fue modificado localmente; en caso afirmativo, se compara la fecha de modificación con la del servidor.
// Si la fecha del servidor es más reciente, se le pregunta al usuario si desea sobrescribir ese dato con la versión del servidor.
// En caso contrario, se evita la modificación, ya que la fecha de modificación más reciente es la local.

          incidenciasCarga.add(
              'SIN MODIFICACIÓN => (ID: ${listsql[index].idsql}): "${e.nombre}" ya existe localmente y no ha experimentado cambios.');
        }
      } else {
        // El producto no existe, insertar
        await insertData(e, false);
        incidenciasCarga.add(
            'CREADO NUEVO: "${e.nombre}" ha sido agregado exitosamente a la base de datos local.');
      }
    }
    offlineSaving = false;
    notifyListeners();
  }

  List<String> incidenciasSinc = []; //incidencias de SIncronizacion
//METODO SINCRONIZACION OFFLINE
  bool offlineSync = false;
  // Método para sincronizar datos locales con el servidor
  Future<void> syncLocalDataToServer(BuildContext context) async {
    incidenciasSinc = [];

    final dataProvider =
        Provider.of<TListCheckPoitns_ARProvider>(context, listen: false);
    List<TListCheckPoitns_ARModels> listaApi = dataProvider.listAsistencia;
    offlineSync = true;
    notifyListeners();

    for (var e in listsql) {
      // Verificar si el producto ya existe en la listaApi
      if (listaApi.any((p) => p.id == e.id)) {
        // Solo realiza la acción si el producto local existe en la listaApi
        final index = listaApi.indexWhere((q) => q.id == e.id);

        if (index != -1 && index < listsql.length) {
          // Verificar si el producto local ha sido modificado
          if (e.updated!.compareTo(listaApi[index].updated!) > 0) {
            //Modificaion es mas reciente en local e.updated que listaApi[index].updated!)
            //Comparamos las fechas, si al fecha de modificacion local es ma reciente que la fecha del servidor, entocnes representa un conflicto,
            //Por lo tanto esta opcion se deja a desicion del usuario. El usuario nesecitara realizar una revisio manual de los datos.
            // Mostrar cuadro de diálogo de confirmación: desición del usuario

            bool overwrite = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Conflicto de Datos'),
                  //  content: ContentCargaDatos(listsql: listsql, index: index, e: e),
                  content: ContentCargaDatosListCheckpoints(
                    listsql: listaApi, //listsql,
                    index: index,
                    e: e, //listaApi[index],
                    column2: 'BDLocal',
                    comlun1: 'ServidorAPI',
                    text: 'El producto  "${listaApi[index].nombre}" ha sido modificado localmente a "${e.nombre}"' +
                        '  . ¿Desea sincronizar y actualizar el nuevo valor "${e.nombre}" ? Se guardarán los cambios en el servidor.',
                  ),
                  // Text('El producto local "${e.nombreProducto}" ha sido modificado localmente. ¿Desea sincronizar y actualizar el dato del servidor "${listaApi[index].nombreProducto}" con este nuevo valor? Se guardarán los cambios en el servidor.',),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Sobrescribir
                      child: const Text('Sobrescribir Server'),
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
            if (overwrite) {
              //Enviar al servidor
              await dataProvider.saveProductosApp(e); //UPDATE xq envia ID
              incidenciasSinc.add(
                  'MODIFICADO : ${e.nombre} : ID ${e.id}, ha sido modificado localmente. La fecha de modificación local es más reciente que la registrada en el servidor.');
            } else {
              incidenciasSinc.add(
                  'SIN MODIFICACIÓN: ${e.nombre} no ha sufrido cambios. No se sincroniza. Desición del usuario');
            }
          } else {
            // Las fechas de modificación son iguales, no se han realizado cambios, omitir la sincronización
            // Puedes agregar aquí cualquier lógica adicional según tus requisitos

            incidenciasSinc.add(
                'SIN MODIFICACIÓN: ${e.nombre} no ha sufrido cambios. No se sincroniza. Posibles casos, hay una motificación mas reciente en el servidor.');
          }
        } else {
          // Manejar el caso donde el índice no es válido (por ejemplo, producto no encontrado en listaApi)
          //Esta accion no se activa, ya se probo modiifcar una dato del servidor,
          //Se activa cuando la lista de elementos local es mucho mas pequeña que la lista del api
          //Siempre genera un update xq el porducto tiene Id pero no esta dentro del rango del index

          //Buscamos el Producto
          // TProductosAppModel productoEnListaApi = listaApi.firstWhere((k) => k.id == e.id );
          // print('${productoEnListaApi.id!} => API ${productoEnListaApi.updated!.subtract(Duration(hours: 5))}');
          // print('${e.id!} => SQL ${e.updated!}');
          //Un porblema que esta sucediendo es que si este producto se sincroniza en el servidor, se guarda como un post, pero a la siguiente ves 
          //se hara un update, otro problema es cuando se hace una modiciacion en el servidor y sincronzias desde aqui, el producto local sobreescribiara la modificacion del setvidor 
          //eso no deeria pasar, al contrario deberia alertar e indicar al usuario que en el servidor se hicieron modificaicones recientemente, pregubtarle
          // si desea sobreescribir estos datos. 
          //!trabajar aqui desicion del suusario : Cuando la lisat local es mas pequeña que la del servidor se activa.
          await dataProvider.saveProductosApp(e); //UPDATE xq no tien ID
              incidenciasSinc.add(
                'INDICE NO VALIDO ${e.nombre} : ID ${e.id} ENVIADO AL SERVIDOR, MODIFICADO=> Posible discrepancia entre el servidor y la base de datos local debido a diferencias en la cantidad de elementos.',
              );
              print('INDICE NO VALIDO ');
        }
      } else {
        //Si el producto no existe en el servidor deberia crearlo y asignarle el id a lproducto localy al del servidor..
        //CREAR PRODUCRTO no encontrado en el servidor.
        //AQUI TAMBIEN DEBERIAMOS verificar si el producto ha sido elimnado del
        //servidor y al enviar los datos de la base de datos local lo volveriamos a crear, debemos idear algo para eso
        //Condicional para crear
        if (e.id == '') {
          // Antes de crear el producto, verificamos si ya existe en el servidor.

          //Si el porducto no existe en lista API y no tiene id, entonces es un nuevo porducto
          await dataProvider.saveProductosApp(e); //POST xq no tien ID
          // Buscamos el producto en la listaApi por sus atributos únicos.
          TListCheckPoitns_ARModels productoEnListaApi = listaApi.firstWhere(
            (k) =>
                // k.idEmpleados == e.idEmpleados &&
                // k.idTrabajo == e.idTrabajo &&
                k.nombre == e.nombre && 
                k.ubicacion == e.ubicacion// && 
                // k.horaEntrada == e.horaEntrada && 
                // k.horaSalida == e.horaSalida 
            // orElse: () => null,
          );
          // ignore: unnecessary_null_comparison
          if (productoEnListaApi != null) {
            // Asignamos el nuevo ID al producto localmente.
            e.id = productoEnListaApi.id;
            await updateData(e, e.idsql, false); //Modificamos
            incidenciasSinc.add('ENVIADO AL SERVIDOR => ${e.nombre} : ID ${e.id} => PRODUCTO CREADO EN LOCAlMENTE. Enviado con exito Al servidor.');
          } else {
            // El producto no se encontró en la listaApi, maneja según tus requisitos.
            incidenciasSinc.add(
                'ERROR => ${e.nombre} : El producto no se encontró en la listaApi después de guardarlo en el servidor. Verifica la integridad de tus datos.');
          }

          print('LOcal Crate');
        } else {
          //!trabajar aqui desicion del suusario 
          //caso contrario si el producto si tiene ID pero no existe en la lista API,
          //lo mas seguro es que haya sido eliminado del servidor, y ya no requiere volverlo a crear, aunque se debe analizarbien este caso.
          //Por lo tanto, si usted a creado.
          //Evaluar esta parte y ver si el producto local tiene ID pero no existe en el servidor, entonces se deberia evaluar si el producto debe serguir existiendo.
          //en este caso se asume que si el producto tiene id es xq si existio en el servidor pero lo elimnaron, entonces
          //no tiene sentido sincronizar un producto local que ya ha sido eliminado, en esa caso se borra autometicamente el dato local.
          //aqui se debe evaluar si el producto se conserva o se elimina. Podriamos dejarlo a eleccion del usuario. 
          await deleteData(e.idsql!, false);
          incidenciasSinc.add(
              'ELIMINADO LOCALMENTE => ${e.nombre} : ID ${e.id} => Producto eliminado en el servidor. No es necesario recrearlo. Se elimino en localmente tambien.');
        }
      }
    }
    offlineSync = false;
    notifyListeners();
  }
}
