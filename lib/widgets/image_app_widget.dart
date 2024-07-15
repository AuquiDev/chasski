
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/models/model_t_empleado.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

Container imagenLogo() {
  return Container(
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/img/runner.png',
            
          ),
        ),
        color: Colors.black),
  );
}


// Container imagenLogo() {
//   return Container(
//     decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         image: DecorationImage(
//           fit: BoxFit.fitHeight,
//           image: AssetImage(
//             'assets/img/logo_smallar.png',
//           ),
//         ),
//         color: Colors.black12),
//   );
// }

//IMAGEN EVENTO 
class ImageEvent extends StatelessWidget {
  const ImageEvent({
    super.key,
    required this.user,
    required this.size,
  });

  final TEventoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 300),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(300),
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: user?.logoSmall != null &&
                  user?.logoSmall is String &&
                  user!.logoSmall!.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.logoSmall}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      ),
    );
  }
}

//IMAGEN LOGIN EMPLEADO 

class ImageLoginUser extends StatelessWidget {
  const ImageLoginUser({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300),
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: user?.imagen != null &&
                  user?.imagen is String &&
                  user!.imagen!.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.imagen}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      ),
    );
  }
}

//IMAHEN RUNNER LOGIN 

class ImageLoginRunner extends StatelessWidget {
  const ImageLoginRunner({
    super.key,
    required this.user,
    required this.size,
  });

  final TRunnersModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300),
        child: CachedNetworkImage(
          // ignore: unnecessary_null_comparison, unnecessary_type_check
          imageUrl: user?.imagen != null &&
                  user?.imagen is String &&
                  user!.imagen!.isNotEmpty
              ? 'https://andes-race-challenge.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.imagen}'
              : 'https://via.placeholder.com/300',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              imagenLogo(), // Widget a mostrar si hay un error al cargar la imagen
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      ),
    );
  }
}