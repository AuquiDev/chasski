

import 'package:chasski/pages/routes_localstorage.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/runner_document_widget.dart';
import 'package:chasski/widgets/runner_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeOptions extends StatelessWidget {
  const HomeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    List<RoutesLocalStorage> routesRunner = [
      RoutesLocalStorage(
        icon: SvgPicture.asset(
          "assets/img/certificado.svg",
          width: 40,
        ),
        title: "Enviar Certif. Médico",
        path: DocumentRunnerWidget(),
      ),
      RoutesLocalStorage(
        icon: SvgPicture.asset(
          "assets/img/check.svg",
         width: 40,
        ),
        title: "Detalles del Checklist",
        path: HomeRunnerChild(),
      ),
      RoutesLocalStorage(
        icon: SvgPicture.asset(
          "assets/img/file.svg",
          width: 40,
        ),
        title: "Mi Avance",
        path: HomeRunnerChild(),
      ),
      RoutesLocalStorage(
        icon: SvgPicture.asset(
          "assets/img/equipaje.svg",
          width: 40,
        ),
        title: "Mis Bienes",
        path: HomeRunnerChild(),
      ),
    ];
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: size.height*.3, bottom: 10),
      itemCount: routesRunner.length,
      itemBuilder: (BuildContext context, int index) {
        final e = routesRunner[index];
        return CardOptionHome(e: e);
      },
    );
  }
}

class CardOptionHome extends StatelessWidget {
  const CardOptionHome({
    super.key,
    required this.e,
  });

  final RoutesLocalStorage e;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => e.path),
        );
      },
      child: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: CustomColors.lightIndigo,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            e.icon,
            SizedBox(width: 8,),
            H2Text(
              text: e.title,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            Expanded(child: SizedBox()),
            Icon(Icons.keyboard_arrow_right_outlined)
          ],
        ),
      ),
    );
  }
}
