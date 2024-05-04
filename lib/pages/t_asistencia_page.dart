// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';
import 'package:chasski/pages/t_asistencia_listdata.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/provider/provider_t_asistencia.dart';
import 'package:provider/provider.dart';

class FormularioAsistenciapage extends StatelessWidget {
  const FormularioAsistenciapage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //Modo OFFLINE
    final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
    final listAsitencia =
        Provider.of<TAsistenciaProvider>(context).listAsistencia;
    final listSQlasistencia =
        Provider.of<DBAsistenciaAppProvider>(context).listsql;

    final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;
    final isSavinSQL = Provider.of<DBAsistenciaAppProvider>(context).isSyncing;

    bool isavingProvider = isOffline ? isSavinSQL : isSavingSerer;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            isavingProvider
                ? const Flexible(
                    flex: 1, child: Center(child: CircularProgressIndicator()))
                : ListAsistencia(
                        listAsitencia:
                            isOffline ? listSQlasistencia : listAsitencia,
                      ),
          ],
        ),
      ),
    );
  }
}
