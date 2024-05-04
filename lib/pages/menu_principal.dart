import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/pages/t_empleado_login.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider_cache/current_page.dart';
import 'package:chasski/pages/homepage.dart';
import 'package:chasski/pages/routes_pages.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/cerrar_sesion.dart';
import 'package:chasski/widgets/offline_buton.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentImage =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Drawer(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              UserCard(
              user: currentImage,
              size: 150,
            ),
            // ImageLoginUser(
            //   user: currentImage,
            //   size: 50,
            // ),
            const ButtonInicio(),
            
            const Expanded(child: ListaOpcionesphone()),
            const ModoOfflineClick(),
            const CloseSesion(),
          ],
        ),
      ),
    ));
  }
}


class ButtonInicio extends StatelessWidget {
  const ButtonInicio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.all(0),
      leading: const Icon(Icons.home),
      title: const H2Text(
        text: "Principal",
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      onTap: () {
        final screensize = MediaQuery.of(context).size;
        if (screensize.width > 900) {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = const HomePage();
        } else {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = const HomePage();
          Navigator.pop(context);
        }
      },
    );
  }
}


class ListaOpcionesphone extends StatelessWidget {
  const ListaOpcionesphone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: routes.length,
        separatorBuilder: (context, index) => const Divider(
              height: 0,
              thickness: 0,
            ),
        itemBuilder: (context, index) {
          final listaRoutes = routes[index];
          if (index == 4) {
            return Column(
              children: [
                  
                const ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  minLeadingWidth: 1,
                  leading: Icon(
                    Icons.sync,
                    color: Colors.blue,
                    size: 40,
                  ),
                  title: H2Text(
                    text: 'Sincronización de Datos',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: H2Text(
                    text:
                        'Administra y sincroniza datos locales cuando tienes conexión a internet.',
                    fontSize: 12,
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Image.asset('assets/img/sincronizacion.png'),
                CardMenuPrincipal(listaRoutes: listaRoutes),
              ],
            );
          } else if (index == 7) {
            return Column(
              children: [
                const ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    leading: Icon(
                      Icons.cloud_download,
                      color: Colors.blue,
                      size: 40,
                    ),
                    minLeadingWidth: 1,
                    title: H2Text(
                      text: 'Almacenamiento Local',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: H2Text(
                      text:
                          'Administra y almacena datos locales del servidor para su uso offline.',
                      fontSize: 12,
                      maxLines: 4,
                      fontWeight: FontWeight.normal,
                    )),
                Image.asset('assets/img/loadinLocal.png'),
                CardMenuPrincipal(listaRoutes: listaRoutes),
              ],
            );
          }
          return DelayedDisplay(
            delay: const Duration(milliseconds: 400),
            child: CardMenuPrincipal(listaRoutes: listaRoutes));
        });
  }
}
// 70031725
// albert2024

class CardMenuPrincipal extends StatelessWidget {
  const CardMenuPrincipal({
    super.key,
    required this.listaRoutes,
  });

  final PageRoutes listaRoutes;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      leading: listaRoutes.icon,
      title: H2Text(
        text: listaRoutes.title,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      onTap: () {
        final screensize = MediaQuery.of(context).size;
        if (screensize.width > 900) {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = listaRoutes.path;
        } else {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = listaRoutes.path;
          Navigator.pop(context);
        }
        // Navigator.push(context,
        //     MaterialPageRoute(builder: ((context) => listaRoutes.path)));
      },
    );
  }
}


class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetCircularAnimator(
            size: 65,
            innerColor: Color(0xFFD41407),
            outerColor: Color(0xFFED3E3E),
            outerAnimation: Curves.elasticInOut,
            child: DelayedDisplay(
                delay: const Duration(seconds: 1),
                child: UserImage(user: user, size: size))),
        H2Text(
          text: user == null ? 'Visitante' : user!.nombre,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        user == null
            ? const SizedBox()
            : H2Text(
                text: user!.rol,
                fontSize: 12,
              ),
      ],
    );
  }
}


class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: user == null
          ? imagenLogo()
          : ImageLoginUser(
              user: user,
              size: size,
            ),
    );
  }
}

Container imagenLogo() {
  return Container(
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/img/logo_smallar.png',
          ),
        ),
        color: Colors.black12),
  );
}
