import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/play_sound.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider_cache/provider_cache.dart';

import 'package:provider/provider.dart';
class ModoOfflineTitle extends StatelessWidget {
  const ModoOfflineTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    width: 250,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const P3Text(
          text: 'Accede sin Conexión a Internet',
          textAlign: TextAlign.justify,
          maxLines: 6,
          color: AppColors.accentColor,
        ),
        ModoOfflineClick(),
      ],
    ),
                  );
  }
}
class ModoOfflineClick extends StatelessWidget {
  const ModoOfflineClick({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;

    return Card(
      elevation: 10,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: SwitchListTile.adaptive(
          visualDensity: VisualDensity.compact,
          dense: true,
          contentPadding: const EdgeInsets.symmetric( horizontal: 20),
          activeColor: Colors.red,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.green,
          // subtitle: H2Text(
          //   text: 'Modo Offline',
          //   fontSize: 12,
          // ),
          title: Row(
            children: [
              SignalAPi(),
              P2Text(
                text: isoffline ? 'Activado' : 'Desactivado',
              ),
            ],
          ),
          value: isoffline,
          onChanged: (value) async {
            //INICALIZAR LAS BD O TABLAS>
            // Provider.of<DBAsistenciaAppProvider>(context, listen: false)
            //     .initDatabase();
            // Provider.of<DBDetalleGrupoProvider>(context, listen: false)
            //     .initDatabase();
            Provider.of<DBEMpleadoProvider>(context, listen: false)
                .initDatabase();
            Provider.of<DBRunnersAppProvider>(context, listen: false)
                .initDatabase();
            Provider.of<UsuarioProvider>(context, listen: false)
                .saveIsOffline(value);

            // Actualizar el estado en el Provider
            dataProvider.saveIsOffline(value);

            playSound();
          }),
    );
  }
}
