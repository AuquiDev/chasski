
import 'dart:io';

import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_checklist_02.dart';
import 'package:chasski/provider/provider_t_list_check_list.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({
    super.key,
  });

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;

    //LISTA de CHECKLIST
    final checListProvider = Provider.of<TListCheckListProvider>(context);
    List<TListChekListModel> listcheckL = checListProvider.listAsistencia;

    //IDCHECK LIST - Encontramos el check list,
    TListChekListModel check = listcheckL.firstWhere(
        (e) => e.id == 'vjyalwfxxtga6rr',
        orElse: () => checkListDefault());

    //COCUMENTOS CHECK POINTS
    final docProvider = Provider.of<TCheckList02Provider>(context);
    //SI el USURIO ESTA REGISTRADO
    TChekListmodel02File docUser = docProvider.listAsistencia
        .firstWhere((doc) => doc.idCorredor == user!.id!, 
        orElse: () => chekListDocDefault());

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          Center(
            child: Text(check.nombre),
          ),

          // Widget para previsualizar el archivo seleccionado
          selectedFile != null
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFViewerPage(file: selectedFile!),
                      ),
                    );
                  },
                  child: Text(
                    'Archivo seleccionado: ${selectedFile!.path}',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : const SizedBox.shrink(),

          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Seleccionar fuente de archivo'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          ListTile(
                            leading: Icon(Icons.picture_as_pdf),
                            title: Text('Seleccionar PDF'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );
                              if (result == null) {
                                print('No se seleccionó ningún archivo');
                              } else {
                                print(
                                    'Archivo seleccionado: ${result.files.single.path}');
                                setState(() {
                                  selectedFile =
                                      File(result.files.single.path!);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.attach_file),
          ),

          if (selectedFile != null)
            ElevatedButton(
              onPressed: docProvider.isSyncing
                  ? null
                  : () async {
                    print(docUser.id);
                      TChekListmodel02File dataDoc = TChekListmodel02File(
                        id: (docUser.id == null) ? '' : docUser.id,
                        idCorredor: user!.id!,
                        idCheckList: check.id!,
                        fileUrl: 'https://pub.dev/packages/flutter_pdfview',
                        fecha: DateTime.now(),
                        estado: true,
                        detalles: 'Nuevos comentario Inka Challenge',
                        nombre: user.nombre,
                        dorsal: user.dorsal,
                      );
                      await docProvider.saveProductosApp(
                          e: dataDoc, fileFile: selectedFile);
                    },
              child: docProvider.isSyncing
                  ? CircularProgressIndicator()
                  : Text('Enviar'),
            ),
        ],
      ),
    );
  }

  
}

class PDFViewerPage extends StatelessWidget {
  final File file;

