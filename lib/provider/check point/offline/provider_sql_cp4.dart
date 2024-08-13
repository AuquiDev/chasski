// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_adjacent_string_concatenation

import 'dart:typed_data';

import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:chasski/audit%20fielt/field_compare_chekp.dart';
import 'package:chasski/provider/check%20point/online/provider_cp04.dart';
import 'package:chasski/sqllite/crud%20check%20point/db_crud_check_ar_p04.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/sqllite/bd%20created/db___create_data_base.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DBChPProvider04 with ChangeNotifier {
  List<TCheckPointsModel> listsql = []; //LISTA para alamcenar los datos

  List<TCheckPointsModel> get data => listsql;

  //Intancia del Crud de asistencai DB local.
  CrudDBCheckPointsAR04 crudDb = CrudDBCheckPointsAR04();

  //GET
  //TODOS esto se incia en el init estate de la pagina que se va llamar.
  Future<void> initDatabase() async {
    //Instancai de Verificacion de existencai de la BASE DE DATOS DBLOcalStorage
    await DBLocalStorage.instance.checkinDatabase();
    listsql = await crudDb.getTable();
    notifyListeners();
  }

  //TODOS CLASIFICACION DE DATOS
  Map<String, List<TCheckPointsModel>> groupByDistance(
      {required List<TCheckPointsModel> listParticipantes,
      required String filename}) {
    Map<String, List<TCheckPointsModel>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estado);
          break;
        case 'idCheckPoints':
          value = getField(e.idCheckPoints);
          break;
        case 'Hora marcación':
          value = formatDateTimeForGrouping(e.fecha);
          break;
        case 'updated':
          value = formatDateTimeForGrouping(e.updated!);
          break;   
        case 'created':
          value = formatDateTimeForGrouping(e.created!);
          break;
        default:
          value = 'Todos';
      }
      if (!groupedData.containsKey(value)) {
        groupedData[value] = [];
      }
      groupedData[value]?.add(e);
    } // Ordenar las claves y sus listas
    final sortedGroupedData = Map.fromEntries(groupedData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)) // Ordenar por claves
        );
    return sortedGroupedData;
  }

  //SEARCH FILE
  List<TCheckPointsModel> _filteredData = [];
  String _searchText = '';

  List<TCheckPointsModel> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TCheckPointsModel> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombre
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.dorsal
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase())
         )
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TCheckPointsModel> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }


  bool isInsert = false;
  //INSERT
  Future<void> insertData(TCheckPointsModel e) async {
    isInsert = true;
    notifyListeners();

    try {
      await crudDb.insertarProductos(e).timeout(Duration(seconds: 20));
    } catch (e) {
      print(e);
    } finally {
      isInsert = false;
      notifyListeners();
    }
    await initDatabase();
  }


  bool isUpdate = false;
  //MODIIFCAR
  Future<void> updateData(TCheckPointsModel e, int? idsql) async {
    isUpdate = true;
    notifyListeners();
    try {
      await crudDb.updateTable(e, idsql!).timeout(Duration(seconds: 20));
    } catch (e) {
      print(e);
    } finally {
      isUpdate = false;
      notifyListeners();
    }
    await initDatabase();
  }

  bool isDelete = false;
  //DELETE
  Future<void> deleteData(int idsql) async {
    isDelete = true;
    notifyListeners();
    try {
      await crudDb.deleteTable(idsql).timeout(Duration(seconds: 20));
    } catch (e) {
      print(e);
    } finally {
      isDelete = false;
      notifyListeners();
    }
    await initDatabase();
  }

  
  bool isClearnAll = false;
  //BORRAR ALL
  Future<void> cleartable() async {
    isClearnAll = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 1));
      await crudDb.clearDataBase().timeout(Duration(minutes: 3));
      toBeOmited.clear();
      toBeUpdate.clear();
      toBeCreated.clear();
      toBeDeleted.clear();
      tolocalExist.clear();
       TextToSpeechService().speak('Se han eliminado los datos locales.');
    } catch (e) {
      print(e);
    } finally {
      isClearnAll = false;
      notifyListeners();
    }
    await initDatabase();
  }


//TODOS LISTAS ALMACENAN SINCRONIZACION
// Lista para elementos que deben ser eliminados de listRunner
  List<TCheckPointsModel> toBeOmited = []; //sin accion
  List<TCheckPointsModel> toBeUpdate = [];
  List<TCheckPointsModel> toBeCreated = [];
  List<TCheckPointsModel> toBeDeleted = [];
  List<TCheckPointsModel> tolocalExist = []; //Solo existe localmente




