import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/distancia/provider_t_distancias_ar.dart';
import 'package:chasski/provider/evento/provider_t_evento_ar.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_imge.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_sponsor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    ParticipantesModel? user =
        Provider.of<CacheParticpantesProvider>(context).usuarioEncontrado;
    final loginProvider =
        Provider.of<TParticipantesProvider>(context).listaRunner;

    ParticipantesModel runner = loginProvider.firstWhere(
        (e) => e.id == user?.id,
        orElse: () => participantesModelDefault());

    final distanProvider =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    TDistanciasModel distancia = distanProvider.firstWhere(
      (d) => d.id == runner.idDistancia,
      orElse: () => distanciasDefault(),
    );

    final eventProvider = Provider.of<TEventoArProvider>(context).listDistancia;

    TEventoModel evento = eventProvider.firstWhere(
        (e) => e.id == runner.idEvento,
        orElse: () => eventdefault());

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Image.asset(AppImages.logoAdidas),
      ),
      leadingWidth: 80,
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 2.0,
              ),
              child: evento.nombre != 'nombre'
                  ? GLobalImageUrlServer(
                      image: evento.logo!,
                      collectionId: evento.collectionId!,
                      id: evento.id!,
                      borderRadius: BorderRadius.circular(8.0),
                      boxFit: BoxFit.contain,
                      // width: 90,
                      height: 40,
                      color: Colors.black,
                    )
                  : Image.asset(
                      AppImages.logoBigAndesRace,
                      height: 40,
                      color: Colors.black,
                    ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: H1Text(
                      text: distancia.distancias == 'N/A'
                          ? ''
                          : distancia.distancias,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                SponsorSpage(
                  width: 200,
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
      actions: [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
