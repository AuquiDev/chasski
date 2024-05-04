
import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:chasski/page_chek_points/page_0_ar_chp_partida.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/close_page_buton.dart';
import 'package:flutter/material.dart';

class RouteItem {
  final String id;
  final Widget widget;
  final String name;

  RouteItem({required this.id, required this.widget, required this.name});
}

//METODO DE NAVEGACION DE PAGINA
void navigateToPage(TListCheckPoitns_ARModels e, BuildContext context) {
  final List<RouteItem> listRoutes = [
    RouteItem(
      id: 'kgstc7j97oyr246',
      widget: QrPageAR00ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PARTIDA AR',
    ),
    RouteItem(
      id: 'lrxb81xucpgwycq',
      widget: Container(color: Colors.blue),
      name: 'PUNTO 1 AR',
    ),
    RouteItem(
      id: '5ntgzohi3kr5ase',
      widget: Container(color: Colors.red),
      name: 'PUNTO 2 AR',
    ),
    RouteItem(
      id: 'm3anh9z864y63fb',
      widget: Container(color: Colors.green),
      name: 'PUNTO 3 AR',
    ),
    RouteItem(
      id: 'h75cnht29vp8de5',
      widget: Container(color: Colors.indigo),
      name: 'PUNTO 4 AR',
    ),
    RouteItem(
      id: 'noztxcuusci1crk',
      widget: Container(color: Colors.purple),
      name: 'PUNTO 5 AR',
    ),
    RouteItem(
      id: 'c9oew6cy1m1v38s',
      widget: Container(color: Colors.yellow),
      name: 'PUNTO 6 AR',
    ),
    RouteItem(
      id: 'd4ewx2y855bvsrt',
      widget: Container(color: Colors.orange),
      name: 'PUNTO 7 AR',
    ),
    RouteItem(
      id: '83xu6fww51kwu57',
      widget: Container(color: Colors.teal),
      name: 'PUNTO 8 AR',
    ),
    RouteItem(
      id: '7f6ty49z1ktrs6y',
      widget: Container(color: Colors.deepOrange),
      name: 'PUNTO 9 AR',
    ),
    RouteItem(
      id: '5sx5axq5o6gsrmw',
      widget: Container(color: Colors.cyan),
      name: 'PUNTO 10 AR',
    ),

    RouteItem(
      id: 'sclye36d2q3svge',
      widget: Container(color: Colors.grey),
      name: 'PUNTO 11 AR',
    ),

    RouteItem(
      id: 'qipt8bi71cocohd',
      widget: Container(color: Colors.green),
      name: 'PUNTO 12 AR',
    ),

    RouteItem(
      id: '0t6om1x1rpngkhb',
      widget: Container(color: Colors.green),
      name: 'PUNTO 13 AR',
    ),
    RouteItem(
      id: 'oqco8qs0l353oe0',
      widget: Container(color: Colors.green),
      name: 'META AR',
    ),

    // Agrega aquí más rutas según sea necesario
  ];

  Widget? selectWidgetById(String id) {
    RouteItem? selectedRoute = listRoutes.firstWhere(
      (route) => route.id == id,
      orElse: () => RouteItem(
          id: id, widget: Scaffold(
            backgroundColor: Colors.white10,
            body: Stack(
              children: [
                Center(child: H2Text(text: 'No se encontro registro',color: Colors.white,fontSize: 15,)),
                ClosePageButon()
              ],
            ),), 
            name: 'No se Ecnontro Registro'),
    );
    return selectedRoute.widget;
  }

  String selectedId = e.id!;
  Widget? selectedWidget = selectWidgetById(selectedId);

  if (selectedWidget != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => selectedWidget),
    );
  }
}