// Método para guardar datos en SQLite
// No te olvides de llamarlo en el método get
bool offlineSaving = false;

Future<void> guardarEnSQlLite({
  required List<TCheckPointsModel> listServer,
  required BuildContext context,
  required ScreenshotController screenshotController,
}) async {
  // Limpiamos las listas temporales
  toBeOmited.clear();
  toBeUpdate.clear();
  toBeCreated.clear();
  toBeDeleted.clear();
  tolocalExist.clear();

  // Indicamos que estamos guardando datos offline
  offlineSaving = true;
  notifyListeners();

  // Iteramos sobre la lista de datos locales
  for (var runnerSQL in listsql) {
    // Verificamos si el dato local existe en la lista del servidor
    bool existInRunner = listServer.any((runner) => runner.id == runnerSQL.id);
    // Obtenemos la posición del dato en la lista del servidor
    final index = listServer.indexWhere((runner) => runner.id == runnerSQL.id);
    // Si el dato local no existe en el servidor
    if (!existInRunner) {
      // Mostramos un diálogo para que el usuario elija eliminar o mantener el dato local
      bool eliminar = await showDialog(
        context: context,
        builder: (BuildContext context) {
           TextToSpeechService().speak(
                    'Este registro solo existe en tu teléfono.' +
                        'Si no tiene ID, se recomienda sincronizarlo con el servidor. Si tiene ID, es mejor eliminarlo.');
              
          return AssetAlertDialogPlatform(
            title: 'Eliminar Datos Locales',
            message: 'Este registro solo existe en tu teléfono. ¿Deseas eliminarlo y cargar los datos del servidor?',
            child: contentDialog(
              context: context,
              index: index,
              runnerSQL: runnerSQL,
              runneServer: (index != -1) ? listServer[index] : runnerSQL,
              textBottonIsTrue: 'Eliminar',
              textBottonIsFalse: 'Mantener',
            ),
          );
        },
      ) ?? false;

      if (eliminar) {
        // Añadimos el dato a la lista de eliminados y lo eliminamos de la base de datos local
        toBeDeleted.add(runnerSQL);
        await Future.delayed(Duration(seconds: 1));
        await deleteData(runnerSQL.idsql!);
      } else {
        // Añadimos el dato a la lista de datos que solo existen localmente
        tolocalExist.add(runnerSQL);
        print('Solo existe en tu celular');
      }
    }
  }

  // Verificamos si los datos del servidor ya existen en la base de datos local
  for (var runneServer in listServer) {
    // Obtenemos la posición del dato en la lista local
    final index = listsql.indexWhere((runnerSQL) => runneServer.id == runnerSQL.id);
    bool indexValido = (index != -1);
    if (indexValido) {
      final runnerSQL = listsql[index];
      // Comparamos si el dato ha sido modificado
      bool isModifiServer = isComratedField(X: runnerSQL, Y: runneServer);

      if (isModifiServer) {
        // Mostramos un diálogo para que el usuario elija sobrescribir o no el dato local
        bool overwrite = await showDialog(
          context: context,
          builder: (BuildContext context) {
               TextToSpeechService().speak(
                      'Registro modificado en el servidor. ¿Deseas actualizar la información local más reciente?');
             
            return AssetAlertDialogPlatform(
              title: 'Actualizar Datos Locales',
              message: 'Este registro ha sido modificado en el servidor. ¿Deseas actualizar los datos locales con la información más reciente?',
              child: contentDialog(
                context: context,
                index: index,
                runnerSQL: listsql[index],
                runneServer: runneServer,
                textBottonIsTrue: 'Actualizar',
                textBottonIsFalse: 'Omitir',
              ),
            );
          },
        ) ?? false;

        if (overwrite) {
          // Si el usuario elige actualizar, añadimos el dato a la lista de actualizados y lo actualizamos en la base de datos local
          if (!toBeUpdate.contains(runnerSQL)) {
            toBeUpdate.add(runnerSQL);
            await updateData(runneServer, runnerSQL.idsql);
          } else {
            print('Ya está en omitidos');
          }
        } else {
          // Si el usuario elige omitir, añadimos el dato a la lista de omitidos
          if (!toBeOmited.contains(runnerSQL)) {
            toBeOmited.add(runnerSQL);
          } else {
            print('Ya está en omitidos');
          }
        }
      } else {
        // Si no hay cambios, añadimos el dato a la lista de omitidos
        if (!toBeOmited.contains(runnerSQL)) {
          toBeOmited.add(runnerSQL);
        } else {
          print('Ya está en omitidos');
        }
      }
    } else {
      // Si el dato no existe en la base de datos local, lo añadimos
      if (!toBeUpdate.contains(runneServer)) {
        toBeCreated.add(runneServer);
        await insertData(runneServer);
      } else {
        print('Ya está en creado');
      }
    }
  }

  // Capturar una imagen del widget actual
     await WidgetsBinding.instance.endOfFrame;//Asegúrate de que el Widget esté Completamente Renderizado:
   try {
      await captureWidget(screenshotController: screenshotController)
          .timeout(Duration(seconds: 5)); // Aumentar el tiempo de espera
    } catch (e) {
      print('Error al capturar el widget: $e');
    }
    await Future.delayed(Duration(seconds: 2));
    offlineSaving = false; // Indicar que la sincronización ha terminado
     TextToSpeechService().speak(
        'La descarga ha finalizado. Los datos se han guardado en tu almacenamiento local.');
    notifyListeners(); // Notificar a los oyentes del cambio de estado
  }







  bool offlineSync =
      false; // Variable para indicar si la sincronización está en curso
  int lotesSize = 100; // Tamaño del lote para la sincronización
  String progreesLotes = '';
  
  Future<void> syncLocalDataToServer({
    required BuildContext
        context, // Contexto de la aplicación para acceder a proveedores y mostrar diálogos
    required ScreenshotController
        screenshotController, // Controlador de captura de pantalla
  }) async {
      TextToSpeechService().speak('Sincronización iniciada.');
    final dataProvider =
        Provider.of<TCheckP04Provider>(context, listen: false);
    List<TCheckPointsModel> listServer = dataProvider.listAsistencia;

    // Limpiar las listas que se usarán para almacenar resultados de la sincronización
    toBeOmited.clear();
    toBeUpdate.clear();
    toBeCreated.clear();
    toBeDeleted.clear();
    tolocalExist.clear();

    offlineSync = true; // Indicar que la sincronización ha comenzado
    notifyListeners(); // Notificar a los oyentes del cambio de estado

    // Dividir la lista de datos locales (listsql) en lotes
    final batches = _chunkList(listsql, lotesSize);
    int batchNumber = 0; // Variable para contar el número de lote actual
    for (var batch in batches) {
      batchNumber++; // Incrementar el número de lote
      String message =
          'Procesando lote número $batchNumber de ${batches.length}';
      // Mostrar el número de lote actual
      progreesLotes = (message);
      TextToSpeechService().speak(message);
      // Procesar cada lote
      await _processBatchSync(batch, dataProvider, listServer, context);
      // Introducir un tiempo de espera si es necesario
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 500));
    }

   // Capturar una imagen del widget actual
     await WidgetsBinding.instance.endOfFrame;//Asegúrate de que el Widget esté Completamente Renderizado:
   try {
      await captureWidget(screenshotController: screenshotController)
          .timeout(Duration(seconds: 5)); // Aumentar el tiempo de espera
    } catch (e) {
      print('Error al capturar el widget: $e');
    }
    await Future.delayed(Duration(seconds: 2));
    offlineSync = false; // Indicar que la sincronización ha terminado
    notifyListeners(); // Notificar a los oyentes del cambio de estado
  }





