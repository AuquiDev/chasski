import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/widgets/play_sound.dart';
import 'package:chasski/widgets/state_signal_icons.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:provider/provider.dart';

class ModoOfflineClick extends StatelessWidget {
  const ModoOfflineClick({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: SwitchListTile.adaptive(
          visualDensity: VisualDensity.compact,
          // dense: true,
          contentPadding: const EdgeInsets.all(0),
          activeColor: Colors.red,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.green,
          title: H2Text(
            text: 'Modo Offline',
            fontSize: 12,
          ),
          subtitle: Row(
            children: [
              SignalAPi(),
              H2Text(
                text: isoffline ? 'Activado' : 'Desactivado',
                fontSize: 15,
                fontWeight: FontWeight.w600,
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