  const PDFViewerPage({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista previa del PDF'),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}


// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PDFExportDeslinde extends StatefulWidget {
//   @override
//   State<PDFExportDeslinde> createState() => _PDFExportDeslindeState();
// }

// class _PDFExportDeslindeState extends State<PDFExportDeslinde> {
//   bool isSaving = false;

//   @override
//   Widget build(BuildContext context) {
//     return isSaving
//         ? const SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//             ))
//         : IconButton(
//             icon: const Icon(
//               Icons.print_rounded,
//               size: 30,
//             ),
//             onPressed: () async {
//               setState(() {
//                 isSaving = true;
//               });
//               // Simulación de guardado con un retraso de 2 segundos
//               await Future.delayed(const Duration(seconds: 2));

//               //PDF Generate
//               ByteData byteData =
//                   await rootBundle.load('assets/img/logo_small.png');
//               Uint8List imagenBytes = byteData.buffer.asUint8List();
//               const grisbordertable =
//                   PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

//               pw.Document pdf = pw.Document();

//               //PAGINA lista de compras
//               pdf.addPage(pw.MultiPage(
//                 margin: const pw.EdgeInsets.all(20),
//                 maxPages: 200,
//                 pageFormat: PdfPageFormat.a4.copyWith(
//                     marginTop: 0, marginBottom: 30), // Aplica los márgenes
//                 build: (pw.Context context) {
//                   var textStyle = pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold, fontSize: 10);
//                   const edgeInsets =
//                       pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
//                   return [
//                     pw.Column(
//                       children: [
//                         titlePages(imagenBytes),
//                         pw.Table(
//                           border: pw.TableBorder.all(color: grisbordertable),
//                           children: [
//                             pw.TableRow(
//                               children: [
//                                 pw.Center(
//                                     child: pw.Text('#', style: textStyle)),
//                                 pw.Center(
//                                     child:
//                                         pw.Text('PERSONAL', style: textStyle)),
//                                 pw.Center(
//                                     child: pw.Text('ROL', style: textStyle)),
//                                 pw.Center(
//                                     child: pw.Text('GRUPO', style: textStyle)),
//                                 pw.Center(
//                                   child: pw.Text('FECHA',
//                                       style: textStyle,
//                                       textAlign: pw.TextAlign.center),
//                                 ),
//                                 pw.Center(
//                                   child: pw.Text('ENTRADA',
//                                       style: textStyle,
//                                       textAlign: pw.TextAlign.center),
//                                 ),
//                                 pw.Center(
//                                   child: pw.Text('SALIDA',
//                                       style: textStyle,
//                                       textAlign: pw.TextAlign.center),
//                                 ),
//                                 // pw.Center(child: pw.Text('Detalles', style: textStyle,textAlign: pw.TextAlign.center),),
//                               ],
//                             ),

// // Azul
//                           ],
//                         )
//                       ],
//                     ),
//                   ];
//                 },

//                 footer: (context) {
//                   return fooTerPDF();
//                 },
//               ));

//               Uint8List bytes = await pdf.save();
//               Directory directory = await getApplicationDocumentsDirectory();
//               File filePdf = File("${directory.path}/asistencias ${23}.pdf");
//               filePdf.writeAsBytes(bytes);
//               OpenFilex.open(filePdf.path);
//               // print(directory.path);
//               // print(bytes);
//               // Mostrar un mensaje de éxito
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Archivo PDF exportado con éxito'),
//                 ),
//               );
//               setState(() {
//                 isSaving = false;
//               });
//             },
//           );
//   }

//   pw.TextStyle tableTextStyle() {
//     return pw.TextStyle(
//       fontSize: 8,
//       fontWeight: pw.FontWeight.normal,
//     );
//   }

//   pw.Container fooTerPDF() {
//     const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       // margin: const pw.EdgeInsets.only(top: 10),
//       child: pw.Column(
//         children: [
//           pw.Divider(
//               color: marronColor, thickness: 3, height: 10), // Línea divisoria
//           // pw.SizedBox(height: 10),
//           pw.Text(
//             'Con el corazón en las montañas, construimos experiencias únicas para el mundo.',
//             style: const pw.TextStyle(
//                 fontSize: 9,
//                 color: marronColor), // Color gris oscuro personalizado
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget titlePages(Uint8List imagenBytes) {
//     const marronColor = PdfColor.fromInt(0xFF2E1C09); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       margin: const pw.EdgeInsets.only(bottom: 10),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Row(children: [
//             pw.Container(
//               margin: const pw.EdgeInsets.symmetric(horizontal: 5),
//               width: 8, // Ancho muy pequeño para simular un divisor vertical
//               height: 40, // Altura igual a la altura de la imagen
//               color: marronColor, // Color marrón
//             ),
//             pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   'REPORTE DE ASISTENCIAS',
//                   style: pw.TextStyle(
//                     fontSize: 13,
//                     fontWeight: pw.FontWeight.bold,
//                     color: marronColor,
//                   ),
//                 ),
//                 pw.Text(
//                   'CÓDIGO: }',
//                   style: pw.TextStyle(
//                     fontSize: 11,
//                     fontWeight: pw.FontWeight.bold,
//                     color: marronColor,
//                   ),
//                 ),
//                 pw.Text(
//                   '[  registros ]',
//                   style: const pw.TextStyle(
//                     fontSize: 9,
//                     color: marronColor,
//                   ),
//                 ),
//               ],
//             ),
//           ]),
//           pw.Container(
//             width: 130,
//             child: pw.Column(
//               children: [
//                 pw.Image(
//                   pw.MemoryImage(imagenBytes),
//                 ),
//                 pw.Text('Área de Operaciones y Logística',
//                     style: pw.TextStyle(
//                       fontSize: 8, // Tamaño de fuente personalizable
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                     textAlign: pw.TextAlign.center),
//                 pw.Text(
//                   DateTime.now().toString(),
//                   style: const pw.TextStyle(
//                     fontSize: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:signature/signature.dart';

// class PDFExportDeslinde extends StatefulWidget {
//   @override
//   State<PDFExportDeslinde> createState() => _PDFExportDeslindeState();
// }

// class _PDFExportDeslindeState extends State<PDFExportDeslinde> {
//   bool isSaving = false;
//   Uint8List? _signatureImage;

//   @override
//   Widget build(BuildContext context) {
//     return isSaving
//         ? const SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//             ),
//           )
//         : IconButton(
//             icon: const Icon(
//               Icons.print_rounded,
//               size: 30,
//             ),
//             onPressed: () async {
//               setState(() {
//                 isSaving = true;
//               });

//               // Simulación de guardado con un retraso de 2 segundos
//               await Future.delayed(const Duration(seconds: 2));

//               // Mostrar modal bottom sheet para la firma
//               await _showSignatureModal(context);

//               // Generar PDF con la firma si se ha firmado
//               if (_signatureImage != null) {
//                 ByteData byteData =
//                     await rootBundle.load('assets/img/logo_small.png');
//                 Uint8List imagenBytes = byteData.buffer.asUint8List();
//                 const grisbordertable =
//                     PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

//                 pw.Document pdf = pw.Document();

//                 // Página de ejemplo
//                 pdf.addPage(pw.MultiPage(
//                   margin: const pw.EdgeInsets.all(20),
//                   maxPages: 200,
//                   pageFormat: PdfPageFormat.a4.copyWith(
//                       marginTop: 0,
//                       marginBottom: 30), // Aplica los márgenes
//                   build: (pw.Context context) {
//                     var textStyle = pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold, fontSize: 10);
//                     const edgeInsets =
//                         pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
//                     return [
//                       pw.Column(
//                         children: [
//                           titlePages(imagenBytes),
//                          pw.Center(
//                       child: pw.Image(pw.MemoryImage(_signatureImage!), width: 100, height: 100),
//                     )
//                         ],
//                       ),
//                     ];
//                   },
//                   footer: (context) {
//                     return fooTerPDF();
//                   },
//                 ));

//                 Uint8List bytes = await pdf.save();
//                 Directory directory =
//                     await getApplicationDocumentsDirectory();
//                 File filePdf =
//                     File("${directory.path}/asistencias ${23}.pdf");
//                 filePdf.writeAsBytes(bytes);
//                 OpenFilex.open(filePdf.path);

//                 // Mostrar un mensaje de éxito
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Archivo PDF exportado con éxito'),
//                   ),
//                 );
//               }

//               setState(() {
//                 isSaving = false;
//               });
//             },
//           );
//   }

//   Future<void> _showSignatureModal(BuildContext context) async {
//     final _controller = SignatureController(
//       penStrokeWidth: 5,
//       penColor: Colors.black,
//       exportBackgroundColor: Colors.white,
//     );

//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.8,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Signature(
//                   controller: _controller,
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       _controller.clear();
//                     },
//                     child: Text('Resetear Firma'),
//                   ),
//                   SizedBox(width: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final signature = await _controller.toPngBytes();
//                       if (signature != null) {
//                         setState(() {
//                           _signatureImage = signature;
//                         });
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     child: Text('Guardar Firma'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   pw.TextStyle tableTextStyle() {
//     return pw.TextStyle(
//       fontSize: 8,
//       fontWeight: pw.FontWeight.normal,
//     );
//   }

//   pw.Container fooTerPDF() {
//     const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       child: pw.Column(
//         children: [
//           pw.Divider(
//             color: marronColor,
//             thickness: 3,
//             height: 10,
//           ), // Línea divisoria
//           pw.Text(
//             'Con el corazón en las montañas, construimos experiencias únicas para el mundo.',
//             style: pw.TextStyle(
//               fontSize: 9,
//               color: marronColor,
//             ),
//           ), // Color gris oscuro personalizado
//         ],
//       ),
//     );
//   }

//   pw.Widget titlePages(Uint8List imagenBytes) {
//     const marronColor = PdfColor.fromInt(0xFF2E1C09); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       margin: pw.EdgeInsets.only(bottom: 10),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Row(
//             children: [
//               pw.Container(
//                 margin: pw.EdgeInsets.symmetric(horizontal: 5),
//                 width: 8,
//                 height: 40,
//                 color: marronColor,
//               ),
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     'REPORTE DE ASISTENCIAS',
//                     style: pw.TextStyle(
//                       fontSize: 13,
//                       fontWeight: pw.FontWeight.bold,
//                       color: marronColor,
//                     ),
//                   ),
//                   pw.Text(
//                     'CÓDIGO: ',
//                     style: pw.TextStyle(
//                       fontSize: 11,
//                       fontWeight: pw.FontWeight.bold,
//                       color: marronColor,
//                     ),
//                   ),
//                   pw.Text(
//                     '[  registros ]',
//                     style: pw.TextStyle(
//                       fontSize: 9,
//                       color: marronColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           pw.Container(
//             width: 130,
//             child: pw.Column(
//               children: [
//                 pw.Image(
//                   pw.MemoryImage(imagenBytes),
//                 ),
//                 pw.Text(
//                   'Área de Operaciones y Logística',
//                   style: pw.TextStyle(
//                     fontSize: 8,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                   textAlign: pw.TextAlign.center,
//                 ),
//                 pw.Text(
//                   DateTime.now().toString(),
//                   style: pw.TextStyle(
//                     fontSize: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }