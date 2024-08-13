import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:provider/provider.dart';

class StepContent2 extends StatelessWidget {
  final VoidCallback onLoadData;

  const StepContent2({
    Key? key,
    required this.onLoadData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);
    TEventoModel evento = dataEventcache.selectedEvent;
    return Column(
      children: [
        if (evento.id!.isNotEmpty)
          Column(
            children: [
              AppSvg(width: 150).sheety,
              dataEventcache.listParticipantes.isEmpty
                  ? P3Text(
                      text:
                          ' Si no tiene el token de Google Sheets, consulte al administrador.',
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        H1Text(
                          text: dataEventcache.listParticipantes.length
                              .toString(),
                              fontSize: 20,
                          color: Color(0xFF2B692E),
                        ),
                        P3Text(
                            text: ' regsitros obtenidos.',
                           color: Color(0xFF2B692E),),
                      ],
                    ),
              ElevatedButton(
                onPressed: dataEventcache.isget ? null : onLoadData,
                child: dataEventcache.isget
                    ? AssetsCircularProgreesIndicator()
                    : Text('Cargar datos de google sheets'),
              ),
              EventeSelected(),
            ],
          ),
        if (evento.id!.isEmpty)
          P2Text(text: 'No puede continuar sin seleccionar un tipo de evento.'),
      ],
    );
  }
}

class EventeSelected extends StatefulWidget {
  @override
  State<EventeSelected> createState() => _EventeSelectedState();
}

class _EventeSelectedState extends State<EventeSelected> {
  final ExpandedTileController _controller =
      ExpandedTileController(isExpanded: true);
  @override
  Widget build(BuildContext context) {
    final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);
    TEventoModel evento = dataEventcache.selectedEvent;

    final data = [
      {
        'title': ' BaseUrl: ',
        'data': evento.baseUrl,
      },
      {
        'title': ' Proyectname: ',
        'data': evento.proyectname,
      },
      {
        'title': ' hojaSheetname: ',
        'data': evento.hojaSheetname,
      },
      {
        'title': ' tokenSheety: ',
        'data': evento.tokenSheety,
      },
    ];
    return ExpandedTile(
      controller: _controller,
      leading: GLobalImageUrlServer(
          duration: 300,
          width: 40,
          height: 30,
          image: evento.logoSmall ?? '',
          collectionId: evento.collectionId ?? '',
          id: evento.id ?? '',
          borderRadius: BorderRadius.circular(1)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2Text(
            text: evento.nombre,
          ),
          P3Text(
              text:
                  '${formatEventDates(evento.fechaInicio, evento.fechaFin)} '),
        ],
      ),
      content: Column(
        children: [
          ...List.generate(data.length, (index) {
            final e = data[index];
            return AssetsDelayedDisplayYbasic(
              duration: 300 * index,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: H3Text(text: '${e['title']}'),
                    prefixIconConstraints: BoxConstraints(maxWidth: 300),
                    hintText: '${e['data']}',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
