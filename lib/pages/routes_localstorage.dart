// ignore_for_file: deprecated_member_use

import 'package:chasski/offline%20page/page_text_check_point_ar_01.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_010.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_011.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_012.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_013.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_02.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_020meta.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_03.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_04.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_05.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_06.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_07.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_08.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_09.dart';
import 'package:chasski/offline/page_test_detalletrabajo.dart';
import 'package:chasski/offline/page_test_list_check_points.dart';
import 'package:chasski/offline/page_test_runners.dart';
import 'package:chasski/offline/page_text_empelado.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoutesLocalStorage {
  Widget icon;
  String title;
  Widget path;
  RoutesLocalStorage(
      {required this.icon, required this.title, required this.path});
}

List<RoutesLocalStorage> sqlRoutes = [
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 80,
      color: CustomColors.darkIndigo,
    ),
    title: "Check Points",
    path: DBListCheckPointsArPage(),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/run.svg",
      width: 80,
     color: CustomColors.darkIndigo,
    ),
    title: "Corredores",
    path: const DBRunnerspage(),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/person.svg",
     width: 80,
     color: CustomColors.darkIndigo,
    ),
    title: "Team",
    path: const DBEmpleadoPage(),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/runner.svg",
      width: 80,
      color: CustomColors.darkIndigo,
    ),
    title: "Grupos",
    path: const DBDetalletrabajoPage(),
  ),
];

List<RoutesLocalStorage> route_p = [
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
     width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR01 - CHP",
    path: const DBCheckPoints01Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR02 - CHP",
    path: const DBCheckPoints02Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR03 - CHP",
    path: const DBCheckPoints03Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR04 - CHP",
    path: const DBCheckPoints04Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR05 - CHP",
    path: const DBCheckPoints05Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
     width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR06 - CHP",
    path: const DBCheckPoints06Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR07 - CHP",
    path: const DBCheckPoints07Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR08 - CHP",
    path: const DBCheckPoints08Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
     width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR09 - CHP",
    path: const DBCheckPoints09Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR010 - CHP",
    path: const DBCheckPoints010Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
     width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR011 - CHP",
    path: const DBCheckPoints011Page(
      nombre: '',
    ),
  ),

  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR012 - CHP",
    path: const DBCheckPoints012Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
     icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR013 - CHP",
    path: const DBCheckPoints013Page(
      nombre: '',
    ),
  ),
  RoutesLocalStorage(
    icon: SvgPicture.asset(
      "assets/img/check_point.svg",
      width: 70,
      color: CustomColors.darkIndigo,
    ),
    title: "AR META - CHP",
    path: const DBCheckPoints020METAPage(
      nombre: '',
    ),
  ),

  //  RoutesLocalStorage(
  //      icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
  //     title: "Lector CheckP 00",
  //     path:    QrPageRunnersAR00(), ),

  // RoutesLocalStorage(
  //    icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
  //   title: "Control Asistencia",
  //   path:   const QrPageAsistencia(), ),

  // RoutesLocalStorage(
  //      icon: const Icon(Icons.cloud_download, color: Colors.red,),
  //     title: "Personal",
  //     path:   const DBPersonalPage(), ),

  //  RoutesLocalStorage(
  //      icon: const Icon(Icons.qr_code, color: Colors.red,),
  //     title: "Qr Generate",
  //     path:   const QrListaPersonal(), ),
];
