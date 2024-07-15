import 'dart:io';
import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_checklist_02.dart';
import 'package:chasski/provider/provider_t_list_check_list.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/runner_pdf_deslinde_wdiget.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DocumentRunnerWidget extends StatelessWidget {
  const DocumentRunnerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DocRunnerWidget();
  }
}

class DocRunnerWidget extends StatefulWidget {
  const DocRunnerWidget({
    super.key,
  });

  @override
  State<DocRunnerWidget> createState() => _DocRunnerWidgetState();
}

class _DocRunnerWidgetState extends State<DocRunnerWidget> {
  File? selectedFile;
  TextEditingController _detallesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //USUARIO EN CACHE - SHARED PREFERENCES
    //Esto se Utiliza para detectar si el usuario, se enceuntra en la lista de docuemnto.
    final cache = Provider.of<RunnerProvider>(context);
    TRunnersModel? user = cache.usuarioEncontrado;
    final loginProvider = Provider.of<TRunnersProvider>(context).listaRunner;

    //DATOS DE LRUNNER ENCONTRADOS
    TRunnersModel runner = loginProvider.firstWhere((e) => e.id == user!.id,
        orElse: () => defaultRunner());

    //LISTA DE CHECKLIST. Para iterar la lista y encontrrar la lista de Documentos.
    final checListProvider = Provider.of<TListCheckListProvider>(context);
    List<TListChekListModel> listcheckL = checListProvider.listAsistencia;

    //IDCHECK LIST - Encontramos el check list,Nesecitamos obtener el key de la lista.
    //no es ensesario. pero igual podemos Registrar si coincide con el orden 1
    TListChekListModel check = listcheckL.firstWhere((e) => e.orden == 1,
        orElse: () => checkListDefault());

    //COCUMENTOS CHECK POINTS
    final docProvider = Provider.of<TCheckList02Provider>(context);

    //SI el USURIO ESTA REGISTRADO: Encontramos el id del correcdor, si ya esta registrado devolvemos null.
    TChekListmodel02File docUser = docProvider.listAsistencia.firstWhere(
        (doc) => doc.idCorredor == user!.id!,
        orElse: () => chekListDocDefault());

    TChekListmodel02File e = TChekListmodel02File(
        id: (docUser.id == null) ? '' : docUser.id,
        idCorredor: user!.id!,
        idCheckList: check.id!,
        fileUrl: '',
        fecha: DateTime.now(),
        estado: true,
        detalles: _detallesController.text,
        nombre: runner.nombre,
        dorsal: runner.dorsal);

    return GestureDetector(
      onTap: () {
        // Desenfocar el FocusNode para ocultar el teclado
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            OutlinedButton.icon(
                onPressed: () async {
                  selectFile(cache);
                  //Guardamos el PTH de FILE EN PROVIDER
                },
                label: Text('Certif. Medico'),
                icon: Icon(Icons.attach_file_sharp)),
            SizedBox(
              width: 8,
            ),
            PDFExportDeslinde(
              e: e,
              runner: runner,
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: H2Text(
                  text: 'Instrucciones:',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              BulletListItem(
                text:
                    '1). Ingrese cualquier detalle adicional relevante en el campo de texto provisto.',
              ),
              BulletListItem(
                text:
                    '2). Presione "Certif. Medico".\nSeleccione o cargue su certificado médico en formato PDF.',
              ),
              BulletListItem(
                text:
                    '3). Presione "Doc Deslinde".\nEl sistema generará automáticamente un PDF con su foto frontal tipo carnet y firma digital.',
              ),
              BulletListItem(
                text:
                    '4). Después de completar los pasos anteriores, presione el botón verde para guardar los cambios realizados.',
              ),
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLength: 600,
                  maxLines: 6,
                  controller: _detallesController,
                  decoration: InputDecoration(
                      hintText:
                          'Escribe aquí tu sustento o información crucial',
                      labelText: '1). Sustento o Información Importante',
                      prefixIcon: Icon(Icons.terrain),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12))),
                ),
              ),
              
              if (cache.medicalCertificateFile != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDfViewChild(
                              selectedFile: cache.medicalCertificateFile)),
                    );
                  },
                  child: _cardFile(title: '2). Mi certificado médico'),
                ),
              if (cache.pdfFile != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PDfViewChild(selectedFile: cache.pdfFile)),
                    );
                  },
                  child: _cardFile(title: '3). Deslinde de responsabilidad'),
                ),
                if (cache.userPhotoBytes != null && cache.signatureImage != null)
                Table(
                  children: [
                    TableRow(children: [
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.memory(cache.userPhotoBytes!)),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.memory(cache.signatureImage!),
                      ),
                    ]),
                    TableRow(children: [
                      H2Text(
                        text: 'Foto',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                      ),
                      H2Text(
                        text: 'Firma',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                      ),
                    ]),
                  ],
                ),
            ],
          ),
        ),
        floatingActionButton: (cache.medicalCertificateFile != null &&
                cache.pdfFile != null)
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                //SI bool isSyncing = false no carga, si esta true se pone a cargar y se inactiva el boton
                onPressed: docProvider.isSyncing
                    ? null
                    : () async {
                        await docProvider.saveProductosApp(
                            e: e,
                            fileFile: cache.medicalCertificateFile,
                            deslinde: cache.pdfFile);
                      },
                child: docProvider.isSyncing
                    ? CircularProgressIndicator(color: CustomColors.light1Grey)
                    : Icon(
                        Icons.save,
                        color: CustomColors.light1Grey,
                      ))
            : null,
      ),
    );
  }

  Container _cardFile({String? title}) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CustomColors.lightIndigo,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/img/file.svg",
            width: 70,
          ),
          SizedBox(
            width: 8,
          ),
          H2Text(
            text: title!,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            maxLines: 2,
          ),
          Expanded(child: SizedBox()),
          Icon(Icons.keyboard_arrow_right_outlined),
        ],
      ),
    );
  }

  void selectFile(RunnerProvider cache) async {
    // Abre el selector de archivos para seleccionar un archivo PDF
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // Verifica si se ha seleccionado un archivo
    if (result == null) {
      //Nose encontro archivos.
    } else {
      // Actualiza el estado del widget con el archivo seleccionado
      print('File selected: ${result.files.single.path}');
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
      if (selectedFile != null) {
        //Guardamos en PROVIUDER el FILE path de certificado
        cache.setMedicalCertificateFile(selectedFile!);
      }
    }
  }
}

class PDfViewChild extends StatelessWidget {
  const PDfViewChild({
    super.key,
    required this.selectedFile,
  });

  final File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return PDFView(filePath: selectedFile!.path);
  }
}

class BulletListItem extends StatelessWidget {
  final String text;

  const BulletListItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 13),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
