import 'dart:io';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/runners/offline/provider_sql___participantes.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class PdfParticipantes extends StatefulWidget {
  const PdfParticipantes(
      {super.key,
      required this.titlePDf,
      required this.toBeOmited,
      required this.toBeUpdate,
      required this.toBeCreated,
      required this.toBeDeleted,
      required this.tolocalExist,
      required this.selectField,
      this.screenshot});
  final List<ParticipantesModel> toBeOmited; //sin accion
  final List<ParticipantesModel> toBeUpdate;
  final List<ParticipantesModel> toBeCreated;
  final List<ParticipantesModel> toBeDeleted;
  final List<ParticipantesModel> tolocalExist; //Solo existe localmente
  final String titlePDf;
  final String selectField;
  final Uint8List? screenshot;
  @override
  State<PdfParticipantes> createState() => _PdfParticipantesState();
}

class _PdfParticipantesState extends State<PdfParticipantes> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final dbProviderSQL = Provider.of<DBParticiapntesAppProvider>(context);

    final groupedData = {
      'CREADOS': dbProviderSQL.groupByDistance(
          listParticipantes: widget.toBeCreated, filename: widget.selectField),
      'ACTUALIZADOS': dbProviderSQL.groupByDistance(
          listParticipantes: widget.toBeUpdate, filename: widget.selectField),
      'ELIMINADOS': dbProviderSQL.groupByDistance(
          listParticipantes: widget.toBeDeleted, filename: widget.selectField),
      'LOCALMENTE EXISTENTES': dbProviderSQL.groupByDistance(
          listParticipantes: widget.tolocalExist, filename: widget.selectField),
      'OMITIDOS': dbProviderSQL.groupByDistance(
          listParticipantes: widget.toBeOmited, filename: widget.selectField),
    };

    return isSaving
        ? AssetsCircularProgreesIndicator()
        : ElevatedButton.icon(
            icon: AppSvg().pdfSvg,
            label: const Text('Descargar'),
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              try {
                pw.Document pdf = pw.Document();
                pdf.addPage(pw.MultiPage(
                  build: (context) {
                    return [
                      if (widget.screenshot != null)
                        pw.Image(pw.MemoryImage(widget.screenshot!),
                            fit: pw.BoxFit.contain, height: 400),
                      pw.Center(
                          child: pw.Text('${widget.titlePDf}',
                              style: const pw.TextStyle(
                                fontSize: 19,
                              ))),
                      pw.Center(
                          child: pw.Text('${dbProviderSQL.listsql.length}',
                              style: const pw.TextStyle(
                                fontSize: 17,
                              ))),
                    ];
                  },
                ));

                pdf.addPage(pw.MultiPage(
                  margin: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  maxPages: 500,
                  header: (context) {
                    return pw.Center(
                        child: pw.Text('${widget.titlePDf}',
                            style: const pw.TextStyle(
                              fontSize: 15,
                            )));
                  },
                  build: (pw.Context context) {
                    return [
                      ...groupedData.keys.map((String title) {
                        final data = groupedData[title];
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            dataList(
                              title: title,
                              subtitle:
                                  '${data!.values.fold(0, (prev, list) => prev + list.length)}',
                            ),
                            pw.SizedBox(height: 10),
                            ...data.entries.map((entry) {
                              return pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(entry.key,
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                            )),
                                        pw.Text(entry.value.length.toString(),
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                            )),
                                      ]),
                                  pw.SizedBox(height: 5),
                                  // generateTable(entry.value),
                                  generateGridView(entry.value)
                                ],
                              );
                            }).toList(),
                            pw.SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    ];
                  },
                ));

                Uint8List bytes =
                    await pdf.save().timeout(Duration(minutes: 5));
                Directory directory = await getApplicationDocumentsDirectory();
                File filePdf = File("${directory.path}/${widget.titlePDf}.pdf");
                filePdf.writeAsBytes(bytes);
                OpenFilex.open(filePdf.path);
              } catch (e) {
                AssetAlertDialogPlatform.show(
                    context: context,
                    message: 'Error al cargar PDF $e',
                    title: 'Error!');
              } finally {
                setState(() {
                  isSaving = false;
                });
              }
            },
          );
  }
}

pw.Column dataList({required String title, required String subtitle}) {
  return pw.Column(children: [
    pw.Table(
      children: [
        pw.TableRow(
          children: [
            pw.Text(title,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                )),
            pw.Text(subtitle,
                textAlign: pw.TextAlign.end,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.blue900,
                )),
          ],
        ),
      ],
    ),
    pw.Divider(),
  ]);
}

pw.Column generateGridView(List<ParticipantesModel> listData) {
  listData.sort((a, b) => (a.title ?? 0).compareTo(b.title ?? 0));
  if (listData.isEmpty) {
    return pw.Column(
      children: [
        pw.Text('No hay datos disponibles',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.black,
            )),
      ],
    );
  }

  const int columns = 15; // Número de columnas en el GridView
  final int rows = (listData.length / columns)
      .ceil(); // Calcula el número de filas necesarias

  List<pw.Widget> rowsWidgets = [];
  for (int row = 0; row < rows; row++) {
    List<pw.Widget> cells = [];
    for (int col = 0; col < columns; col++) {
      final index = row * columns + col;
      if (index < listData.length) {
        final participant = listData[index];
        cells.add(pw.Expanded(
          child: pw.Container(
            color: PdfColor.fromHex('#F0F0F0'),
            margin: const pw.EdgeInsets.all( 2.0), // Agrega algo de espacio entre celdas
            child: pw.Text(
              '${(participant.dorsal.toString()).isEmpty ? 'N/A' : participant.dorsal}',
              textAlign: pw.TextAlign.start,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ),
        ));
      } else {
        cells.add(pw.Expanded(
            child: pw.SizedBox())); // Añadir espacio vacío si no hay datos
      }
    }
    rowsWidgets.add(
      pw.Row(
        children: cells,
      ),
    );
  }

  return pw.Column(
    children: rowsWidgets,
  );
}

pw.Table generateTable(List<ParticipantesModel> listData) {
  return listData.isEmpty
      ? pw.Table(children: [
          pw.TableRow(children: [
            pw.Center(
                child: pw.Text('No hay datos disponibles',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.black,
                    ))),
          ])
        ])
      : pw.Table(
          columnWidths: {
            0: pw.FixedColumnWidth(10),
          },
          children: listData.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            int contador = index + 1;
            return pw.TableRow(children: [
              pw.Expanded(
                  child: pw.Text('$contador',
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.id,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.nombre,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.nombre,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.distancias,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.telefono,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.apellidos,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      ))),
              pw.Expanded(
                  child: pw.Text(e.email,
                      style: const pw.TextStyle(
                        fontSize: 8,
                      )))
            ]);
          }).toList(),
        );
}
