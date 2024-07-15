// ignore_for_file: unnecessary_null_comparison

import 'package:chasski/widgets/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:chasski/models/model_t_asistencia.dart';
import 'package:chasski/models/model_t_detalle_trabajo.dart';
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/provider_cache/provider_cache.dart';

import 'package:chasski/provider/provider_sql_detalle_grupo.dart';
import 'package:chasski/provider/provider_sql_empelado.dart';
import 'package:chasski/provider/provider_sql_tasitencia.dart';

import 'package:chasski/widgets/get_ramdomcolor.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiagrmaIndicatorSinc extends StatefulWidget {
  const DiagrmaIndicatorSinc({
    super.key,
  });

  @override
  State<DiagrmaIndicatorSinc> createState() => _DiagrmaIndicatorSincState();
}

class _DiagrmaIndicatorSincState extends State<DiagrmaIndicatorSinc> {
  @override
  void initState() {
    Provider.of<DBAsistenciaAppProvider>(context, listen: false).initDatabase();
    Provider.of<DBDetalleGrupoProvider>(context, listen: false).initDatabase();
    Provider.of<DBEMpleadoProvider>(context, listen: false).initDatabase();
    // Provider.of<DBPersonalProvider>(context, listen: false).initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        children: [StorageLocalChar(), StoraIdnullChar()],
      ),
    );
  }
}

class StorageLocalChar extends StatelessWidget {
  const StorageLocalChar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 600 && size.width <= 1200;

    // Obtener datos de cada lista
    final asistenciaList =
        Provider.of<DBAsistenciaAppProvider>(context).listsql;
    final detalleGrupoList =
        Provider.of<DBDetalleGrupoProvider>(context).listsql;
    final empleadoList = Provider.of<DBEMpleadoProvider>(context).listsql;
    // final personalList = Provider.of<DBPersonalProvider>(context).listsql;
    // final reporteIncidenciasList =
    //     Provider.of<DBReporteIncidenciasProvider>(context).listsql;
    // final reportePasajeroList =
    //     Provider.of<DBReportePasajeroProvider>(context).listsql;

    // Asignar nombres a cada lista
    final List<String> listNames = [
      'Asistencias',
      'Grupos',
      'Usuarios',
      // 'Personal',
      // 'Incidencias',
      // 'Encuesta Pax',
    ];

