// ignore_for_file: use_build_context_synchronously, avoid_print



import 'package:chasski/zplashScreen/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefencesGlobal {
  //Vamos utilizar un singleton para utilizar una sola instancia
  //HEMOS creado singleton para llamar una sola vez esta clase.
  static final SharedPrefencesGlobal _instance = SharedPrefencesGlobal._();

  SharedPrefencesGlobal._();//Constructor privado 

  factory SharedPrefencesGlobal(){
    return _instance;
  }
  
  //Instancia de sharedPreferecnes 
  late SharedPreferences _pref;
  //CREAMSO un metodo initsharedpreferences para  inicializar una sola vez el sharedpreferences 
  Future<void> initSharedPreferecnes() async { 
    _pref = await SharedPreferences.getInstance();
  }

  //COLABORADOR 
    // Función para obtener el estado de inicio de sesión desde shared preferences
  Future<bool> getLoggedIn() async {
    // Obtiene el valor de isLoggedIn, si no existe devuelve false por defecto
    return _pref.getBool('isLoggedIn') ?? false;
  }
  
   // Función para cerrar sesión
  Future<void> logout(BuildContext context) async {
    await _pref.setBool('isLoggedIn', false);
    // Redirige a la página de inicio de sesión después de cerrar sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

   // Función para guardar el estado de inicio de sesión en shared preferences
  Future<void> setLoggedIn() async {
   
    await _pref.setBool('isLoggedIn', true);
  }

  //RUNNER  
    // Función para obtener el estado de inicio de sesión desde shared preferences
  Future<bool> getLoggedInRunner() async {
    // Obtiene el valor de isLoggedIn, si no existe devuelve false por defecto
    return _pref.getBool('isLoggedInRun') ?? false;
  }
  
   // Función para cerrar sesión
  Future<void> logoutRunner(BuildContext context) async {
    await _pref.setBool('isLoggedInRun', false);
    // Redirige a la página de inicio de sesión después de cerrar sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

   // Función para guardar el estado de inicio de sesión en shared preferences
  Future<void> setLoggedInRunner() async {
   
    await _pref.setBool('isLoggedInRun', true);
  }



//USUARIOENCONTRADO 
   //ID 
  Future<String?> getID() async {
    return _pref.getString('idKey');
  }
  
  Future<void> saveID(String  text) async {
    await _pref.setString('idKey', text);
    print('Campo idKey guardado $text');
  }

   Future<void> deleteId() async {
    await _pref.remove('idKey');
    print('Campo idKey eliminado');
  }

//USUARIO EMPLEADOS 
  
  //NOMBRE 
  Future<String?> getNombre() async {
    return _pref.getString('nombrekey');
  }

  Future<void> saveNombre(String  text) async {
    await _pref.setString('nombrekey', text);
    print('Campo nombrekey guardado $text');
  }

   Future<void> deleteNombre() async {
    await _pref.remove('nombrekey');
    print('Campo nombrekey eliminado');
  }

   //ROL 
  Future<String?> getRol() async {
    return _pref.getString('rolKey');
  }
  Future<void> saveRol(String  text) async {
    await _pref.setString('rolKey', text);
    print('Campo rolKey guardado $text');
  }
   Future<void> deleteRol() async {
    await _pref.remove('rolKey');
    print('Campo rolKey eliminado');
  }
  //IMAGEN 
  Future<String?> getImage() async {
    return _pref.getString('imageKey');
  }
  Future<void> saveImage(String  text) async {
    await _pref.setString('imageKey', text);
    print('Campo imageKey guardado $text');
  }
    Future<void> deleteImage() async {
    await _pref.remove('imageKey');
    print('Campo imageKey eliminado');
  }
  //COLLECTION ID  
  Future<String?> getCollectionID() async {
    return _pref.getString('collectionKey');
  }
  Future<void> saveCollectionID(String  text) async {
    await _pref.setString('collectionKey', text);
    print('Campo collectionKey guardado $text');
  }
  Future<void> deleteCollectionID() async {
    await _pref.remove('collectionKey');
    print('Campo rolKey eliminado');
  }

  //RUNNER 

  //NOMBRE  RUNNER 
  Future<String?> getNombreRun() async {
    return _pref.getString('nombrekeyRun');
  }

  Future<void> saveNombreRun(String  text) async {
    await _pref.setString('nombrekeyRun', text);
    print('Campo nombrekey guardado $text');
  }

   Future<void> deleteNombreRun() async {
    await _pref.remove('nombrekeyRun');
    print('Campo nombrekey eliminado');
  }
   //IMAGEN RUNNER 
  Future<String?> getImageRun() async {
    return _pref.getString('imageKeyRun');
  }
  Future<void> saveImageRun(String  text) async {
    await _pref.setString('imageKeyRun', text);
    print('Campo imageKey guardado $text');
  }
    Future<void> deleteImageRun() async {
    await _pref.remove('imageKeyRun');
    print('Campo imageKey eliminado');
  }
  //APELLIDOS RUNNER  
  Future<String?> getApellidos() async {
    return _pref.getString('apellidos');
  }
  Future<void> saveApellidos(String  text) async {
    await _pref.setString('apellidos', text);
    print('Campo apellidos guardado $text');
  }
  Future<void> deleteApellidos() async {
    await _pref.remove('collectionKey');
    print('Campo collectionKey eliminado');
  }
   //DORSAL RUNNER  
  Future<String?> getDorsal() async {
    return _pref.getString('dorsal');
  }
  Future<void> saveDorsal(String  text) async {
    await _pref.setString('dorsal', text);
    print('Campo apellidos guardado $text');
  }
   Future<void> deleteDorsal() async {
    await _pref.remove('dorsal');
    print('Campo collectionKey eliminado');
  }

  //PAIS RUNNER  
  Future<String?> getPais() async {
    return _pref.getString('pais');
  }
  Future<void> savePais(String  text) async {
    await _pref.setString('pais', text);
    print('Campo apellidos guardado $text');
  }
  Future<void> deletePais() async {
    await _pref.remove('pais');
    print('Campo pais eliminado');
  }

  //TALLAPOLO RUNNER  
  Future<String?> getTallaPolo() async {
    return _pref.getString('tallaDePolo');
  }
  Future<void> saveTallaPolo(String  text) async {
    await _pref.setString('tallaDePolo', text);
    print('Campo apellidos guardado $text');
  }
  Future<void> deleteTallaPolo() async {
    await _pref.remove('tallaDePolo');
    print('Campo tallaDePolo eliminado');
  }


//EVENTO DE CARRERA 
   //IDEVENTO ID  
  Future<String?> getIDEvento() async {
    return _pref.getString('idEvento');
  }
  Future<void> saveIDEvento(String  text) async {
    await _pref.setString('idEvento', text);
    print('Campo IdEvento guardado $text');
  }
  Future<void> deleteIDEvento() async {
    await _pref.remove('idEvento');
    print('Campo idEvento eliminado');
  }
  

//DISTANCIA DE CARRERA 
   //IDDISTANCIA ID  
  Future<String?> getIDDistancia() async {
    return _pref.getString('idDistancia');
  }
  Future<void> saveIDDistancia(String  text) async {
    await _pref.setString('idDistancia', text);
    print('Campo idDistancia guardado $text');
  }
  Future<void> deleteIDDistancia() async {
    await _pref.remove('idDistancia');
    print('Campo idDistancia eliminado');
  }
  
//ISOFFLINE ESTAUS APP
//COLLECTION ID  
 // Método para obtener el estado de modo offline desde SharedPreferences
Future<bool?> getIsOffline() async {
  return _pref.getBool('isOffline');
}

// Método para guardar el estado de modo offline en SharedPreferences
Future<void> saveIsOffline(bool isOffline) async {
  await _pref.setBool('isOffline', isOffline);
}
}


