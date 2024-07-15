
import 'package:chasski/widgets/image_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:chasski/pages/t_empleado_login.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';



class CloseSesion extends StatelessWidget {
  const CloseSesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentImage = Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Card(
       surfaceTintColor: Colors.white,
      elevation: 1,
      child: ListTile(
         visualDensity: VisualDensity.compact,
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
             ImageLoginUser(
                  user: currentImage,
                  size: 30,
                ),
              const SizedBox(width: 10,),
            const H2Text(
              text: 'Cerrar Sesión',
              fontSize: 11,
            ),
          ],
        ),
        // ignore: deprecated_member_use
        trailing: SvgPicture.asset("assets/img/off.svg", width: 20,color: Colors.red,),
      ),
    );
  }
}