    // Crear una lista con el length de cada lista
    final List<int> dataList = [
      asistenciaList.length,
      detalleGrupoList.length,
      empleadoList.length,
      // personalList.length,
      // reporteIncidenciasList.length,
      // reportePasajeroList.length,
    ];
    // dataList.sort((a,b)=>a.compareTo(b));
    // Organizar los datos para el gráfico
    List<MapEntry<String, int>> data = List.generate(
      listNames.length,
      (index) => MapEntry(listNames[index], dataList[index]),
    );
    data.sort((a, b) => a.value.compareTo(b.value));
    return Container(
      //  color: Colors.white,
      margin: EdgeInsets.all(10),
      child: SfCircularChart(
        title: const ChartTitle(
          text: 'Almacenamiento Local',
          alignment: ChartAlignment.center,
        ),
        legend: Legend(
          toggleSeriesVisibility: true,
          // shouldAlwaysShowScrollbar: true,
          isVisible: true,
          isResponsive: true,
          iconHeight: 30.0,
          iconWidth: 30.0,
          overflowMode: LegendItemOverflowMode.wrap,
          position: (isDesktop || isTablet)
              ? LegendPosition.left
              : LegendPosition.bottom,
        ),
        series: <RadialBarSeries>[
          RadialBarSeries<MapEntry<String, int>, String>(
            dataSource: data,
            strokeColor: Colors.white10,
            xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
            yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
            dataLabelMapper: (MapEntry<String, int> data, _) =>
                '${data.key} ~ ${data.value} regs.',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
              ),
            ),
            radius: '100%',
            innerRadius: '20%',
            pointColorMapper: (MapEntry<String, int> data, _) =>
                getRandomColor(),
            // explode: true,
            // explodeIndex: 0,
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

class StoraIdnullChar extends StatelessWidget {
  const StoraIdnullChar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 600 && size.width <= 1200;

    // Obtener datos de cada lista
    final asistenciaList =
        Provider.of<DBAsistenciaAppProvider>(context).listsql;
    final detalleGrupoList =
        Provider.of<DBDetalleGrupoProvider>(context).listsql;
    final empleadoList = Provider.of<DBEMpleadoProvider>(context).listsql;
    // final personalList = Provider.of<DBPersonalProvider>(context).listsql;

    // Asignar nombres a cada lista
    final List<String> listNames = [
      'Asistencias',
      'Grupos',
      'Usuarios',
      // 'Personal',
      // 'Incidencias',
      // 'Encuesta Pax',
    ];

    // Crear una lista con el length de cada lista
    final List<int> dataList = [
      asistenciaID(asistenciaList),
      grupoID(detalleGrupoList),
      empleadoID(empleadoList),
      // personID(personalList),
      // incidenciaID(reporteIncidenciasList),
      // reportePaxID(reportePasajeroList),
    ];
    // Verificar si hay algún elemento con ID nulo
    bool hasElementsWithNullId = dataList.any((count) => count > 0);
    // Actualizar automáticamente el valor en el Provider si el widget está montado
    if (context != null && context.findRenderObject() != null) {
      Future.delayed(Duration.zero, () {
        _updateHasElementsWithNullId(context, hasElementsWithNullId);
      });
    }
    return hasElementsWithNullId
        ? Container(
            color: Colors.white,
            margin: EdgeInsets.all(10),
            child: SfCircularChart(
              title: const ChartTitle(
                text: 'Datos por sincronizar Local',
                alignment: ChartAlignment.center,
              ),
              legend: Legend(
                toggleSeriesVisibility: true,
                isVisible: true,
                isResponsive: true,
                iconHeight: 30.0,
                iconWidth: 30.0,
                overflowMode: LegendItemOverflowMode.wrap,
                position: (isDesktop || isTablet)
                    ? LegendPosition.right
                    : LegendPosition.bottom,
              ),
              series: <RadialBarSeries>[
                RadialBarSeries<MapEntry<String, int>, String>(
                  dataSource: generateChartData(listNames, dataList),
                  strokeColor: Colors.white10,
                  xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
                  yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
                  dataLabelMapper: (MapEntry<String, int> data, _) =>
                      '${data.key} ~ ${data.value} regs.',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    connectorLineSettings: ConnectorLineSettings(
                      type: ConnectorType.curve,
                    ),
                  ),
                  radius: '90%',
                  innerRadius: '65%',
                  pointColorMapper: (MapEntry<String, int> data, _) =>
                      getRandomColor(),
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          )
        : const Center(
            child:
                H2Text(text: 'No hay elementos por sincronizar', fontSize: 15),
          );
  }

  void _updateHasElementsWithNullId(BuildContext context, bool data) {
    print(data);
    if (context != null && context.findRenderObject() != null) {
      Provider.of<UsuarioProvider>(context, listen: false).setSincData(data);
    }
  }

  // ASISTENCIA COUNT ID NULL
  int asistenciaID(List<TAsistenciaModel> list) {
    return list.where((e) => e.id == '' || e.updated != e.created).length;
  }

  // ASISTENCIA COUNT ID NULL
  int grupoID(List<TDetalleTrabajoModel> list) {
    return list.where((e) => e.id == '').length;
  }

  // ASISTENCIA COUNT ID NULL
  int empleadoID(List<TEmpleadoModel> list) {
    return list.where((e) => e.id == '').length;
  }

  // // ASISTENCIA COUNT ID NULL
  // int personID(List<TPersonalModel> list) {
  //   return list.where((e) => e.id == '').length;
  // }

//   // ASISTENCIA COUNT ID NULL
//   int incidenciaID(List<TReporteIncidenciasModel> list) {
//     return list.where((e) => e.id == '').length;
//   }

// // ASISTENCIA COUNT ID NULL
//   int reportePaxID(List<TReportPasajeroModel> list) {
//     return list.where((e) => e.id == '').length;
//   }

  // Función para generar datos para el gráfico
  // List<MapEntry<String, int>> generateChartData(List<String> listNames, List<int> dataList) {
  //   return List.generate(
  //     listNames.length,
  //     (index) => MapEntry(listNames[index], dataList[index]),
  //   );
  // }

// // Función para generar datos para el gráfico
  List<MapEntry<String, int>> generateChartData(
      List<String> listNames, List<int> dataList) {
    // Filtrar solo aquellos elementos que tienen ID nulo
    List<MapEntry<String, int>> filteredData = List.generate(
      listNames.length,
      (index) => MapEntry(listNames[index], dataList[index]),
    ).where((entry) => entry.value > 0).toList();

    return filteredData;
  }
}
