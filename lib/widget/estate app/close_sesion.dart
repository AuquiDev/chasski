import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';

class CloseSesion extends StatelessWidget {
  const CloseSesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: VisualDensity.compact,
        dense: true,
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
        leading: AppSvg(width: 18).cloesesion,
        onTap: () async {
          isSescionClean(context);
        },
        title: const P2Text(
          text: 'Cerrar Sesión',
          color: AppColors.primaryRed,
        ));
  }

  void isSescionClean(BuildContext context) async {
    SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
    // Luego, llama al método setLoggedIn en esa instancia
    await sharedPrefs.logout(context);
    await sharedPrefs.logoutRunner(context);

    await SharedPrefencesGlobal().deleteEmpleado();

    await SharedPrefencesGlobal().deleteParticipante();//NUEVO
  }
}
