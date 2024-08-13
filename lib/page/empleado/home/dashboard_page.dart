import 'package:chasski/page/empleado/check%20poins/offline/lista%20puntos/cp__list_check_points.dart';
import 'package:chasski/page/empleado/offline/empleado/cp__empleado.dart';
import 'package:chasski/page/empleado/offline/runner/cp___participantes.dart';
import 'package:chasski/page/empleado/sheety/widgets/home_runnerdata.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/routes/assets_class_routes_pages.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  PageController _pageController = PageController(viewportFraction: .8);
  String title = 'Sincronizacion de datos';
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int pageIndex = _pageController.page!.round();
      if (_currentPageIndex != pageIndex) {
        setState(() {
          _currentPageIndex = pageIndex;
          title = routes[pageIndex].title;
        });
      }
    });
  }

  List<RoutesLocalStorage> routes = [
    RoutesLocalStorage(
        icon: AppSvg(width: 100).databaseBlue,
        title: "Usuarios",
        path: DBEmpleadoPage(),
        content:
            'Administre y descargue los datos\n de usuarios en su dispositivo.'),
    RoutesLocalStorage(
        icon: AppSvg(width: 100).databaseBlue,
        title: "Puntos de Control",
        path: DBListCheckPointsArPage(),
        content:
            'Administre y almacene los dato\n locales para los puntos de control.'),
    RoutesLocalStorage(
        icon: AppSvg(width: 100).databaseBlue,
        title: "Lista de Participantes",
        path: DBParticiapntespage(),
        content:
            'Descargue y almacene localmente\n la lista de participantes. '),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CacheUsuarioProvider>(context).usuarioEncontrado;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(children: [
              Container(
                margin: EdgeInsets.all(20),
                decoration: decorationBox(color: AppColors.textPrimary),
                child: ListTile(
                  onTap: () {
                    print(user?.rol);
                    if (user?.rol == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SincDataRunnerSheet()),
                      );
                    } else {
                      AssetAlertDialogPlatform.show(
                        context: context,
                        title: 'Acceso Denegado',
                        message:
                            'No cuenta con los permisos necesarios para acceder a este panel.',
                      );
                    }
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: H1Text(
                                text: 'Sincronización de Corredores'
                                    .toUpperCase(),
                                color: Colors.white,
                              ),
                            ),
                            FittedBox(
                              child: P2Text(
                                text:
                                    'Carga la lista de corredores inscritos desde\nGoogle Sheets al servidor. '
                                    '(Solo para administradores.)',
                                textAlign: TextAlign.justify,
                                color: Colors.white,
                              ),
                            ),
                            AppSvg(width: 80).serverBlue,
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white),
                ),
              ),
              ListTile(
                title: H1Text(text: '¡Importante!', fontSize: 25),
                subtitle: FittedBox(
                  child: P2Text(
                    text: 'Descargar los siguientes datos antes de comenzar tus\ntareas como colaborador.' +
                        'Garantiza que la información\nde usuarios esté disponible localmente.',
                    textAlign: TextAlign.justify,
                  ),
                ),
                trailing: Icon(Icons.arrow_downward),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 200),
                decoration: decorationBox(color: AppColors.primaryRed),
                padding: EdgeInsets.all(20),
                child: H3Text(
                  text: title.toUpperCase(),
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: routes
                      .map(
                        (route) => FittedBox(
                          child: Container(
                            padding: const EdgeInsets.all(30.0),
                            decoration:
                                decorationBox(color: AppColors.backgroundDark),
                            margin: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                route.icon,
                                H2Text(
                                  text: route.title,
                                  color: Colors.white,
                                  // fontSize: 25,
                                  maxLines: 2,
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                ),
                                P2Text(
                                    text: route.content ?? '',
                                    color: Colors.white,
                                    textAlign: TextAlign.center),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => route.path),
                                      );
                                    },
                                    child: P1Text(text: 'Comenzar ahora'))
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ]),
            Positioned(
              bottom: 10,
              left: 20,
              child: IconButton.filled(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.backgroundLight,
                ),
                onPressed: _currentPageIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null, // Deshabilita el botón si estamos en la primera página.
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: _currentPageIndex < routes.length - 1
          ? IconButton.filled(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.backgroundLight,
              ),
            )
          : null, // Deshabilita el botón si estamos en la última página.
    );
  }
}


  // Expanded(
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           // Calcular el número de columnas en función del ancho disponible
  //           int crossAxisCount = (constraints.maxWidth / 200).floor();
  //           // Ajusta el tamaño de los elementos
  //           double aspectRatio = constraints.maxWidth / (crossAxisCount * 150);

  //           return GridView.builder(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: crossAxisCount,
  //               childAspectRatio: aspectRatio,
  //               crossAxisSpacing: 8.0,
  //               mainAxisSpacing: 8.0,
  //             ),
  //             padding: EdgeInsets.all(16.0),
  //             itemCount: routes.length,
  //             itemBuilder: (context, index) {
  //               final route = routes[index];
  //               return GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => route.path),
  //                   );
  //                 },
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: route.icon,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         route.title,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ),