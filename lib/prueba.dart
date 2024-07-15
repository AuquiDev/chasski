
//   bool islogin = false;

// void playSound() async {
//     AudioPlayer audioPlayer = AudioPlayer();
//     await audioPlayer.play(AssetSource('song/gota.mp3')); // Ruta a tu archivo de sonido
//   }
//   //Metodo de Autentificacion
//   Future<bool> login({ BuildContext? context, int? cedulaDNI,
//   // String? idUsuario
//   }) async {
//     islogin = true;
//     notifyListeners();
//     // ignore: unused_local_variable
//     int userindex = -1;
//     try {
//       //CONDICIONALOFFLINE aumentamos este codigo para asignar el valor de la listausuarios en modo offline.
//       // bool isOffline =   Provider.of<UsuarioProvider>(context!, listen: false).isOffline;

//       // final listaRunnerSQL = Provider.of<DBRunnersAppProvider>(context, listen: false).listsql;

//       // listaRunner = isOffline ? listaRunnerSQL : listaRunner;
//       //Esta bsuqueda devulece un umeor, si el numero estabne en leindex es decir de 0 a mas , si es menor de 0 el usuairo n oexiste.
//       userindex = listaRunner.indexWhere((e) {

//         bool ismath = (
//           e.numeroDeDocumentos.toString().toLowerCase() ==
//           cedulaDNI.toString().toLowerCase()
//           // &&  e.telefono == idUsuario
//           );

//         if (ismath) {
//           // Si se encuentra el usuario, establecerlo en UsuarioProvider
//           Provider.of<RunnerProvider>(context!, listen: false)  .setusuarioLogin(e);
//           // Guardar la información del usuario en SharedPreferences
//           SharedPrefencesGlobal().saveIDEvento(e.idEvento!);
//           SharedPrefencesGlobal().saveIDDistancia(e.idDistancia!);///
//           SharedPrefencesGlobal().saveID(e.id!);
//           SharedPrefencesGlobal().saveNombreRun(e.nombre!);
//           SharedPrefencesGlobal().saveApellidos(e.apellidos);
//           SharedPrefencesGlobal().saveDorsal(e.dorsal!);
//           SharedPrefencesGlobal().savePais(e.pais);
//           SharedPrefencesGlobal().saveTallaPolo(e.tallaDePolo);

//           SharedPrefencesGlobal().saveImageRun(e.imagen!);
//           SharedPrefencesGlobal().saveCollectionID(e.collectionId!);
//         }
//         return ismath;
//       });

//       //Hacer un sonido si el usuario ha sido en contrado
//       if (userindex != -1) {
//         playSound();
//       }
//     } catch (e) {
//       userindex = -1;

//     }

//     // Simular una carga con un temporizador
//     await Future.delayed(const Duration(seconds: 2));

