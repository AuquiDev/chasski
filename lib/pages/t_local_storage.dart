// ignore_for_file: deprecated_member_use

import 'package:chasski/pages/routes_localstorage.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/get_ramdomcolor.dart';
import 'package:chasski/widgets/lotties_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({
    super.key,
  });

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  bool viewer = true;
  double lottieHeight = 20;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RoutesLocalStorage> rutasSQl = sqlRoutes;
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: lottieHeight,
              child: Hero(
                  transitionOnUserGestures: true,
                  tag: 'heroAnimation1',
                  child: LottiesImage())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              viewer ? CustomColors.lightGrey : Colors.white)),
                      onPressed: () {
                        setState(() {
                          viewer = true;
                        });
                      },
                      child: H2Text(
                          text: 'Checklist Storage'.toUpperCase(),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.darkIndigo)),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            !viewer ? CustomColors.lightGrey : Colors.white)),
                    onPressed: () {
                      setState(() {
                        viewer = false;
                      });
                    },
                    child: H2Text(
                        text: 'Local Athlete Info'.toUpperCase(),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.darkIndigo),
                  )
                ],
              ),
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  setState(() {
                    // Ajusta el tamaño del Lottie conforme se haga scroll
                    lottieHeight =
                        20 - (scrollNotification.metrics.pixels * 1.6);
                    // Limita el tamaño mínimo del Lottie a 50
                    if (lottieHeight < 10) {
                      lottieHeight = 50;
                    }
                  });
                  return true;
                },
                child: AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          alignment: Alignment.center,
                          scale: animation.drive(
                            Tween<double>(begin: 0.1, end: 1.0).chain(
                              CurveTween(curve: Curves.easeInToLinear),
                            ), //easeInToLinear
                          ),
                          child: child,
                        ),
                      );
                    },
                    duration: Duration(milliseconds: 1000),
                    child: viewer
                        ? ListWheelScrollView.useDelegate(
                            itemExtent: 250,
                            diameterRatio: 2,
                            perspective: .003,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: route_p.length,
                              builder: (context, index) {
                                final e = route_p[index];
                                return CardLocalStorage(
                                  e: e,
                                  view: viewer,
                                );
                              },
                            ))
                        : SizedBox(
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 250,
                              diameterRatio: 2,
                              perspective: .003,
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: rutasSQl.length,
                                builder: (context, index) {
                                  final e = rutasSQl[index];
                                  return CardLocalStorage(
                                    e: e,
                                    view: viewer,
                                  );
                                },
                              ),
                            ),
                          )),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class CardLocalStorage extends StatelessWidget {
  const CardLocalStorage({
    super.key,
    required this.e,
    required this.view,
  });
  final RoutesLocalStorage e;
  final bool view;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          visualDensity: VisualDensity.compact,
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => e.path));
          },
          trailing: Icon(Icons.arrow_forward_outlined,
              size: 16, color: CustomColors.blue),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H2Text(
                text: e.title.toUpperCase(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: CustomColors.black.withOpacity(.7),
              ),
              H2Text(
                text: 'datasync',
                fontSize: 12,
                color: CustomColors.blue,
              ),
            ],
          ),
        ),
        DelayedDisplay(
          delay: Duration(milliseconds: 800),
          slidingCurve: Curves.easeInOut,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.darkIndigo.withOpacity(.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(.2, 1),
                  )
                ],
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(100, 75),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Builder(builder: (context) {
                            final double synced = 120 - 69;
                            final double progress = synced / 120;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                e.icon,
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 9,
                                        value: progress,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                getRandomColor()),
                                      ),
                                    ),
                                    H2Text(
                                      text:
                                          '${(progress * 100).toStringAsFixed(1)} %',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                              ],
                            );
                          }),
                          Table(
                            children: [
                              TableRow(children: [
                                ValueTable(120),
                                ValueTable(51),
                                ValueTable(69),
                              ]),
                              TableRow(children: [
                                subtitleTable(
                                  'Storage',
                                ),
                                subtitleTable(
                                  'Synced',
                                ),
                                subtitleTable(
                                  'To Sync',
                                ),
                              ])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ])),
        ),
      ],
    );
  }

  Row ValueTable(int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        H2Text(
          text: value.toString(),
          fontSize: 18,
          color: CustomColors.indigo,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 4,
        ),
        H2Text(
          text: 'row',
          fontSize: 11,
          color: CustomColors.indigo,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  H2Text subtitleTable(String title) {
    return H2Text(
      text: title,
      fontSize: 11,
      color: CustomColors.darkGrey.withOpacity(.7),
      fontWeight: FontWeight.w400,
      textAlign: TextAlign.center,
    );
  }
}
