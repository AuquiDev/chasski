import 'package:chasski/page/empleado/sheety/home_testsheety.dart';
import 'package:chasski/page/empleado/sheety/widgets/steeper_horizontal.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';

class SincDataRunnerSheet extends StatelessWidget {
  const SincDataRunnerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: H1Text(
            text: 'Sincronización de Corredores'.toUpperCase(),
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            TabBar(isScrollable: true, tabs: [
              Tab(text: 'SyncData'),
              Tab(text: 'FieldCheck'),
              // Tab(text: 'DataAudit'),
              // Tab(text: 'ExportTools'),
            ]),
            Expanded(
              child: TabBarView(children: [
                HorizontalStepper(),
                SheetyPageParticipantes(),
                // Center(child: Text('Contenido de la pestaña 3')),
                // Center(child: Text('Contenido de la pestaña 4')),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
