// database_initializer.dart
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
import 'package:chasski/provider/empleado/offline/provider_sql__empelado.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql__list_chkpoint.dart';
import 'package:chasski/provider/check%20point/offline/provider_sql_cp0.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chasski/provider/runners/offline/provider_sql___participantes.dart';

//TODAS inicializa todas las bases
class DatabaseInitializer {
  static void initializeDatabase(BuildContext context) {
    //PARTICIPANTES SQL 
    Provider.of<DBParticiapntesAppProvider>(context, listen: false)
        .initDatabase();
     //EMPLEADOS  
    Provider.of<DBEmpleadoProvider>(context, listen: false).initDatabase();
    //LISTA CHEKPOINTS AR
    Provider.of<DBTListCheckPoitnsProvider>(context, listen: false)
        .initDatabase();

    //CHEKPOINT 00 SQL 
     Provider.of<DBChPProvider00>(context, listen: false)
        .initDatabase();
    //01
    Provider.of<DBChPProvider01>(context, listen: false).initDatabase();
    //02
    Provider.of<DBChPProvider02>(context, listen: false).initDatabase();
     //03
    Provider.of<DBChPProvider03>(context, listen: false).initDatabase();
     //04
    Provider.of<DBChPProvider04>(context, listen: false).initDatabase();
    //05
    Provider.of<DBChPProvider05>(context, listen: false).initDatabase();
    //06
    Provider.of<DBChPProvider06>(context, listen: false).initDatabase();
   //07
    Provider.of<DBChPProvider07>(context, listen: false).initDatabase();
    //08
    Provider.of<DBChPProvider08>(context, listen: false).initDatabase();
    //09
    Provider.of<DBChPProvider09>(context, listen: false).initDatabase();
    //10
    Provider.of<DBChPProvider10>(context, listen: false).initDatabase();
    //11
    Provider.of<DBChPProvider11>(context, listen: false).initDatabase();
    //12
    Provider.of<DBChPProvider12>(context, listen: false).initDatabase();
    //13
    Provider.of<DBChPProvider13>(context, listen: false).initDatabase();
    //14
    Provider.of<DBChPProvider14>(context, listen: false).initDatabase();
  }
}
