import 'dart:io';

import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/assets_img_urlserver.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/assets_boton_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditUSerPage extends StatefulWidget {
  const EditUSerPage({
    super.key,
  });

  @override
  State<EditUSerPage> createState() => _EditUSerPageState();
}

class _EditUSerPageState extends State<EditUSerPage> {
  File? imagenFile;
  @override
  Widget build(BuildContext context) {
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado;
    final runnerProvider = Provider.of<TRunnersProvider>(context);
    List<TRunnersModel> runnerProfile = runnerProvider.listaRunner;

    TRunnersModel runner = runnerProfile.firstWhere((e) => e.id == user!.id,
        orElse: () => defaultRunner());
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagenFile == null
                ?
                  GLobalImageUrlServer(
            image: runner.imagen ?? ' ', 
            collectionId:  runner.collectionId!, 
            id: runner.id!, 
            borderRadius: BorderRadius.circular(300), 
            height: 180,
            width: 180,
            ) 
                : SizedBox(),
            imagenFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      imagenFile!,
                      height: 180,
                      // width: 180,
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                style: buttonStyle2(),
                onPressed: () async {
                  dialogPlataform();
                },
                child: P2Text(
                  text: 'Editar Foto',
                )),
            if (imagenFile != null)
              TextButton(
                style: buttonStyle1(),
                onPressed: runnerProvider.isSyncing
                    ? null
                    : () async {
                        saveeUpdateFoto(runnerProvider, runner);
                      },
                child: runnerProvider.isSyncing
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : P2Text(
                        text: 'Guardar ',
                        color: Colors.white,
                      ),
              )
          ],
        ),
        
      ],
    );
  }

  void saveeUpdateFoto(
      TRunnersProvider runnerProvider, TRunnersModel runner) async {
    await runnerProvider.updateTAsistenciaProvider(
        id: runner.id,
        idEvento: runner.idEvento,
        idDistancia: runner.idDistancia,
        nombre: runner.nombre,
        apellidos: runner.apellidos,
        dorsal: runner.dorsal,
        pais: runner.pais,
        telefono: runner.telefono,
        estado: runner.estado,
        genero: runner.genero,
        numeroDeDocumentos: runner.numeroDeDocumentos,
        tallaDePolo: runner.tallaDePolo,
        imagenFile: imagenFile);
    setState(() {
      imagenFile = null;
    });
  }

  void dialogPlataform() async {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: P1Text(
              text: 'Selecione una opción:',
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
            content: _contentDialog(context),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: P1Text(
              text: 'Selecione una opción:',
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
            // titlePadding: EdgeInsets.only(bottom: 0),
            actionsPadding: EdgeInsets.only(bottom: 0),
            contentPadding: EdgeInsets.only(bottom: 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _contentDialog(context),
                Divider(
                  height: 0,
                )
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _contentDialog(BuildContext context) {
    return Table(children: [
      TableRow(children: [
        CupertinoDialogAction(
          child: Text('Camera'),
          onPressed: () async {
            Navigator.of(context).pop();
            final picker = ImagePicker();
            final XFile? pickedFile = await picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 100,
            );
            if (pickedFile == null) {
              print('No image selected');
            } else {
              print('Image selected: ${pickedFile.path}');
              setState(() {
                imagenFile = File(pickedFile.path);
              });
            }
          },
        ),
        CupertinoDialogAction(
          child: Text('Gallery'),
          onPressed: () async {
            Navigator.of(context).pop();
            final picker = ImagePicker();
            final XFile? pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 100,
            );
            if (pickedFile == null) {
              print('No image selected');
            } else {
              print('Image selected: ${pickedFile.path}');
              setState(() {
                imagenFile = File(pickedFile.path);
              });
            }
          },
        ),
      ])
    ]);
  }
}
