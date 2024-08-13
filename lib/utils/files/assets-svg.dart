import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg {
  String pdfv = 'assets/svg/menu.svg';
  final double width;

  AppSvg({this.width = 30});
  //IMAGENES FONDO APP
  late final menusvg = SvgPicture.asset(
    'assets/svg/menu.svg',
    width: width,
  );

   late final poloSvg = SvgPicture.asset(
    'assets/svg/polo.svg',
    width: width,
  );

   late final generoSvg = SvgPicture.asset(
    'assets/svg/genero.svg',
    width: width,
  );

  late final pasaporteSvg = SvgPicture.asset(
    'assets/svg/pasaporte.svg',
    width: width,
  );
  
  late final timeSvg = SvgPicture.asset(
    'assets/svg/progress.svg',
    width: width,
  );

  late final cloesesion = SvgPicture.asset(
    "assets/svg/off.svg",
    width: width,
    color: AppColors.primaryRed,
  );

  late final whatsappSvg = SvgPicture.asset(
    "assets/svg/whatsapp.svg",
    width: width,
  );

  late final editSvg = SvgPicture.asset(
    "assets/svg/edit.svg",
    width: 30,
  );

  late final certificadoSgv = SvgPicture.asset(
    "assets/svg/certificado.svg",
    width: width,
  );

  late final checkSvg = SvgPicture.asset(
    "assets/svg/check.svg",
    width: width,
  );
   

  late final checkListSvg = SvgPicture.asset(
    "assets/svg/checkList.svg",
    width: width,
  );

  late final checkPSvg = SvgPicture.asset(
    "assets/svg/checkp.svg",
    width: width,
    color: AppColors.primaryRed,
  );
  late final checkPointsSvg = SvgPicture.asset(
    "assets/svg/check_point.svg",
    width: width,
  );
  late final runSvg = SvgPicture.asset(
    "assets/svg/run.svg",
    width: width,
  );

  late final configSyncBlue = SvgPicture.asset(
    "assets/svg/config1.svg",
    width: width,
  );
  

  late final localInfoSvg = SvgPicture.asset(
    "assets/svg/local_info.svg",
    width: width,
  );

  late final markerSvg = SvgPicture.asset(
    "assets/svg/marker.svg",
    width: width,
  );

  late final notificationSvg = SvgPicture.asset(
    "assets/svg/notification.svg",
    width: width,
  );

  late final personSvg = SvgPicture.asset(
    "assets/svg/person.svg",
    width: width,
  );

  late final home1Svg = SvgPicture.asset(
    "assets/svg/homes.svg",
    width: width,
  );

  late final likeSvg = SvgPicture.asset(
    "assets/svg/like.svg",
    width: width,
  );

  late final fileSvg = SvgPicture.asset(
    "assets/svg/file.svg",
    width: width,
  );

  late final equipajeSvg = SvgPicture.asset(
    "assets/svg/equipaje.svg",
    width: width,
  );
  //CARPETA SVG
  late final pdfSvg = SvgPicture.asset(
    "assets/svg/pdf.svg",
    width: width,
  );

  late final databaseBlue = SvgPicture.asset(
    "assets/svg/databaseBlue.svg",
    width: width,
  );
  late final serverBlue = SvgPicture.asset(
    "assets/svg/serverBlue.svg",
    width: width,
  );
   late final printerBlue = SvgPicture.asset(
    "assets/svg/printerBlue.svg",
    width: width,
  );
   late final configBlue = SvgPicture.asset(
    "assets/svg/configBlue.svg",
    width: width,
  );
   late final monitorBlue = SvgPicture.asset(
    "assets/svg/monitorBlue.svg",
    width: width,
  );

  late final sheety = SvgPicture.asset(
    "assets/svg/sheety.svg",
    width: width,
  );
}
