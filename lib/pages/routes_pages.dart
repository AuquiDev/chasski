import 'package:chasski/page_qr/page_check_list_list.dart';
import 'package:chasski/page_qr/page_check_points_list.dart';
import 'package:chasski/page_qr/qr_page_listdata_runner.dart';
import 'package:chasski/pages/t_local_storage.dart';
// import 'package:chasski/pages/user_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageRoutes {
  Widget icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
  PageRoutes(
    icon: SvgPicture.asset(
      "assets/img/runner.svg",
      width: 25,
    ),
    title: "Corredores",
    path: const QrListaRunners(),
  ),
  PageRoutes(
    icon: SvgPicture.asset(
      "assets/img/check.svg",
      width: 25,
    ),
    title: "Check List",
    path: CheckListListPage(),
  ),
  PageRoutes(
    icon: SvgPicture.asset(
      "assets/img/checkp.svg",
      width: 25,
    ),
    title: "Check points",
    path: CheckPotinsListPage(),
  ),
  PageRoutes(
    icon: SvgPicture.asset(
      "assets/img/sql.svg",
      width: 25,
    ),
    title: "Local Storage",
    path: LocalStoragePage(),
  ),
];
