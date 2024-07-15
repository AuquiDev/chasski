
import 'package:chasski/models/model_list_check_list_ar.dart';
// import 'package:chasski/page_chek/page_0_ar_chp_partida.dart';
import 'package:chasski/page_chek/page_check_list_01.dart';
import 'package:chasski/page_chek/page_check_list_02.dart';
import 'package:chasski/page_chek/page_check_list_03.dart';
import 'package:chasski/page_chek/page_check_list_04.dart';
import 'package:chasski/page_chek/page_check_list_05.dart';
import 'package:chasski/page_chek/page_check_list_06.dart';
import 'package:chasski/page_chek/page_check_list_07.dart';
import 'package:chasski/page_chek/page_check_list_08.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/close_page_buton.dart';
import 'package:flutter/material.dart';

class RouteItem {
  final String id;
  final Widget widget;
  final String name;

  RouteItem({required this.id, required this.widget, required this.name});
}

//METODO DE NAVEGACION DE PAGINA
void navigateToPageCheckList(TListChekListModel e, BuildContext context) {
  final List<RouteItem> listRoutes = [
    RouteItem(
      id: 'hc8by7kojyrg9t0',
      widget: QrPage01ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '0) Capacitación charla Informativa',
    ),
    RouteItem(
      id: 'vjyalwfxxtga6rr', 
       widget: QrPage02ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '1) Adjuntar Documento de Deslinde',
    ),
    RouteItem(
      id: 'g64lhqza9ycf5hy',
      widget: QrPage03ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '2) Entrega de Kit',
    ),
    RouteItem(
      id: 'dnwj2q4074df1m8',
       widget: QrPage04ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '3) Recepción de Equipaje ',
    ),
    RouteItem(
      id: 'w75bfoqbg6ykhff',
      widget: QrPage05ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '4) Control de Buses',
    ),
    RouteItem(
      id: 'leu0y5wfsrg6cfw',
      widget: QrPage06ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '5) Entrega de Medalla',
    ),
    RouteItem(
      id: 'cdr1c70cymg4ywt',
       widget: QrPage07ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '6) Entrega de Ropa de Finisher',
    ),
    RouteItem(
      id: 'xg6rawbv6m6s8ai',
       widget: QrPage08ChList(
        idCheckList: e.id!,
        name: e.nombre,
      ),
      name: '7) Devolución de Equipaje',
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



