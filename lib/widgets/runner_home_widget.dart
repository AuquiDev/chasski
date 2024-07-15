// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:chasski/provider/provider_t_list_check_list.dart';

import 'package:chasski/utils/format_fecha.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class HomeRunnerChild extends StatelessWidget {
  const HomeRunnerChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineView();
    // CloseSesion(),
  }
}

class TimelineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final checkList = Provider.of<TListCheckListProvider>(context)
        .listAsistencia
      ..sort((a, b) => a.orden.compareTo(b.orden));
    final filter = checkList.where((e) => e.estatus == true).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: gradientBackgroundlogin(),
        child: Stack(
          
          children: [
            Positioned(
              top: 20,
              left: 30,
              child: SafeArea(
                child: Row(
                  children: [
                     SvgPicture.asset(
                      'assets/img/file.svg',
                      width: 50,
                    ),
                    SizedBox(width: 10,),
                    H2Text(
                      text: 'Cronograma de\nControles',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 300, bottom: 100),
              child: filter.isEmpty
                  ? Center(
                    child: H2Text(
                        text: 'No hay datos disponibles',
                        color: CustomColors.darkIndigo,
                        fontSize: 14,
                      ),
                  )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: FixedTimeline.tileBuilder(
                          builder: TimelineTileBuilder.connected(
                            nodePositionBuilder: (context, index) {
                              return .01;
                            },
                            indicatorPositionBuilder: (context, index) {
                              return .8;
                            },
                            connectionDirection: ConnectionDirection.after,
                            contentsAlign: ContentsAlign.basic,
                            firstConnectorBuilder: (context) {
                              return SvgPicture.asset(
                                'assets/img/checkList.svg',
                                width: 50,
                                // color: Colors.red,
                              );
                            },
                            lastConnectorBuilder: (context) {
                              return SvgPicture.asset(
                                'assets/img/like.svg',
                                width: 40,
                                // color: Colors.red,
                              );
                            },
                            indicatorBuilder: (context, index) {
                              final e = filter[index];
                              return _pointsIndictor(e);
                            },
                            connectorBuilder: (context, index, connectorType) {
                              // final e = filter[index];
                              return SolidLineConnector(
                                color: CustomColors.darkIndigo,
                              );
                            },
                            itemCount: filter.length,
                            contentsBuilder: (context, index) {
                              final e = filter[index];

                              return _cardWidget(e);
                            },
                          ),
                        ),
                      ),
                    ),
            ),
             Positioned(
              top: 10,
              right:10,
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Icon(Icons.close, color: Colors.orange[300],))
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardWidget(TListChekListModel e) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Table(
            children: [
              headersRow(),
              contentTable(e),
            ],
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: H2Text(
                        text: e.nombre,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/img/checkp.svg',
                      width: 20,
                      color: Colors.redAccent,
                    ),
                    Text(
                      e.ubicacion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                H2Text(
                  text: e.descripcion,
                  fontSize: 12,
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isToday(DateTime horaApertura) {
    final now = DateTime.now();
    return horaApertura.year == now.year &&
        horaApertura.month == now.month &&
        horaApertura.day == now.day;
  }

  TableRow contentTable(TListChekListModel e) {
    return TableRow(
      decoration: BoxDecoration(color: CustomColors.darkGrey),
      children: [
        Column(
          children: [
            H2Text(
              text: formatFecha(e.horaApertura),
              fontSize: 13,
              textAlign: TextAlign.center,
              color: CustomColors.lightIndigo,
            ),
            H2Text(
              text: formatFechaPDfhora(e.horaApertura),
              fontSize: 13,
              textAlign: TextAlign.center,
              color: CustomColors.lightIndigo,
            ),
          ],
        ),
        Column(
          children: [
            H2Text(
              text: formatFecha(e.horaCierre),
              fontSize: 13,
              textAlign: TextAlign.center,
              color: CustomColors.lightIndigo,
            ),
            H2Text(
              text: formatFechaPDfhora(e.horaCierre),
              fontSize: 13,
              textAlign: TextAlign.center,
              color: CustomColors.lightIndigo,
            ),
          ],
        ),
      ],
    );
  }

  TableRow headersRow() {
    return TableRow(
      decoration: BoxDecoration(color: CustomColors.lightGrey),
      children: [
        H2Text(
          text: 'APERTURA',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: 'CIERRE',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Column _pointsIndictor(TListChekListModel e) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        H2Text(
          text: formatFecha(e.horaApertura),
          fontSize: 10,
          color: Colors.black,
        ),
        H2Text(
          text: formatFechaPDfhora(e.horaApertura),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        DotIndicator(
          color: CustomColors.darkIndigo,
          size: 20,
        ),
      ],
    );
  }
}
