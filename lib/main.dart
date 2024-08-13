import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/provider/producto/provider_t_productoapp.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/cache/idEvento/provider_id_evento.dart';
import 'package:chasski/provider/runners/offline/provider_sql___participantes.dart';
import 'package:chasski/provider/vista%20runner/provider_v_tabla_participantes.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp0.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp1.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp10.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp11.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp12.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp13.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp2.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp14.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp3.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp4.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp5.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp6.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp7.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp8.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp9.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql__list_chkpoint.dart';
import 'package:chasski/provider/check%20list/provider_cl01.dart';
import 'package:chasski/provider/check%20list/provider_cl02.dart';
import 'package:chasski/provider/check%20list/provider_cl03.dart';
import 'package:chasski/provider/check%20list/provider_cl04_beta_imagenes.dart';
import 'package:chasski/provider/check%20list/provider_cl05.dart';
import 'package:chasski/provider/check%20list/provider_cl06.dart';
import 'package:chasski/provider/check%20list/provider_cl07.dart';
import 'package:chasski/provider/check%20list/provider_cl08_beta_imagenes.dart';
import 'package:chasski/provider/check%20point/online/provider_cp00.dart';
import 'package:chasski/provider/check%20point/online/provider_cp01.dart';
import 'package:chasski/provider/check%20point/online/provider_cp10.dart';
import 'package:chasski/provider/check%20point/online/provider_cp11.dart';
import 'package:chasski/provider/check%20point/online/provider_cp12.dart';
import 'package:chasski/provider/check%20point/online/provider_cp13.dart';
import 'package:chasski/provider/check%20point/online/provider_cp02.dart';
import 'package:chasski/provider/check%20point/online/provider_cp14.dart';
import 'package:chasski/provider/check%20point/online/provider_cp03.dart';
import 'package:chasski/provider/check%20point/online/provider_cp04.dart';
import 'package:chasski/provider/check%20point/online/provider_cp05.dart';
import 'package:chasski/provider/check%20point/online/provider_cp06.dart';
import 'package:chasski/provider/check%20point/online/provider_cp07.dart';
import 'package:chasski/provider/check%20point/online/provider_cp08.dart';
import 'package:chasski/provider/check%20point/online/provider_cp09.dart';
import 'package:chasski/provider/distancia/provider_t_distancias_ar.dart';
import 'package:chasski/provider/evento/provider_t_evento_ar.dart';
import 'package:chasski/provider/check%20list/provider__t_list_cheklist.dart';
import 'package:chasski/provider/check%20point/online/provider__list_chkpoint.dart';
import 'package:chasski/provider/sponsor/provider_t_sponsors.dart';
import 'package:chasski/provider/cache/qr%20validation/provider_qr_statescan.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chasski/provider/cache/start%20page/current_page.dart';
import 'package:chasski/provider/empleado/offline/provider_sql__empelado.dart';
import 'package:chasski/provider/cache/empleado/provider_cache.dart';
import 'package:chasski/provider/empleado/online/provider_t_empleado.dart';
import 'package:chasski/page/initial/plashScreen/welcome_page.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  //INICALIZAR FECHA Y HORA:
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Lima'));

  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferencesGlobal
  SharedPrefencesGlobal prefs = SharedPrefencesGlobal();
  await prefs.initSharedPreferecnes();

  // Inicializar TextToSpeechService
  TextToSpeechService textToSpeechService = TextToSpeechService();
  await textToSpeechService.initializeTts(); // Usar el singleton

  // Bloquear la rotación de la pantalla en toda la aplicación
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //FIREBASE
  // WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp().then((value) {
  // await Firebase.initializeApp();
  runApp(const AppState());
  // });
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
        //Runner QRScannState
        ChangeNotifierProvider(
          create: (context) => RunnerQrScanState(),
          lazy: false,
        ),
        //USUARIO CACHE
        ChangeNotifierProvider(
          create: (context) => CacheUsuarioProvider(),
          lazy: false,
        ),
        //RUNNER OfflineStateProvider
        ChangeNotifierProvider(
          create: (context) => OfflineStateProvider(),
          lazy: false,
        ),
        //ParticpantesProvider
        ChangeNotifierProvider(
          create: (context) => CacheParticpantesProvider(),
          lazy: false,
        ),

        // TABLA EMPLEADO
        ChangeNotifierProvider(
          create: (context) => TEmpleadoProvider(),
          lazy: false,
        ),
        //PRUEBA DISTANCIAS 10K
        ChangeNotifierProvider(
          create: (context) => TDistanciasArProvider(),
          lazy: false,
        ),
        //PRUEBA EVENTO
        ChangeNotifierProvider(
          create: (context) => TEventoArProvider(),
          lazy: false,
        ),
        //OFFLINE SQLEMPLEADO Y GRUPO
        ChangeNotifierProvider(
          create: (context) => DBEmpleadoProvider(),
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
          create: (context) => DBTListCheckPoitnsProvider(),
          lazy: false,
        ),

        // //OFFLINE DBRUNNERS APP
        // ChangeNotifierProvider(
        //   create: (context) => RunnerData(),
        //   lazy: false,
        // ),

        //PRODUCTOS
        ChangeNotifierProvider(
          create: (context) => TProductosAppProvider(),
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
          create: (context) => DBChPProvider00(),
          lazy: false,
        ),
        //CHECK POINTS 01
        ChangeNotifierProvider(
          create: (context) => TCheckP01Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 01
        ChangeNotifierProvider(
          create: (context) => DBChPProvider01(),
          lazy: false,
        ),
        //CHECK POINTS 02
        ChangeNotifierProvider(
          create: (context) => TCheckP02Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 02
        ChangeNotifierProvider(
          create: (context) => DBChPProvider02(),
          lazy: false,
        ),

        //CHECK POINTS 03
        ChangeNotifierProvider(
          create: (context) => TCheckP03Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 03
        ChangeNotifierProvider(
          create: (context) => DBChPProvider03(),
          lazy: false,
        ),

        //CHECK POINTS 04
        ChangeNotifierProvider(
          create: (context) => TCheckP04Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 04
        ChangeNotifierProvider(
          create: (context) => DBChPProvider04(),
          lazy: false,
        ),

        //CHECK POINTS 05
        ChangeNotifierProvider(
          create: (context) => TCheckP05Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 05
        ChangeNotifierProvider(
          create: (context) => DBChPProvider05(),
          lazy: false,
        ),

        //CHECK POINTS 06
        ChangeNotifierProvider(
          create: (context) => TCheckP06Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 06
        ChangeNotifierProvider(
          create: (context) => DBChPProvider06(),
          lazy: false,
        ),

        //CHECK POINTS 07
        ChangeNotifierProvider(
          create: (context) => TCheckP07Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 07
        ChangeNotifierProvider(
          create: (context) => DBChPProvider07(),
          lazy: false,
        ),

        //CHECK POINTS 08
        ChangeNotifierProvider(
          create: (context) => TCheckP08Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 08
        ChangeNotifierProvider(
          create: (context) => DBChPProvider08(),
          lazy: false,
        ),

        //CHECK POINTS 09
        ChangeNotifierProvider(
          create: (context) => TCheckP09Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 09
        ChangeNotifierProvider(
          create: (context) => DBChPProvider09(),
          lazy: false,
        ),

        //CHECK POINTS 010
        ChangeNotifierProvider(
          create: (context) => TCheckP010Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 010
        ChangeNotifierProvider(
          create: (context) => DBChPProvider10(),
          lazy: false,
        ),

        //CHECK POINTS 011
        ChangeNotifierProvider(
          create: (context) => TCheckP011Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 011
        ChangeNotifierProvider(
          create: (context) => DBChPProvider11(),
          lazy: false,
        ),

        //CHECK POINTS 012
        ChangeNotifierProvider(
          create: (context) => TCheckP012Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 012
        ChangeNotifierProvider(
          create: (context) => DBChPProvider12(),
          lazy: false,
        ),

        //CHECK POINTS 013
        ChangeNotifierProvider(
          create: (context) => TCheckP013Provider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 013
        ChangeNotifierProvider(
          create: (context) => DBChPProvider13(),
          lazy: false,
        ),

        //CHECK POINTS 0META
        ChangeNotifierProvider(
          create: (context) => TCheckP020METAProvider(),
          lazy: false,
        ),
        //SQL CHECK POINTS 0META
        ChangeNotifierProvider(
          create: (context) => DBChPProvider14(),
          lazy: false,
        ),

        //Sponsor Server
        ChangeNotifierProvider(
          create: (context) => TSponsorsProvider(),
          lazy: false,
        ),

        //Participantes 2024 - sheety
        ChangeNotifierProvider(
          create: (context) => ParticipantesProviderSheety(),
          lazy: false,
        ),
        //Participantes 2024 - Poketbase
        ChangeNotifierProvider(
          create: (context) => TParticipantesProvider(),
          lazy: false,
        ),

        ///DBParticiapntesAppProvider
        ChangeNotifierProvider(
          create: (context) => DBParticiapntesAppProvider(),
          lazy: false,
        ),
        //VTabla Participantes
        ChangeNotifierProvider(
          create: (context) => VTablaParticipantesProvider(),
          lazy: false,
        ),
        // EventIdProvider
        ChangeNotifierProvider(
          create: (context) => EventIdProvider(),
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
        colorScheme: ColorScheme(
          primary: AppColors.primaryRed,
          primaryContainer: AppColors.primaryRed.withOpacity(0.8),
          secondary: AppColors.accentColor,
          secondaryContainer: AppColors.accentColor.withOpacity(0.8),
          surface: AppColors.backgroundLight,
          error: Colors.red,
          onPrimary: AppColors.primaryWhite,
          onSecondary: AppColors.primaryWhite,
          onSurface: AppColors.textPrimary,
          onError: AppColors.primaryWhite,
          brightness: Brightness.light,
        ),
        fontFamily: 'Quicksand',
        // Definiendo el tema de los botones
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.buttonPrimary,
          textTheme: ButtonTextTheme.primary,
        ),
        // Definiendo el tema de AppBar
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryRed,
          titleTextStyle: TextStyle(
            color: AppColors.primaryWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryWhite),
        ),
        // Definiendo el tema de los iconos
        iconTheme: const IconThemeData(color: AppColors.primaryRed),
        // Definiendo el tema de los inputs (TextField)
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundLight,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryRed),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textSecondary),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
