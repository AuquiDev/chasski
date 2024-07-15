
import 'dart:io';

import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/widgets/image_app_widget.dart';
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
     TRunnersModel? user =  Provider.of<RunnerProvider>(context).usuarioEncontrado;
    final runnerProvider = Provider.of<TRunnersProvider>(context);
    List<TRunnersModel> runnerProfile = runnerProvider.listaRunner;

    TRunnersModel runner = runnerProfile.firstWhere((e) => e.id == user!.id, 
    orElse: () => defaultRunner());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          
          ImageLoginRunner(
            user: runner,
            size: 200,
          ),
          Center(
            child: Text(runner.nombre),
          ),
            // Widget para previsualizar la imagen seleccionada
            imagenFile != null
                ? Image.file(imagenFile!, height: 100, width: 100)
                : const SizedBox.shrink(),

          IconButton(onPressed: () async {
             showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select Image Source'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Camera'),
                          onTap: () async {
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
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Gallery'),
                          onTap: () async {
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
                      ],
                    ),
                  ),
                );
              },
            );
          }, icon: Icon(Icons.camera)), 
          if (imagenFile != null )
          ElevatedButton(onPressed: ()async {
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
                        imagenFile: imagenFile
                      );
          }, child: Text('Enviar'))
        ],
      ),
    );
  }
}
