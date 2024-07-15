import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_distancias_ar.dart';
import 'package:chasski/provider/provider_t_evento_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets_imge.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/widget/runner_sponsor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;
    final loginProvider = Provider.of<TRunnersProvider>(context).listaRunner;

    TRunnersModel runner = loginProvider.firstWhere((e) => e.id == user!.id,
        orElse: () => defaultRunner());

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
      leadingWidth: 90,
      title: Padding(
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
                width: 90,
                height: 50,
                color: Colors.black,
              )
            : Image.asset(
                AppImages.logoBigAndesRace,
                width: 100,
                color: Colors.black,
              ),
      ),
      actions: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: H1Text(
                  text: distancia.distancias,
                  fontSize: 30,
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
