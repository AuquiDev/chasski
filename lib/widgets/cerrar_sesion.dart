
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:flutter_svg/svg.dart';

class CloseSesion extends StatelessWidget {
  const CloseSesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        onTap: () async {
          SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
          // Luego, llama al método setLoggedIn en esa instancia
          await sharedPrefs.logout(context);
          await sharedPrefs.logoutRunner(context);

          await SharedPrefencesGlobal().deleteId();
          await SharedPrefencesGlobal().deleteIDEvento();
          await SharedPrefencesGlobal().deleteIDDistancia();
          await SharedPrefencesGlobal().deleteNombre();
          await SharedPrefencesGlobal().deleteNombreRun();
          await SharedPrefencesGlobal().deleteApellidos();
          await SharedPrefencesGlobal().deleteImage();
          await SharedPrefencesGlobal().deleteImageRun();
          await SharedPrefencesGlobal().deletePais();
          await SharedPrefencesGlobal().deleteRol();
          await SharedPrefencesGlobal().deleteTallaPolo();
          await SharedPrefencesGlobal().deleteCollectionID();
          await SharedPrefencesGlobal().deleteDorsal();
        },
        title: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const P2Text(
              text: 'Cerrar Sesión',
            ),
          ],
        ),
        trailing: AppSvg().cloesesion
      ),
    );
  }
}
