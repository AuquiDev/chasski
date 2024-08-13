import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/provider/evento/provider_t_evento_ar.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
// import 'package:chasski/widgets/assets_loties.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepContent1 extends StatefulWidget {
  final TEventoModel? selectedEvent;
  final ValueChanged<TEventoModel?> onChanged;

  const StepContent1({
    Key? key,
    required this.selectedEvent,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StepContent1> createState() => _StepContent1State();
}

class _StepContent1State extends State<StepContent1> {
  TEventoModel? selectedEvent;

  @override
  Widget build(BuildContext context) {
    final dataEvento = Provider.of<TEventoArProvider>(context);
    List<TEventoModel> eventList = dataEvento.listDistancia;

    final dataPoketbase = Provider.of<TParticipantesProvider>(context);
    List<ParticipantesModel> listPoketbase = dataPoketbase.listaRunner;

    final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);
    TEventoModel evento = dataEventcache.selectedEvent;

    int evenselect = 0;
    evenselect = listPoketbase.where((e) => e.idEvento == evento.id).length;

    return Column(
      children: [
        AppSvg(width: 150).serverBlue,
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: H1Text(
            text: 'Sincronización de Datos entre Servidores',
            maxLines: 2,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              P3Text(
                text:
                    'Sincroniza datos de corredores entre servidores. Primero, asegúrate de tener una hoja de Google Sheets con los datos, conéctala y configúrala para luego cargar la información al servidor.',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          trailing: AppSvg(width: 90).sheety,
        ),
        SizedBox(height: 10),
        H3Text(text: '1. Selección el evento (obligatorio).'),
        Container(
          color: Color(0x10000000),
          padding: const EdgeInsets.only(left: 8.0),
          margin: EdgeInsets.all(15),
          child: DropdownButton<TEventoModel>(
            value: widget.selectedEvent, // ?? eventList.first,
            items: eventList.map((TEventoModel e) {
              return DropdownMenuItem<TEventoModel>(
                value: e,
                child: H3Text(text: e.nombre),
              );
            }).toList(),
            onChanged: widget.onChanged,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            P3Text(text: 'Total de ', color: Colors.blue),
            H1Text(
              text: evenselect.toString(),
              fontSize: 30,
              color: Colors.blue,
            ),
            AppLoties(width: 40).runnerLoties,
            Expanded(
              child: P3Text(
                  text:
                      ' corredores almacenados en el servidor, vinculados a este evento.',
                  color: Colors.blue, 
                  
                  textAlign: TextAlign.justify,),
            ),
          ],
        )
      ],
    );
  }
}
