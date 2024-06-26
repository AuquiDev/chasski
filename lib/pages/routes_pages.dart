
// import 'package:chasski/offline%20page/page_test_check_point_ar_00.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_01.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_010.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_011.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_012.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_013.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_02.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_020meta.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_03.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_04.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_05.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_06.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_07.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_08.dart';
// import 'package:chasski/offline%20page/page_text_check_point_ar_09.dart';
import 'package:chasski/offline/page_test_list_check_points.dart';
import 'package:chasski/offline/page_test_runners.dart';
import 'package:chasski/page_qr/page_check_list_list.dart';
import 'package:chasski/page_qr/page_check_points_list.dart';
import 'package:chasski/page_qr/qr_page_listdata_runner.dart';
// import 'package:chasski/pages/user_animated.dart';
import 'package:flutter/material.dart';
import 'package:chasski/offline/page_test_detalletrabajo.dart';
import 'package:chasski/offline/page_text_empelado.dart';



class PageRoutes {
  Icon icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
  
  PageRoutes(
       icon: const Icon(Icons.emoji_people_sharp , color: Color(0xFF207D23),),
      title: "Lista Runner- QR GENERATE",
      path:   const   QrListaRunners(), ),
   PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "Check List",
      path:   CheckListListPage(), ),
  PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
      title: "Check points",
      path:   CheckPotinsListPage(), ),
    
      
   PageRoutes(
       icon: const Icon(Icons.qr_code_scanner , color: Colors.red,),
      title: "SQL - Lista Check points",
      path:   DBListCheckPointsArPage(), ),
  PageRoutes(
       icon: const Icon(Icons.emoji_people_sharp ,  color: Colors.red,),
      title: "SQL - Runners List",
      path:   const DBRunnerspage(), ),
  
      
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR01 - CHP",
  //     path:   const DBCheckPoints01Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR02 - CHP",
  //     path:   const DBCheckPoints02Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR03 - CHP",
  //     path:   const DBCheckPoints03Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR04 - CHP",
  //     path:   const DBCheckPoints04Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR05 - CHP",
  //     path:   const DBCheckPoints05Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR06 - CHP",
  //     path:   const DBCheckPoints06Page(), ),
  //  PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR07 - CHP",
  //     path:   const DBCheckPoints07Page(), ),
  //    PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR08 - CHP",
  //     path:   const DBCheckPoints08Page(), ),
  //    PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR09 - CHP",
  //     path:   const DBCheckPoints09Page(), ),
  //   PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR010 - CHP",
  //     path:   const DBCheckPoints010Page(), ),
  //   PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR011 - CHP",
  //     path:   const DBCheckPoints011Page(), ),

  //  PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR012 - CHP",
  //     path:   const DBCheckPoints012Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR013 - CHP",
  //     path:   const DBCheckPoints013Page(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.offline_bolt , color: Colors.red,),
  //     title: "AR META - CHP",
  //     path:   const DBCheckPoints020METAPage(), ),
  
  
  //  PageRoutes(
  //      icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
  //     title: "Lector CheckP 00",
  //     path:    QrPageRunnersAR00(), ),

    // PageRoutes(
    //    icon: const Icon(Icons.qr_code_scanner , color: Color(0xFF207D23),),
    //   title: "Control Asistencia",
    //   path:   const QrPageAsistencia(), ),
     //Almacenar y SIncronizar data 
   PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "SQL - Usuarios",
      path:   const DBEmpleadoPage(), ),
  // PageRoutes(
  //      icon: const Icon(Icons.cloud_download, color: Colors.red,),
  //     title: "Personal",
  //     path:   const DBPersonalPage(), ),
    
  PageRoutes(
       icon: const Icon(Icons.cloud_download, color: Colors.red,),
      title: "SQL - Grupos",
      path:   const DBDetalletrabajoPage(), ),
  //  PageRoutes(
  //      icon: const Icon(Icons.qr_code, color: Colors.red,),
  //     title: "Qr Generate",
  //     path:   const QrListaPersonal(), ),

  
  
   
 
];
