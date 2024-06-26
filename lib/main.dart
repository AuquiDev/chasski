import 'package:chasski/provider/provider_sql_checkp_ar_00.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_01.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_010.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_011.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_012.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_013.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_02.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_020meta.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_03.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_04.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_05.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_06.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_07.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_08.dart';
import 'package:chasski/provider/provider_sql_checkp_ar_09.dart';
import 'package:chasski/provider/provider_sql_list_check_points_ar.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_checklist_01.dart';
import 'package:chasski/provider/provider_t_checklist_02.dart';
import 'package:chasski/provider/provider_t_checklist_03.dart';
import 'package:chasski/provider/provider_t_checklist_04.dart';
import 'package:chasski/provider/provider_t_checklist_05.dart';
import 'package:chasski/provider/provider_t_checklist_06.dart';
import 'package:chasski/provider/provider_t_checklist_07.dart';
import 'package:chasski/provider/provider_t_checklist_08.dart';
import 'package:chasski/provider/provider_t_checkp_ar_00.dart';
import 'package:chasski/provider/provider_t_checkp_ar_01.dart';
import 'package:chasski/provider/provider_t_checkp_ar_010.dart';
import 'package:chasski/provider/provider_t_checkp_ar_011.dart';
import 'package:chasski/provider/provider_t_checkp_ar_012.dart';
import 'package:chasski/provider/provider_t_checkp_ar_013.dart';
import 'package:chasski/provider/provider_t_checkp_ar_02.dart';
import 'package:chasski/provider/provider_t_checkp_ar_020meta.dart';
import 'package:chasski/provider/provider_t_checkp_ar_03.dart';
import 'package:chasski/provider/provider_t_checkp_ar_04.dart';
import 'package:chasski/provider/provider_t_checkp_ar_05.dart';
import 'package:chasski/provider/provider_t_checkp_ar_06.dart';
import 'package:chasski/provider/provider_t_checkp_ar_07.dart';
import 'package:chasski/provider/provider_t_checkp_ar_08.dart';
import 'package:chasski/provider/provider_t_checkp_ar_09.dart';
import 'package:chasski/provider/provider_t_list_check_list.dart';
import 'package:chasski/provider/provider_t_list_check_points.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/provider_cache/current_page.dart';
import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/provider/provider_t_asistencia.dart';
import 'package:chasski/provider/provider_t_detalle_trabajo.dart';
import 'package:chasski/provider/provider_t_empleado.dart';
import 'package:chasski/zplashScreen/welcome_page.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefencesGlobal prefs = SharedPrefencesGlobal();
  await prefs.initSharedPreferecnes();
  // Bloquear la rotación de la pantalla en toda la aplicación
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LayoutModel(),
        ),
        //USUARIO CACHE
        // TABLA DETALLE DE TRABAJO
        ChangeNotifierProvider(
          create: (context) => TDetalleTrabajoProvider(),
          lazy: false,
        ),
        // ChangeNotifierProvider(create: (context)=> AndesRaceProvider(), lazy: false,),
        //USUARIO CACHE
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider(),
          lazy: false,
        ),
        // TABLA EMPLEADO
        ChangeNotifierProvider(
          create: (context) => TEmpleadoProvider(),
          lazy: false,
        ),
        // TABLA ASISTENCIA
        ChangeNotifierProvider(
          create: (context) => TAsistenciaProvider(),
          lazy: false,
        ),
        // OOFLINETABLA SQLAsitencia
        ChangeNotifierProvider(
          create: (context) => DBAsistenciaAppProvider(),
          lazy: false,
        ),
        //OFFLINE DETALLE GRUPO
        ChangeNotifierProvider(
          create: (context) => DBDetalleGrupoProvider(),
          lazy: false,
        ),
        //OFFLINE SQLEMPLEADO Y GRUPO
        ChangeNotifierProvider(
          create: (context) => DBEMpleadoProvider(),
          lazy: false,
        ),
        
        //LISTCHECK LIST SIN OFFLINE
        ChangeNotifierProvider(
          create: (context) => TListCheckListProvider(),
          lazy: false,
        ),
        //LISTCHECK POTINS
        ChangeNotifierProvider(
          create: (context) => TListCheckPoitnsProvider(),
          lazy: false,
        ),
        //OFFLINE LISTCHECK POINTS
        ChangeNotifierProvider(
          create: (context) => DBTListCheckPoitns_ARProvider(),
          lazy: false,
        ),

        //OFFLINE DBRUNNERS APP
        ChangeNotifierProvider(
          create: (context) => DBRunnersAppProvider(),
          lazy: false,
        ),

        //RUNNERS 
        ChangeNotifierProvider(
          create: (context) => TRunnersProvider(),
          lazy: false,
        ),
        
         //CHECK LIST 01
        ChangeNotifierProvider(
          create: (context) => TCheckList01Provider(),
          lazy: false,
        ),
        //CHECK LIST 02
        ChangeNotifierProvider(
          create: (context) => TCheckList02Provider(),
          lazy: false,
        ),
         //CHECK LIST 03
        ChangeNotifierProvider(
          create: (context) => TCheckList03Provider(),
          lazy: false,
        ),
         //CHECK LIST 04
        ChangeNotifierProvider(
          create: (context) => TCheckList04Provider(),
          lazy: false,
        ),
         //CHECK LIST 05
        ChangeNotifierProvider(
          create: (context) => TCheckList05Provider(),
          lazy: false,
        ),
          //CHECK LIST 06
        ChangeNotifierProvider(
          create: (context) => TCheckList06Provider(),
          lazy: false,
        ),

         //CHECK LIST 07
        ChangeNotifierProvider(
          create: (context) => TCheckList07Provider(),
          lazy: false,
        ),
         //CHECK LIST 08
        ChangeNotifierProvider(
          create: (context) => TCheckList08Provider(),
          lazy: false,
        ),




         //CHECK POINTS 00 
        ChangeNotifierProvider(
          create: (context) => TCheckP00Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 00 
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr00(),
          lazy: false,
        ),
        //CHECK POINTS 01 
        ChangeNotifierProvider(
          create: (context) => TCheckP01Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 01
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr01(),
          lazy: false,
        ),
         //CHECK POINTS 02
        ChangeNotifierProvider(
          create: (context) => TCheckP02Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 02
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr02(),
          lazy: false,
        ),

         //CHECK POINTS 03
        ChangeNotifierProvider(
          create: (context) => TCheckP03Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 03
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr03(),
          lazy: false,
        ),

        //CHECK POINTS 04
        ChangeNotifierProvider(
          create: (context) => TCheckP04Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 04
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr04(),
          lazy: false,
        ),

        //CHECK POINTS 05
        ChangeNotifierProvider(
          create: (context) => TCheckP05Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 05
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr05(),
          lazy: false,
        ),

        //CHECK POINTS 06
        ChangeNotifierProvider(
          create: (context) => TCheckP06Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 06
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr06(),
          lazy: false,
        ),

        //CHECK POINTS 07
        ChangeNotifierProvider(
          create: (context) => TCheckP07Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 07
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr07(),
          lazy: false,
        ),

         //CHECK POINTS 08
        ChangeNotifierProvider(
          create: (context) => TCheckP08Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 08
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr08(),
          lazy: false,
        ),

         //CHECK POINTS 09
        ChangeNotifierProvider(
          create: (context) => TCheckP09Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 09
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr09(),
          lazy: false,
        ),

         //CHECK POINTS 010
        ChangeNotifierProvider(
          create: (context) => TCheckP010Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 010
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr010(),
          lazy: false,
        ),

        //CHECK POINTS 011
        ChangeNotifierProvider(
          create: (context) => TCheckP011Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 011
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr011(),
          lazy: false,
        ),

         //CHECK POINTS 012
        ChangeNotifierProvider(
          create: (context) => TCheckP012Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 012
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr012(),
          lazy: false,
        ),

        //CHECK POINTS 013
        ChangeNotifierProvider(
          create: (context) => TCheckP013Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 013
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr013(),
          lazy: false,
        ),

        //CHECK POINTS 0META
        ChangeNotifierProvider(
          create: (context) => TCheckP020METAProvider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 0META
        ChangeNotifierProvider(
          create: (context) => DBCheckPointsAppProviderAr0META(),
          lazy: false,
        ),

      ],
      builder: (context, _) {
        return const MyApp();
      },
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Andes Race App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme:
            AppBarTheme(elevation: 0, surfaceTintColor: Colors.transparent),
        /*
      VisualDensity.adaptivePlatformDensity ayuda a que los botones, textos y 
      otros elementos en la aplicación se vean bien y sean fáciles de usar en cualquier 
      dispositivo, ajustando la apariencia para que se adapte y 
      se vea bien sin importar el tamaño de la pantalla o la densidad de píxeles. */
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplahScreen(),
    );
  }
}
