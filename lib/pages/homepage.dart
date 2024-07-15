// ignore_for_file: prefer_adjacent_string_concatenation


import 'package:flutter/material.dart';
import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';

import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/widgets/char_local_storage.dart';
import 'package:chasski/widgets/demo_conectivity_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool active = false;
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

  @override
  void initState() {
    _initializeDatabase();
    active = true; // Cambiado aquí
    _activateAfterDelay();
    super.initState();
  }

  // Método para inicializar las bases de datos
  void _initializeDatabase() {
    Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
    Provider.of<DBDetalleGrupoProvider>(context, listen: false).initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    // Provider.of<DBPersonalProvider>(context, listen: false).initDatabase();
    sharedPrefs.setLoggedIn(); // Supongo que este método debe ser llamado aquí
  }

  // Método para activar active después de un retraso
  void _activateAfterDelay() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        // Asegúrate de que el widget todavía esté montado antes de cambiar el estado
        setState(() {
          active = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: [
              //CARRUSEL CON INDICADOR: GESTION
              // GestureDetector(
              //   onTap: () {
              //     final layoutmodel =
              //         Provider.of<LayoutModel>(context, listen: false);
              //     layoutmodel.currentPage = FormularioAsistenciapage();
              //   },
              //   child: Card(
              //       child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: H2Text(text: 'Asistencias', fontSize: 14,),
              //   )),
              // ),

              active ? SizedBox() : ConectivityDemo(), //CONECTIVITY

              //DIAGRAMA INDICADOR DE SINCRONIZACION DE DATOS.
              DiagrmaIndicatorSinc(),
            ],
          ),
        );
  }
}