// Método para procesar cada lote de datos
  Future<void> _processBatchSync(
    List<TCheckPointsModel> batch,
    TCheckP04Provider dataProvider,
    List<TCheckPointsModel> listServer,
    BuildContext context,
  ) async {
    for (var runnerSQL in batch) {
      //TODOS EL error aqui es buscar id de registro ya que no, se buscara y encontrara el elemnto pero po id
      //eso no basta ya que solobuscara un registro con el id que ocincia, 
      //lo que se requiere es verificar si un corredor ya esta regitrado en esa lista 
      // final index = listServer.indexWhere((runner) => runner.id == runnerSQL.id);
      //CORREGIDO 
      final index = listServer.indexWhere((runner) => runner.idCorredor == runnerSQL.idCorredor);
      bool existsInServer = index != -1;

      if (existsInServer) {
        // Si el dato existe en el servidor
        final runneServer = listServer[index]; // Obtener el dato correspondiente del servidor
        bool isModifiServer = isComratedField(X: runnerSQL, Y: runneServer);

        if (isModifiServer) {
          // Si el dato local es más reciente
          bool overwrite = await showDialog(
                context: context,
                builder: (BuildContext context) {
                       TextToSpeechService().speak(
                      'El registro ya existe en el servidor. ¿Deseas actualizarlo con los nuevos datos locales?');
               
                  return AssetAlertDialogPlatform(
                    title: 'Actualizar Datos del Servidor',
                    message:
                        'Los datos locales han sido modificados. ¿Desea actualizar el servidor con los nuevos datos? Los cambios se guardarán en el servidor.',
                    child: contentDialog(
                      context: context,
                      index: index,
                      runnerSQL: runnerSQL,
                      runneServer: runneServer,
                      textBottonIsTrue: 'Actualizar',
                      textBottonIsFalse: 'Omitir',
                    ),
                  );
                },
              ) ??
              false;

          if (overwrite) {
            // Si el usuario decide actualizar
            if (!toBeUpdate.contains(runnerSQL)) {
              // Si el dato no está ya en la lista de actualizaciones
              await dataProvider.saveProductosApp(
                  runnerSQL); // Guardar el dato local en el servidor
              toBeUpdate.add(
                  runnerSQL); // Añadir el dato a la lista de actualizaciones
            } else {
              print('Ya está en Modificado'); // Mensaje de depuración
            }
          } else {
            // Si el usuario decide omitir
            if (!toBeOmited.contains(runnerSQL)) {
              // Si el dato no está ya en la lista de omisiones
              toBeOmited
                  .add(runnerSQL); // Añadir el dato a la lista de omisiones
            } else {
              print('Ya está en Omitidos'); // Mensaje de depuración
            }
          }
        } else {
          // Si el dato local no es más reciente
          if (!toBeOmited.contains(runnerSQL)) {
            // Si el dato no está ya en la lista de omisiones
            toBeOmited.add(runnerSQL); // Añadir el dato a la lista de omisiones
          } else {
            print('Ya está en Omitidos'); // Mensaje de depuración
          }
        }
      } else {
        // Si el dato no existe en el servidor
        if (runnerSQL.id == '' || runnerSQL.id.toString().isEmpty) {
          // Si el dato local no tiene ID
          if (!toBeCreated.contains(runnerSQL)) {
            // Si el dato no está ya en la lista de creaciones
            await dataProvider.saveProductosApp(
                runnerSQL); // Guardar el nuevo dato en el servidor
            toBeCreated
                .add(runnerSQL); // Añadir el dato a la lista de creaciones
          } else {
            print('Ya está en Creado'); // Mensaje de depuración
          }

          // Buscar el producto en la lista del servidor por sus atributos únicos para obtener su nuevo ID
          TCheckPointsModel? productoEnListaApi = listServer.firstWhere(
            (k) => k.idCorredor == runnerSQL.idCorredor && k.dorsal == runnerSQL.dorsal,
            orElse: () => tCheckPointsModelDefault(),
          );
          if (productoEnListaApi != null) {
            if (!tolocalExist.contains(runnerSQL)) {
              // Asignar el nuevo ID al producto localmente
              runnerSQL.id = productoEnListaApi.id;
              await updateData(
                  runnerSQL, runnerSQL.idsql); // Modificar localmente
              tolocalExist.add(runnerSQL);
            } else {
              print('Ya está en creado localmente');
            }
          }
        } else {
          // Si el dato local tiene ID pero no existe en el servidor
          if (!toBeDeleted.contains(runnerSQL)) {
            // Si el dato no está ya en la lista de eliminaciones
            toBeDeleted
                .add(runnerSQL); // Añadir el dato a la lista de eliminaciones
            await deleteData(runnerSQL.idsql!); // Eliminar el dato local
          } else {
            print('Ya está en Eliminado'); // Mensaje de depuración
          }
        }
      }
    }
  }

// Método para dividir la lista en lotes
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }



  //METODO SCREENSHOT
  Future<Uint8List?> captureWidget(
      {required ScreenshotController screenshotController}) async {
    try {
      // Captura el widget usando la instancia de screenshotController
      final image = await screenshotController.capture();

      if (image != null) {
        return image;
      } else {
        print('No se pudo capturar la imagen del widget.');
        return null;
      }
    } catch (e) {
      // Maneja cualquier excepción que pueda ocurrir durante la captura
      print('Error al capturar la imagen del widget: $e');
      return null;
    }
  }
}

