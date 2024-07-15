import 'package:chasski/widgets/cerrar_sesion.dart';

import 'package:chasski/widgets/widget/runner_appbar_widget.dart';
import 'package:chasski/widgets/widget/runner_appbar_customwidget.dart';
import 'package:chasski/widgets/widget/runner_steeper_widget.dart';
import 'package:flutter/material.dart';

class HomeOptions extends StatefulWidget {
  const HomeOptions({super.key});

  @override
  _HomeOptionsState createState() => _HomeOptionsState();
}

class _HomeOptionsState extends State<HomeOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsRunnerWidget(),
              SteeperWidget(),
              CloseSesion(),
            ],
          ),
        ),
      ),
    );
  }
}
