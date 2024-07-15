import 'dart:ui';

import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_distancias_ar.dart';
import 'package:chasski/provider/provider_t_evento_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/image_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppCustomRunner extends StatelessWidget {
  const AppCustomRunner({
    super.key,
  });

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
        orElse: () => distanciasDefault());

    final eventProvider =
        Provider.of<TEventoArProvider>(context).listAsistencia;

    TEventoModel evento = eventProvider.firstWhere(
        (e) => e.id == runner.idEvento,
        orElse: () => eventdefault());

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: CustomColors.lightIndigo,
                  child: ImageLoginRunner(
                    user: runner,
                    size: 80,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     H2Text(
                        text: '${runner.nombre}',
                        fontWeight: FontWeight.w600,
                        color: CustomColors.light1Grey,
                      ),
                      H2Text(
                        text: '         ${runner.apellidos}',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.lightGrey,
                      ),
                      // H2Text(
                      //   text: '${runner.pais}',
                      //   fontSize: 10,
                      //   fontWeight: FontWeight.w600,
                      //   color: CustomColors.lightIndigo,
                      // ),
                      SizedBox(height: 10,),
                       Row(
                      children: [
                         ImageEvent(
                        user: evento,
                        size: 20,
                      ),
                      SizedBox(width: 8,),
                      H2Text(
                        text: '${evento.nombre}',
                        fontSize: 12,
                        color: CustomColors.light1Grey,
                        fontWeight: FontWeight.w500,
                      ),
                      ],
                     ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Table(
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        // color: CustomColors.black,
                        borderRadius: BorderRadius.circular(10)),
                    children: [
                      barRunnerDate(title: runner.dorsal, subtitle: 'Dorsal'),
                      // barRunnerDate(title: runner.pais, subtitle: 'País'),
                      barRunnerDate(
                          title: runner.tallaDePolo, subtitle: 'Medida'),
                      barRunnerDate(
                          title: distancia.distancias, subtitle: 'Categoria'),
                    ])
              ],
            ),
             SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget barRunnerDate({String? title, String? subtitle}) {
    return Card(
      color: Colors.white10,
      surfaceTintColor: Colors.white10,
      child: Column(
        children: [
          H2Text(
            text: title ?? '',
            fontWeight: FontWeight.w600,
            color: CustomColors.light1Grey,
            fontSize: 18,
          ),
          
          H2Text(
            text: subtitle ?? '',
            color: CustomColors.light1Grey,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
