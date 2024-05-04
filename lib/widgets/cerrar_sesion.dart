
import 'package:flutter/material.dart';
import 'package:chasski/pages/t_empleado_login.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
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
      elevation: 10,
      child: ListTile(
         visualDensity: VisualDensity.compact,
        onTap: () async {
          SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
          // Luego, llama al método setLoggedIn en esa instancia
          await sharedPrefs.logout(context);
          await SharedPrefencesGlobal().deleteImage();
          await SharedPrefencesGlobal().deleteNombre();
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
        trailing: const Icon(Icons.logout,color: Colors.red,),
      ),
    );
  }
}