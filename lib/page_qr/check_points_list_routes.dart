
import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:chasski/offline%20page/page_test_check_point_ar_00.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_01.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_010.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_011.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_012.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_013.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_02.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_020meta.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_03.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_04.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_05.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_06.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_07.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_08.dart';
import 'package:chasski/offline%20page/page_text_check_point_ar_09.dart';
import 'package:chasski/page_chek/page_0_ar_chp_partida.dart';
import 'package:chasski/page_chek/page_10_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_11_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_12_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_13_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_1_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_20meta_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_2_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_3_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_4_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_5_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_6_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_7_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_8_ar_chp_punto.dart';
import 'package:chasski/page_chek/page_9_ar_chp_punto.dart';
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
void navigateToPageCheckPoint(TListChekPoitnsModel e, BuildContext context) {
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
      widget: QrPageAR01ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 1 AR',
    ),
    RouteItem(
      id: '5ntgzohi3kr5ase',
      widget: QrPageAR02ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 2 AR',
    ),
    RouteItem(
      id: 'm3anh9z864y63fb',
      widget: QrPageAR03ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 3 AR',
    ),
    RouteItem(
      id: 'h75cnht29vp8de5',
     widget: QrPageAR04ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 4 AR',
    ),
    RouteItem(
      id: 'noztxcuusci1crk',
      widget: QrPageAR05ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 5 AR',
    ),
    RouteItem(
      id: 'c9oew6cy1m1v38s',
      widget: QrPageAR06ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 6 AR',
    ),
    RouteItem(
      id: 'd4ewx2y855bvsrt',
      widget: QrPageAR07ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 7 AR',
    ),
    RouteItem(
      id: '83xu6fww51kwu57',
      widget: QrPageAR08ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 8 AR',
    ),
    RouteItem(
      id: '7f6ty49z1ktrs6y',
      widget: QrPageAR09ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 9 AR',
    ),
    RouteItem(
      id: '5sx5axq5o6gsrmw',
      widget: QrPageAR010ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 10 AR',
    ),

    RouteItem(
      id: 'sclye36d2q3svge',
      widget: QrPageAR011ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 11 AR',
    ),

    RouteItem(
      id: 'qipt8bi71cocohd',
      widget: QrPageAR012ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 12 AR',
    ),

    RouteItem(
      id: '0t6om1x1rpngkhb',
      widget: QrPageAR013ChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
      name: 'PUNTO 13 AR',
    ),
    RouteItem(
      id: 'oqco8qs0l353oe0',
      widget: QrPageAR020METAChP(
        idCheckPoints: e.id!,
        name: e.nombre,
      ),
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


//METODO DE NAVEGACION DE PAGINA
void navigateToPageCheckPointOflline(TListChekPoitnsModel e, BuildContext context) {
  final List<RouteItem> listRoutes = [
    RouteItem(
      id: 'kgstc7j97oyr246',
      widget: DBCheckPoints00Page(nombre: e.nombre,),
      name: 'PARTIDA AR',
    ),
    RouteItem(
      id: 'lrxb81xucpgwycq',
      widget: DBCheckPoints01Page(nombre: e.nombre,),
      name: 'PUNTO 1 AR',
    ),
    RouteItem(
      id: '5ntgzohi3kr5ase',
      widget: DBCheckPoints02Page(nombre: e.nombre,),
      name: 'PUNTO 2 AR',
    ),
    RouteItem(
      id: 'm3anh9z864y63fb',
     widget: DBCheckPoints03Page(nombre: e.nombre,),
      name: 'PUNTO 3 AR',
    ),
    RouteItem(
      id: 'h75cnht29vp8de5',
    widget: DBCheckPoints04Page(nombre: e.nombre,),
      name: 'PUNTO 4 AR',
    ),
    RouteItem(
      id: 'noztxcuusci1crk',
      widget: DBCheckPoints05Page(nombre: e.nombre,),
      name: 'PUNTO 5 AR',
    ),
    RouteItem(
      id: 'c9oew6cy1m1v38s',
      widget: DBCheckPoints06Page(nombre: e.nombre,),
      name: 'PUNTO 6 AR',
    ),
    RouteItem(
      id: 'd4ewx2y855bvsrt',
      widget: DBCheckPoints07Page(nombre: e.nombre,),
      name: 'PUNTO 7 AR',
    ),
    RouteItem(
      id: '83xu6fww51kwu57',
      widget: DBCheckPoints08Page(nombre: e.nombre,),
      name: 'PUNTO 8 AR',
    ),
    RouteItem(
      id: '7f6ty49z1ktrs6y',
      widget: DBCheckPoints09Page(nombre: e.nombre,),
      name: 'PUNTO 9 AR',
    ),
    RouteItem(
      id: '5sx5axq5o6gsrmw',
     widget: DBCheckPoints010Page(nombre: e.nombre,),
      name: 'PUNTO 10 AR',
    ),

    RouteItem(
      id: 'sclye36d2q3svge',
      widget: DBCheckPoints011Page(nombre: e.nombre,),
      name: 'PUNTO 11 AR',
    ),

    RouteItem(
      id: 'qipt8bi71cocohd',
      widget: DBCheckPoints012Page(nombre: e.nombre,),
      name: 'PUNTO 12 AR',
    ),

    RouteItem(
      id: '0t6om1x1rpngkhb',
      widget: DBCheckPoints013Page(nombre: e.nombre,),
      name: 'PUNTO 13 AR',
    ),
    RouteItem(
      id: 'oqco8qs0l353oe0',
      widget: DBCheckPoints020METAPage(nombre: e.nombre,),
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
