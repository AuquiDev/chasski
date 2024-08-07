import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_00.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/page_qr/qr_generate_runners.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class QrListaRunners extends StatefulWidget {
  const QrListaRunners({super.key});

  @override
  State<QrListaRunners> createState() => _QrListaRunnersState();
}

class _QrListaRunnersState extends State<QrListaRunners> {
  String idtrabajo = '';
  late ExpandedTileController _controller;

  @override
  void initState() {
    Provider.of<DBRunnersAppProvider>(context, listen: false).initDatabase();

    Provider.of<DBCheckPointsAppProviderAr00>(context, listen: false).initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    // Retrasa la ejecución de mostrarDialogoSeleccion después de que initState haya completado
    Future.delayed(Duration.zero, () {
      mostrarDialogoSeleccion();
    });
    super.initState();

    _controller = ExpandedTileController(isExpanded: false);
  }

  
void mostrarDialogoSeleccion() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Para iOS (Cupertino Dialog)
        return CupertinoAlertDialog(
          title: Text('CHECK POINTS'),
          content: Text(
            'Por favor, selecciona un punto de control al que tengas permisos de acceso.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      } else {
        // Para Android (Material Dialog)
        return AlertDialog(
          title: Text('CHECK POINTS'),
          content: Text(
            'Por favor, selecciona un punto de control al que tengas permisos de acceso.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    },
  );
}



  @override
  Widget build(BuildContext context) {
    final dataCache = Provider.of<UsuarioProvider>(context);
    bool isffline = dataCache.isOffline;

    final personalServerList =
        Provider.of<TRunnersProvider>(context).listaRunner;
    final personSQlList = Provider.of<DBRunnersAppProvider>(context).listsql;
    List<TRunnersModel> personalList =
        isffline ? personSQlList : personalServerList;
    //LISTA GRUPOS ALMACÉ

    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: dataCache.usuarioEncontrado!.rol == 'admin'
          ? Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 370),
                child: personalList.isEmpty
                    ? H2Text(
                        text: 'No hay datos disponibles',
                        color: Colors.white,
                        fontSize: 14,
                      )
                    : ExpandedTileList.builder(
                        itemCount: personalList.length,
                        itemBuilder: (context, index, controller) {
                          final e = personalList[index];
                          //Color intercalado
                          Color color = index % 2 == 0
                              ? Color(0xFF3F3F3F)
                              : Color(0xFF222222);
                          return ExpandedTile(
                            expansionAnimationCurve: Curves.easeInOut,
                            theme: ExpandedTileThemeData(
                              headerColor: color,
                              // headerRadius: 14.0,
                              headerPadding: EdgeInsets.all(14.0),
                              headerSplashColor: Colors.white,
                              contentBackgroundColor: Colors.white,
                              contentPadding: EdgeInsets.all(24.0),
                              // contentRadius: 12.0,
                            ),
                            controller: _controller,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                H2Text(
                                  text: e.nombre + ' ' + e.apellidos,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Table(
                                  border: TableBorder.all(
                                      color: Colors.white38, width: 0.4),
                                  children: [
                                    TableRow(
                                      children: [
                                        H2Text(
                                          text: 'DORSAL',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'GÉNERO',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'PAÍS',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: 'TALLA',
                                          fontSize: 10,
                                          color: Colors.white54,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        H2Text(
                                          text: e.dorsal,
                                          fontSize: 13,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: e.genero,
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: e.pais,
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                        H2Text(
                                          text: e.tallaDePolo,
                                          fontSize: 11,
                                          color: Colors.red,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            content: DelayedDisplay(
                                delay: Duration(milliseconds: 300),
                                child: PageQrGenerateRunner(e: e)),
                          );
                        },
                      ),
              ),
            )
          : const Center(
              child: H2Text(
                text:
                    'Acceso restringido: Solo los administradores tienen permisos para este panel.',
                fontSize: 13,
              ),
            ),
    );
  }
}
