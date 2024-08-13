
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/runners/sheety/provider_sheety_participantes.dart';
import 'package:chasski/provider/runners/sheety/sheety_isempty_count.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetyPageParticipantes extends StatefulWidget {
  const SheetyPageParticipantes({super.key});

  @override
  State<SheetyPageParticipantes> createState() => _SheetyPageParticipantesState();
}

class _SheetyPageParticipantesState extends State<SheetyPageParticipantes> {
  String selectedField = 'title'; // Campo seleccionado por defecto
  String selectedEvento = '';
  List<ParticipantesModel>? selectList;
  @override 
  Widget build(BuildContext context) {
    //LISTA GOOGLE SHEETS
    final dataProvider = Provider.of<ParticipantesProviderSheety>(context);
    List<ParticipantesModel> listSheet = dataProvider.listParticipantes;
    //LISTA POKETBASE
    final dataPoketbase = Provider.of<TParticipantesProvider>(context);
    List<ParticipantesModel> listPoketbase = dataPoketbase.listaRunner;
    //LISTA OMITED, TO UPDATED,  TO CREATED
    List<ParticipantesModel> listaOmited = dataPoketbase.toBeOmited;
    List<ParticipantesModel> listUpdated = dataPoketbase.toBeUpdate;
    List<ParticipantesModel> listCreated = dataPoketbase.toBeCreated;

    // Create a map of lists with names
    final Map<String, List<ParticipantesModel>> dataListMap = {
      'Sheets': listSheet,
      'Server': listPoketbase,
      'Omitted': listaOmited,
      'Updated': listUpdated,
      'Created': listCreated,
    };

    // Default selected list
    selectList ??= listSheet;

    // final dataEmty = countEmptyFields(listSheet, selectedField);
    final dataEmty = countEmptyFields(selectList!, selectedField);
    // final dataEvento = Provider.of<TEventoArProvider>(context);
    // List<TEventoModel> eventList = dataEvento.listDistancia;

    // final dataEventcache = Provider.of<ParticipantesProviderSheety>(context);
    // TEventoModel evento = dataEventcache.selectedEvent;

    return Container(
      // margin: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1Text(text: 'Análisis de Datos Vacíos'.toUpperCase()),
          const SizedBox(height: 20),
          
          Table(
            columnWidths: {
              0: FractionColumnWidth(.8),
              1: FractionColumnWidth(.2),
            },
            children: [
              TableRow(children: [
                DropdownButton<List<ParticipantesModel>>(
                  value: selectList,
                  items: dataListMap.entries.map((entry) {
                    return DropdownMenuItem<List<ParticipantesModel>>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (List<ParticipantesModel>? newValue) {
                    setState(() {
                      selectList = newValue!;
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: H2Text(
                        text: selectList!.length.toString(),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                        maxLines: 2,
                      ),
                    ),
                    P3Text(text: 'Registros'),
                  ],
                ),
              ]),
              TableRow(children: [
                DropdownButton<String>(
                  value: selectedField,
                  items: fields.map((String field) {
                    return DropdownMenuItem<String>(
                      value: field,
                      child: Text(field),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedField = newValue!;
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: H2Text(
                        text: dataEmty.toString(),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                        maxLines: 2,
                      ),
                    ),
                    P3Text(text: 'Registros'),
                  ],
                ),
              ]),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectList!.length,
              reverse: false,
              itemBuilder: (BuildContext context, int index) {
                final reversedList = selectList!.toList().reversed.toList();
                final e = reversedList[index];

                isFieldEmpty(selectedField, e);

                // Verifica si el campo seleccionado está vacío o nulo
                if (!isFieldEmpty(selectedField, e)) return Container();

                // Si el campo está vacío o nulo, muestra el ListTile
                return AssetsDelayedDisplayYbasic(
                  curve: Curves.elasticOut, //Curves.easeInOutCubicEmphasized,
                  fadingDuration: 500,
                  duration: 200,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    leading: P3Text(text: e.key.toString()),
                    title: H2Text(text: e.title!),
                    subtitle: H2Text(text: e.apellidos),
                    trailing: AssetsDelayedDisplayX(
                      curve: Curves.easeInOutBack,
                      fadingDuration: 600,
                      duration: 200,
                      child: CircleAvatar(
                        child: Text(e.idsheety.toString()),
                      ),
                    ),
                    onTap: dataPoketbase.isSyncing
                        ? null
                        : () async {
                            dataPoketbase.toBeOmited.clear();
                            dataPoketbase.toBeUpdate.clear();
                            dataPoketbase.toBeCreated.clear();
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
