import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/sqllite/bd%20initDatabase/db____global_initialice_table.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/utils/files/assets_play_sound.dart';
import 'package:chasski/widget/estate%20app/state_icon_offline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModoOfflineClick extends StatelessWidget {
  const ModoOfflineClick({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<OfflineStateProvider>(context);
    bool isoffline = dataProvider.isOffline;
    return Container(
      constraints: BoxConstraints(
        maxWidth: 250,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isoffline
              ? Icon(Icons.wifi_off_outlined)
              : Icon(
                  Icons.wifi,
                  color: Colors.green,
                ),
          const P2Text(
            text: 'Tipo de acceso',
            textAlign: TextAlign.center,
          ),
          SwitchListTile.adaptive(
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              dense: true,
              activeColor: Colors.red,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.green,
              title: Row(
                children: [
                  SignalAPi(),
                  P3Text(
                    text: isoffline ? ' activo' : ' inactivo',
                  ),
                ],
              ),
              value: isoffline,
              onChanged: (value) async {
                //INICIAR TODAS LAS TABLAS DE SQLLite
                DatabaseInitializer.initializeDatabase(context);

                // Provider.of<OfflineStateProvider>(context, listen: false).saveIsOffline(value);

                // Actualizar el estado en el Provider
                await dataProvider.saveIsOffline(value);

                SoundUtils.playSound();
                TextToSpeechService().speak(isoffline
                    ? 'conexión a internet activado.'
                    : 'Trabajando sin conexión a internet.');
              }),
        ],
      ),
    );
  }
}
