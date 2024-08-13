// import 'package:chasski/page/runner/navbar/progress/progress_check_list.dart';
import 'package:chasski/page/runner/navbar/progress/progress_check_list.dart';
import 'package:chasski/page/runner/navbar/progress/progress_time.dart';
import 'package:chasski/page/runner/navbar/progress/time_lines.dart';
import 'package:chasski/models/vista%20runner/model_v_tabla_participantes.dart';
import 'package:chasski/provider/vista%20runner/provider_v_tabla_participantes.dart';
import 'package:chasski/utils/colors/assets_get_ramdomcolor.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgreesRunnerPage extends StatelessWidget {
  const ProgreesRunnerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final evento = RunnerData.getEvent(context, runner);
    // final distancia = RunnerData.getDistance(context, runner);
    final dataParticipantes = Provider.of<VTablaParticipantesProvider>(context);
    List<VTablaPartipantesModel> listData =
        dataParticipantes.listaParticipantes;
    VTablaPartipantesModel filter = listData.firstWhere(
        (e) => runner.id == e.id,
        orElse: vistaParticipantesDefault);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
            title: Text('Mi Progreso'),
            actions: [
              IconButton.filled(
                  onPressed: dataParticipantes.isSyncing
                      ? null
                      : () async {
                          if (evento.id!.isNotEmpty || evento.id != null) {
                            await dataParticipantes.getIdEvento(
                                idEvento: evento.id!, context: context);
                          }
                        },
                  icon: dataParticipantes.isSyncing
                      ? AssetsCircularProgreesIndicator()
                      : Icon(Icons.refresh))
            ],
            bottom: TabBar(tabs: [
              Tab(
                text: 'CheckList',
                icon: AppSvg(width: 40).checkSvg,
              ),
              Tab(
                text: 'ChekPoints',
                icon: AppSvg(width: 40).checkPointsSvg,
              ),
              Tab(
                text: 'Tiempos',
                icon: AppSvg(width: 40).timeSvg,
              ),
            ]),
          ),
          body: filter.id == null
              ? Center(
                  child: P2Text(
                      textAlign: TextAlign.center,
                      text: 'Para acceder a este panel, suba el\n' +
                          ' documento de deslinde y el certificado médico.'),
                )
              : Container(
                  height:
                      MediaQuery.of(context).size.height, //- kToolbarHeight,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CheckListControles(filter: filter),
                      evento.estatus
                          ? Center(child: Text('no disponible'))
                          : ProgressTimePoint(filter: filter),
                      evento.estatus
                          ? Center(child: Text('no disponible'))
                          : TimeRunner(filter: filter)
                    ],
                  ),
                )),
    );
  }
}

class ChelkListProgres extends StatelessWidget {
  const ChelkListProgres({
    super.key,
    required this.progressPercentage,
  });
  final double progressPercentage;
  @override
  Widget build(BuildContext context) {
    int porcent = (progressPercentage * 100).round();
    return Container(
      margin: EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: progressPercentage,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.withOpacity(.2),
                  valueColor: AlwaysStoppedAnimation<Color>(getRandomColor()),
                ),
              ),
              H1Text(
                text: '${porcent.toStringAsFixed(0)}%',
              ),
            ],
          ),
          H2Text(
            text: 'Progress: ${porcent.toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }
}

class ProgreesRunner {
  String punto;
  bool estatus;
  DateTime fecha;

  ProgreesRunner({
    required this.estatus,
    required this.fecha,
    required this.punto,
  });
}

class ProgreesRunnerTime {
  String puntoStar;
  String time;
  String puntoEnd;

  ProgreesRunnerTime({
    required this.puntoStar,
    required this.time,
    required this.puntoEnd,
  });
}
