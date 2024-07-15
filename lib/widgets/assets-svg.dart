import 'package:chasski/widgets/assets_colors.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg {
  final double width;

  AppSvg({this.width = 30});
  //IMAGENES FONDO APP
  late final menusvg = SvgPicture.asset(
    'assets/img/menu.svg',
    width: width,
    color: AppColors.backgroundDark,
  );

  late final cloesesion = SvgPicture.asset(
    "assets/img/off.svg",
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
    "assets/img/certificado.svg",
    width: width,
  );

  late final checkSvg = SvgPicture.asset(
    "assets/img/check.svg",
    width: width,
  );

  late final checkListSvg = SvgPicture.asset(
    "assets/img/checkList.svg",
    width: width,
  );

  late final checkPointsSvg = SvgPicture.asset(
    "assets/img/checkp.svg",
    width: width,
  );

  late final configsSvg = SvgPicture.asset(
    "assets/img/config1.svg",
    width: width,
  );
  late final editUserSvg = SvgPicture.asset(
    "assets/img/edit_user.svg",
    width: width,
  );

  late final localInfoSvg = SvgPicture.asset(
    "assets/img/local_info.svg",
    width: width,
  );

  late final markerSvg = SvgPicture.asset(
    "assets/img/marker.svg",
    width: width,
  );

  late final notificationSvg = SvgPicture.asset(
    "assets/img/notification.svg",
    width: width,
  );

  late final personSvg = SvgPicture.asset(
    "assets/img/person.svg",
    width: width,
  );

  late final homeSvg = SvgPicture.asset(
    "assets/img/home.svg",
    width: width,
  );

  late final home1Svg = SvgPicture.asset(
    "assets/img/homes.svg",
    width: width,
  );

  late final likeSvg = SvgPicture.asset(
    "assets/img/like.svg",
    width: width,
  );

  late final fileSvg = SvgPicture.asset(
    "assets/img/file.svg",
    width: width,
  );

  late final equipajeSvg = SvgPicture.asset(
    "assets/img/equipaje.svg",
    width: width,
  );

  late final pdfSvg = SvgPicture.asset(
    "assets/svg/pdf.svg",
    width: width,
  );
}
