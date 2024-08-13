import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/files/assets_imge.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/routes/assets_url_lacuncher.dart';
import 'package:chasski/widget/global/runner_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/text/assets_textapp.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  PageController _pageController = PageController(viewportFraction: .5);
  @override
  Widget build(BuildContext context) {
    List<RoutesLocalStorage> routeddiatancias = [
      RoutesLocalStorage(
        title: "13K",
        content: 'https://www.andesrace.pe/13k/',
        icon: Container(),
        path: Container(),
      ),
      RoutesLocalStorage(
        title: "30K",
        content: 'https://www.andesrace.pe/30k/',
        icon: Container(),
        path: Container(),
      ),
      RoutesLocalStorage(
        title: "60K",
        content: 'https://www.andesrace.pe/60k/',
        icon: Container(),
        path: Container(),
      ),
      RoutesLocalStorage(
        title: "100K",
        content: 'https://www.andesrace.pe/andes-race-100k/',
        icon: Container(),
        path: Container(),
      ),
    ];

    List<RoutesLocalStorage> routesRunner = [
      RoutesLocalStorage(
        title: "Equipo Obligatorio",
        content: 'https://www.andesrace.pe/equipamiento/',
        path: P3Text(
            text:
                'Consulta la lista de equipo esencial necesario para participar en la carrera.'),
        icon: AppSvg().equipajeSvg,
      ),
      RoutesLocalStorage(
        title: "Reglamento",
        content:
            'https://www.andesrace.pe/informacion-del-andes-race/reglamento/',
        path: P3Text(
            text:
                'Revisa las reglas oficiales y directrices de la competencia.'),
        icon: AppSvg().likeSvg,
      ),
      RoutesLocalStorage(
        title: "Cronograma",
        content: 'https://www.andesrace.pe/cronograma/',
        path: P3Text(
            text:
                'Consulta el horario completo de eventos y actividades de la carrera.'),
        icon: AppSvg().checkSvg,
      ),
      RoutesLocalStorage(
        title: "Transporte de Corredores",
        content: 'https://www.andesrace.pe/categoria-producto/transporte/',
        path: P3Text(
            text:
                'Obtén información sobre las opciones de transporte disponibles para los corredores.'),
        icon: AppSvg().checkSvg,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                H1Text(
                  text: "IMPORTANTE",
                  fontWeight: FontWeight.w900,
                ),
                H3Text(
                  text: "Información de cada distancia",
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: routeddiatancias.length,
              itemBuilder: (context, index) {
                final e = routeddiatancias[index];
                return GestureDetector(
                  onTap: () {
                    launchURL(e.content!);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    padding: const EdgeInsets.all(10.0),
                    decoration: decorationBox(),
                    child: FittedBox(
                      child: Column(
                        children: [
                          Image.asset(AppImages.logoBigAndesRace, height: 50),
                          AssetsDelayedDisplayYbasic(
                            duration: 400,
                            child: H1Text(
                                text: e.title,
                                color:
                                    AppColors.backgroundLight.withOpacity(.8),
                                fontSize: 50),
                          ),
                          SizedBox(height: 8.0),
                          P2Text(
                            text: 'Presione para más información',
                            color: AppColors.backgroundLight.withOpacity(.6),
                            fontSize: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FittedBox(
              child: Column(
                children: [
                  H1Text(
                    text: "Todo lo que Necesitas Saber".toUpperCase(),
                    fontWeight: FontWeight.w900,
                  ),
                  P2Text(
                    text:
                        "Toca los botones para acceder a los enlaces oficiales de Andes Race.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxWidth: 340),
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: routesRunner.length,
                itemBuilder: (context, index) {
                  final route = routesRunner[index];
                  return ListTile(
                    onTap: () {
                      launchURL(route.content!);
                    },
                    leading: route.icon,
                    title: Container(
                      margin: EdgeInsets.all(10),
                      decoration: decorationBox(color: AppColors.primaryWhite),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: H3Text(
                              text: route.title,
                              textAlign: TextAlign.center,
                            ), 
                          ),
                        ],
                      ),
                    ),
                    trailing: AppSvg().menusvg,
                  );
                },
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}

//SincDataRunnerSheet() ,DocumentRunnerWidget() ,HomeRunnerChild(), CloseSesion(),


