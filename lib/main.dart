import 'package:chasski/provider/provider_sql_check_p0.dart';
import 'package:chasski/provider/provider_sql_list_check_points_ar.dart';
import 'package:chasski/provider/provider_sql_runners_ar.dart';
import 'package:chasski/provider/provider_t_check_p0.dart';
import 'package:chasski/provider/provider_t_list_check_ar.dart';
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
        //LISTCHECK POTINS
        ChangeNotifierProvider(
          create: (context) => TListCheckPoitns_ARProvider(),
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
        
         //CHECK POINTS 00 
        ChangeNotifierProvider(
          create: (context) => TCheckP00Provider(),
          lazy: false,
        ),
         //SQL CHECK POINTS 00 
        ChangeNotifierProvider(
          create: (context) => DBCheckP00AppProvider(),
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
