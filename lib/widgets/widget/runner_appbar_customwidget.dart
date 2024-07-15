// ignore_for_file: deprecated_member_use

import 'package:chasski/pages/runner_edit_profile_page.dart';
import 'package:chasski/utils/assets_butonsheets.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/widget/app_provider_runner.dart';
import 'package:flutter/material.dart';

class DetailsRunnerWidget extends StatelessWidget {
  const DetailsRunnerWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    return Column(
      children: [
        Table(
          columnWidths: {
            1: FixedColumnWidth(100),
            0: FlexColumnWidth(),
          },
          children: [
            TableRow(children: [
              GestureDetector(
                onTap: () {
                  showCustomBottonSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return CardRunnerDetails();
                      });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H1Text(
                      text: '${runner.nombre}',
                      fontSize: 30,
                      color: AppColors.textPrimary,
                    ),
                    H1Text(
                      text: '${runner.apellidos}',
                      fontSize: 25,
                      color: AppColors.textSecondary,
                    ),
                    P2Text(
                      text: 'ver mas...',
                      color: AppColors.successColor,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditUSerPage()));
                },
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    GLobalImageUrlServer(
                      image: runner.imagen ?? ' ',
                      collectionId: runner.collectionId ?? '',
                      id: runner.id ?? '',
                      borderRadius: BorderRadius.circular(300),
                      height: 100,
                      width: 100,
                    ),
                    Card(child: AppSvg().editSvg)
                  ],
                ),
              ),
            ])
          ],
        ),
      ],
    );
  }
}

class CardRunnerDetails extends StatelessWidget {
  const CardRunnerDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    final distancia = RunnerData.getDistance(context, runner);

    return Column(
      children: [
        H1Text(
          text: runner.nombre,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
        H1Text(
          text: runner.apellidos,
          color: AppColors.buttonSecondary,
        ),
        P3Text(
          text:'DOC.: ' + runner.numeroDeDocumentos.toString(),
          color: AppColors.accentColor,
        ),
        SizedBox(height: 5),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GLobalImageUrlServer(
                    image: runner.imagen!,
                    collectionId: runner.collectionId!,
                    id: runner.id!,
                    borderRadius: BorderRadius.circular(0),
                    height: 200,
                    width: 200),
                SizedBox(height: 20),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                      color: AppColors.textSecondary.withOpacity(.2)),
                  children: [
                    TableRow(children: [
                      P3Text(
                        text: 'género'.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      P3Text(
                        text: 'País'.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      P3Text(
                        text: 'teléfono'.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      P3Text(
                        text: 'TALLA'.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: P1Text(
                          text: runner.genero,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      P1Text(
                        text: runner.pais,
                        textAlign: TextAlign.center,
                      ),
                      P1Text(
                        text: runner.telefono,
                        textAlign: TextAlign.center,
                      ),
                      P1Text(
                        text: runner.tallaDePolo,
                        textAlign: TextAlign.center,
                      ),
                    ])
                  ],
                ),

                SizedBox(height: 20),
                H1Text(
                  text: evento.nombre,
                  color: AppColors.accentColor,
                ),
                SizedBox(height: 20),
                Table(
                  children: [
                    TableRow(children: [
                      GLobalImageUrlServer(
                          image: evento.logo!,
                          collectionId: evento.collectionId!,
                          id: evento.id!,
                          borderRadius: BorderRadius.circular(0),
                          height: 60,
                          width: 120),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              H2Text(
                                text: distancia.distancias,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                textAlign: TextAlign.center,
                              ),
                              H2Text(
                                text: runner.dorsal,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              P3Text(
                                text: 'Categoría'.toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              P3Text(
                                text: 'Dorsal'.toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: P2Text(
                    text: distancia.descripcion,
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
