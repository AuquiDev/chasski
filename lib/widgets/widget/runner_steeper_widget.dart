import 'package:chasski/pages/routes_localstorage.dart';
import 'package:chasski/sheety/home_testsheety.dart';
import 'package:chasski/utils/assets_title_login.dart';
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/runner_document_widget.dart';
import 'package:chasski/widgets/runner_home_widget.dart';
import 'package:flutter/material.dart';

class SteeperWidget extends StatefulWidget {
  const SteeperWidget({super.key});

  @override
  State<SteeperWidget> createState() => _SteeperWidgetState();
}

class _SteeperWidgetState extends State<SteeperWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: H1Text(
            text: 'Explora y Prepárate',
            color: AppColors.primaryRed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: P2Text(
            text: 'Descubre todas las opciones esenciales para asegurar una experiencia bien preparada.' +
                ' Desde el registro y generación de QR personalizados hasta mapas, reglamentos,' +
                ' cronogramas y más. Prepárate para disfrutar al máximo del evento.',
            textAlign: TextAlign.justify,
            color: AppColors.buttonSecondary,
          ),
        ),
        ...List.generate(routesRunner.length, (index) {
          final e = routesRunner[index];
          return AssetsListTitle(
            leading: Container(
              width: 50,
              height: 50,
              child: e.icon,
            ),
            trailing: AppSvg(width: 30).menusvg,
            title1: e.title,
            parrafo: e.content!,
            fontsize: 13,
            duration: 300 + index,
            color: AppColors.backgroundDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => e.path),
              );
            },
          );
        })
      ],
    );
  }
}

List<RoutesLocalStorage> routesRunner = [
  RoutesLocalStorage(
    icon: AppSvg().certificadoSgv,
    title: "Registro y Generación de mi QR",
    content:
        'Completa tu registro firmando digitalmente el deslinde y adjuntando tu certificado médico para generar tu QR personalizado.',
    path: DocumentRunnerWidget(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().localInfoSvg,
    title: "Info de cada distancia",
    content: 'Categorías de 100k, 60k, 30k y 10k.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().checkPointsSvg,
    title: "Mapas",
    content: 'Explora los mapas de las rutas disponibles.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().equipajeSvg,
    title: "Equipo Obligatorio",
    content: 'Información sobre el equipo necesario para la carrera.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().checkListSvg,
    title: "Reglamento",
    content: 'Normativas y reglas que deben seguirse durante la carrera.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().home1Svg,
    title: "Cronograma",
    content: 'Horarios y actividades programadas para el evento.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().markerSvg,
    title: "Entrega de Kits",
    content: 'Detalles sobre la entrega de kits a los participantes.',
    path: HomeRunnerChild(),
  ),
  // RoutesLocalStorage(
  //   icon: SvgPicture.asset("assets/img/equipaje.svg"),
  //   title: "Certificado Medico",
  //   content:
  //       '',
  //   path: HomeRunnerChild(),
  // ),
  RoutesLocalStorage(
    icon: AppSvg().personSvg,
    title: "Transporte de Corredores",
    content: 'Opciones y detalles sobre el transporte para los corredores.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().likeSvg,
    title: "Tours",
    content: 'Oportunidades de tours relacionados con el evento.',
    path: HomeRunnerChild(),
  ),
  RoutesLocalStorage(
    icon: AppSvg().home1Svg,
    title: "Hoteles",
    content:
        'Información sobre opciones de alojamiento para los participantes del evento.',
    path: SheetyPageParticipantes(),
  ),
];
