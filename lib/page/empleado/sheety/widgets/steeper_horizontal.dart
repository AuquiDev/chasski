import 'package:chasski/models/evento/model_evento.dart';
// import 'package:chasski/sheety/model_participantes.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/page/empleado/sheety/widgets/steeper_1.dart';
import 'package:chasski/page/empleado/sheety/widgets/steeper_2.dart';
import 'package:chasski/page/empleado/sheety/widgets/steeper_3.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HorizontalStepper extends StatefulWidget {
  @override
  _HorizontalStepperState createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  int _currentStep = 0;
  final String selectedField = 'title';
  final String selectedEvento = '';

  TEventoModel? selectedEvent;

  bool isNextpage = false;
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ParticipantesProviderSheety>(context);
    // List<ParticipantesModel> listSheet = dataProvider.listParticipantes;

    final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);

    List<Widget> steps = [
      StepContent1(
        selectedEvent: selectedEvent,
        onChanged: (newValue) async {
          if (newValue != null) {
            setState(() {
              selectedEvent = newValue;
              dataEventcache.setSelectedEvent(newValue);
            });
            await Future.delayed(Duration(seconds: 1));
            setState(() {
              _currentStep += 1;
            });
          }
        },
      ),
      StepContent2(
        onLoadData: () async {
          await dataProvider.getRecursosProvider();
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _currentStep += 1;
          });
        },
      ),
      StepContent3()
    ];
    //
    return Stepper(
      elevation: 15,
      steps: [
        ...List.generate(steps.length, (index) {
          final e = steps[index];
          return Step(
              title: Text('Paso ${index + 1}'),
              content: e,
              state: _currentStep == index
                  ? StepState.complete
                  : StepState.indexed,
              isActive: _currentStep >= index);
        })
      ],
      currentStep: _currentStep,
      type: StepperType.horizontal,
      onStepContinue: () {
        if (_currentStep < steps.length - 1) {
          setState(() {
            _currentStep += 1;
          });
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep -= 1;
          });
        }
      },
      onStepTapped: (index) {
        setState(() {
          _currentStep = index;
        });
      },
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (details.onStepCancel != null && _currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('Back'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(
                  details.stepIndex == (steps.length - 1) ? 'Finish' : 'Next',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


