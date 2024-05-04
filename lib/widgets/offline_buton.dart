
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';
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
      elevation: 10,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:10),
        child: SwitchListTile.adaptive(
          visualDensity: VisualDensity.compact,
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          activeColor: Colors.red,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.green,
            title:  H2Text(
              text: 'Modo Offline $isoffline',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              // color: Colors.white,
            ),
            subtitle: H2Text(
              text: isoffline ? 'Activado' : ' Desactivado',
              fontSize: 11, 
              // color: Colors.white,
            ),
            value: isoffline,
            onChanged: (value) async {
              //INICALIZAR LAS BD O TABLAS>
              Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
              Provider.of<DBDetalleGrupoProvider>(context, listen:  false).initDatabase();
              Provider.of<DBEMpleadoProvider>(context, listen:  false).initDatabase();
              Provider.of<UsuarioProvider>(context, listen: false).saveIsOffline(value);
              // Provider.of<DBPersonalProvider>(context, listen: false).initDatabase();
           
            // Actualizar el estado en el Provider
            dataProvider.saveIsOffline(value);
              playSound();
            }),
      ),
    );
  }
  void playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('song/tono.mp3')); // Ruta a tu archivo de sonido
  }
}
