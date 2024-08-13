import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/page/empleado/qr%20list%20runner/qr_page_listdata_runner.dart';
import 'package:chasski/page/empleado/check%20list/online/lista%20puntos/page_check_list_list.dart';
import 'package:chasski/page/empleado/check%20poins/lista%20puntos/checkpoint_list.dart';
import 'package:chasski/page/empleado/home/dashboard_page.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider/cache/start%20page/current_page.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/widget/estate%20app/close_sesion.dart';
import 'package:chasski/widget/estate%20app/offline_buton.dart';
import 'package:provider/provider.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 7,
        width: 170,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(.9)),
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserCard(),
                const Expanded(child: ListaOpcionesphone()),
                ModoOfflineClick(),
                SizedBox(
                  height: 30,
                ),
                const CloseSesion(),
              ],
            ),
          ),
        ));
  }
}

class ListaOpcionesphone extends StatelessWidget {
  const ListaOpcionesphone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RoutesLocalStorage> routes = [
     
      RoutesLocalStorage(
        icon: AppSvg().checkListSvg,
        title: "CheckList",
        path: CheckListListPage(),
      ),
      RoutesLocalStorage(
        icon: AppSvg().checkPSvg,
        title: "CheckPoints",
        path: CheckPotinsListPage(),
      ),
      RoutesLocalStorage(
        icon: AppLoties().runnerLoties,
        title: "QR Corredor",
        path: const QrListaRunners(),
      ),
    ];
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final listaRoutes = routes[index];
          if (index == 0) {
            return Column(
              children: [
                inicioButton(context),
                CardMenuPrincipal(listaRoutes: listaRoutes),
              ],
            );
          }
          return CardMenuPrincipal(listaRoutes: listaRoutes);
        });
  }

  Widget inicioButton(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      leading: AppSvg().home1Svg,
      title: const H3Text(
        text: "Home",
      ),
      onTap: () {
        final screensize = MediaQuery.of(context).size;
        if (screensize.width > 900) {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = const Dashboardpage();
        } else {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = const Dashboardpage();
          Navigator.pop(context);
        }
      },
    );
  }
}

class CardMenuPrincipal extends StatelessWidget {
  const CardMenuPrincipal({
    super.key,
    required this.listaRoutes,
  });

  final RoutesLocalStorage listaRoutes;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      // dense: true,
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
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
  });
  final double size = 80;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CacheUsuarioProvider>(context).usuarioEncontrado ??
        tEmpleadoModelDefault();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GLobalImageUrlServer(
          duration: 500,
          fadingDuration: 600,
          image: user?.sexo ?? ' ',
          collectionId: user.collectionId ?? '',
          id: user.id ?? "",
          borderRadius: BorderRadius.circular(600),
          height: size,
          width: size,
        ),
        H2Text(
          text: user.nombre,
          fontSize: 16,
        ),
        P2Text(
          text: user.rol,
        ),
      ],
    );
  }
}