//     // Lógica de navegación o mensaje de error
//     if (userindex != -1) {
//         print('ESTATE IF: $islogin');
//       islogin = true;
//       notifyListeners();
//       // Configurar un temporizador para cambiar islogin a false después de 2 segundos
//       Timer(const Duration(seconds: 4), () {
//         islogin = false;
//         notifyListeners();
//       });
//       return islogin;
//     } else {
//       print('ESTATE ELSE: $islogin - $userindex');
//       islogin = false;
//       notifyListeners();
//       return islogin;
//     }
//   }






  // bool isSyn = false;
  // Future<void> sincServer(
  //     {List<ParticipantesModel>? listSheet, //List a Sincronizar
  //     BuildContext? context}) async {

  //   isSyn = true;
  //   notifyListeners();

  //   // Verificamos que la lista no sea nula
  //   if (listSheet == null) return;
  //   // Lista para elementos que deben ser eliminados de listRunner
  //   List<ParticipantesModel> toBeDeleted = [];

  //   //1:Afirmamos que "e" esta en la lista poketbase del api runner
  //   for (var e in listaRunner) {
  //     final index = listSheet.indexWhere((sheet) => sheet.key == e.key); //posicion del elemnto [index]
  //     //2:Verificamos si el elemento existe
  //     /*.any(...): Este método pertenece a la clase Iterable en 
  //   Dart y verifica si al menos un elemento dentro del iterable cumple con la condición especificada.*/
  //     if (listaRunner.any((sheet) => sheet.key == e.key)) {
  //       //si Existe!
  //       //3:obtenemos el indice del primer elemento de la lista que cumple la condicion

  //       // Sincronizamos el elemento con la lista de Sheety
  //       var existingItem = listSheet[index];
  //       // Aseguramos que `id` y `idsheety` estén correctamente asignados
  //       // e.id = existingItem.id;
  //       e.idsheety = existingItem.id;
  //       e.title = 'Update';
  //       //NO DEBERIAMOS hcer un update sin antes verificar si el elemento ha sufrido cambios,
  //       //para eso debermos comprarbar si hay cambios, caso contrario no hacer update.

  //       //4:Ejecutamos la accion,Sera UN UPDATE ya que el registro ay existe
  //       // Verificamos si el elemento ha sufrido cambios antes de actualizar
  //       if (existingItem != e) {
  //         //4: Ejecutamos la acción, será un UPDATE ya que el registro ya existe
  //         await saveProductosApp(e);
  //         print(
  //             'UPDATE en el servidor ${e.nombre} => ${listSheet[index].nombre}');
  //       } else {
  //         print('No se detectaron cambios para ${e.nombre}');
  //       }
  //     } else {
  //       /*Si no existe :deberia guardar pero, deebemos verificar si listrunner aun existe en el listwheety
  //       si n list runner tiene un dato que existe en su lista, pero en list sheety ese dato ha sido eliminado en algun momento, 
  //       tambein al momento de sincronizar debria leiminarse en listrunner. como lologro */

  //       //6: Si key es nulo quiere decir que no existe en el servidor
  //       if (e.key == null) {
  //         //7: Se tiene que hacer un POST al servidor como nuevo registro
  //         await saveProductosApp(e);
  //         print('CREATE en el servidor ${e.nombre}');
  //       } else {
  //         //Si el prodcuto si tiene ID pero no existe
  //          toBeDeleted.add(e);
  //         await deleteTAsistenciaApp(e.id);
  //         print('DELETE en el servidor ${e.nombre}');
  //       }
  //       // PlatformAlertDialog(message: 'Cambios en el servidor', title: '${listSheet[index].nombre}');
  //     }
  //   }

  //    // Eliminar elementos de listaRunner que no existen en listSheet
  //   for (var e in toBeDeleted) {
  //     await deleteTAsistenciaApp(e.id);
  //     print('DELETE en el servidor ${e.nombre}');
  //   }

  //   // Añadir elementos de listSheet que no están en listaRunner
  //   for (var sheet in listSheet) {
  //     if (!listaRunner.any((e) => e.key == sheet.key)) {
  //       await saveProductosApp(sheet);
  //       print('CREATE en el servidor ${sheet.nombre}');
  //     }
  //   }
  //   isSyn = false;
  //   notifyListeners();
  // }




  // bool isSyn = false;
  // // Lista para elementos que deben ser eliminados de listRunner
  // List<ParticipantesModel> toBeDeleted = [];
  // List<ParticipantesModel> toBeUpdate = [];
  // List<ParticipantesModel> toBeCreated = [];

  // Future<void> sincServer( {List<ParticipantesModel>? listSheet}) async {
  //   isSyn = true;
  //   notifyListeners();
  //   // Verificamos que la lista no sea nula
  //   if (listSheet == null) return;

  //   /*iteramos listaRunner: esta lista es producto de sincronizacionesa anteriores por listsheety
  //   Contine las mimas inforacion de listsheety, si en list sheety se modifica alfgo deberi amodiifcarse
  //   al sincronizar tambien, se se elimina algo en listsheety, deberia eliminar en listrunner tambein,
  //   para eso estamos gestioando la infroacion de la siguiente manera */
  //   for (var e in listaRunner) {
  //      //obtenemos el indice del primer elemento de la lista que cumple la condicion
  //     final index = listSheet.indexWhere((sheet) => sheet.key == e.key); //posicion del elemnto [index]
  //     //Verificamos si el elemento existe
  //     if (listaRunner.any((sheet) => sheet.key == e.key)) {//si Existe!

  //       var existingItem = listSheet[index];//obtenemso el elemento
  //       // Aseguramos que `id` y `idsheety` estén correctamente asignados
  //       // e.id = existingItem.id;
  //       e.idsheety = existingItem.id;
  //       e.title = 'Update';
  //       //Ejecutamos UN UPDATE ya que el registro ay existe
  //       // Verificamos si el elemento ha sufrido cambios antes de actualizar
  //       if (existingItem != e) {
  //         toBeUpdate.add(e);
  //         notifyListeners();
  //       } else {
  //         print('No se detectaron cambios para ${e.nombre}');
  //       }
  //     } else {

  //       //6: Si key es nulo quiere decir que no existe en el servidor
  //       if (e.key == null) {
  //         //7: Se tiene que hacer un POST al servidor como nuevo registro
  //         // await saveProductosApp(e);
  //         toBeCreated.add(e);
  //         notifyListeners();
  //       } else {
  //         //Si el registro existe en Lsitrunner pero ya no existe en listsheet
  //          toBeDeleted.add(e);
  //          notifyListeners();
  //         // await deleteTAsistenciaApp(e.id);
  //       }
  //       // PlatformAlertDialog(message: 'Cambios en el servidor', title: '${listSheet[index].nombre}');
  //     }
  //   }

  // //  if (toBeUpdate.isNotEmpty) {
  // //     for (var e in toBeUpdate) {
  // //     await saveProductosApp(e);
  // //     print('UPDATE en el servidor ${e.nombre}');
  // //   }
  // //  }
  // //    // Eliminar elementos de listaRunner que no existen en listSheet
  // //   if (toBeDeleted.isNotEmpty) {
  // //     for (var e in toBeDeleted) {
  // //     await deleteTAsistenciaApp(e.id);
  // //     print('DELETE en el servidor ${e.nombre}');
  // //   }
  // //   }

  // //   // Añadir elementos de listSheet que no están en listaRunner
  // //   if (toBeDeleted.isNotEmpty) {
  // //     for (var sheet in listSheet) {
  // //     if (!listaRunner.any((e) => e.key == sheet.key)) {
  // //       await saveProductosApp(sheet);
  // //       print('CREATE en el servidor ${sheet.nombre}');
  // //     }
  // //   }
  // //   }
  //   print('HOLA');
  //   isSyn = false;
  //   notifyListeners();
  // }
