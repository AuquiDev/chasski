import 'dart:io';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/layuot/asset_listtile.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class EditUSerPage extends StatefulWidget {
  const EditUSerPage({
    super.key,
  });

  @override
  State<EditUSerPage> createState() => _EditUSerPageState();
}

class _EditUSerPageState extends State<EditUSerPage> {
  bool isLoadingCamera = false;
  bool isLoadingGallery = false;
  File? imagenFile;
  @override
  Widget build(BuildContext context) {
    ParticipantesModel? user =
        Provider.of<CacheParticpantesProvider>(context).usuarioEncontrado;
    final runnerProvider = Provider.of<TParticipantesProvider>(context);
    List<ParticipantesModel> runnerProfile = runnerProvider.listaRunner;

    ParticipantesModel runner = runnerProfile.firstWhere(
        (e) => e.id == user!.id,
        orElse: () => participantesModelDefault());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: H1Text(
            text: runner.title + ' ' + runner.apellidos,
            color: AppColors.backgroundLight),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AssetsAnimationSwitcher(
                      child: imagenFile == null
                          ? GLobalImageUrlServer(
                              duration: 200,
                              fadingDuration: 300,
                              image: runner.imagen ?? ' ',
                              collectionId: runner.collectionId ?? '',
                              id: runner.id ?? '',
                              borderRadius: BorderRadius.circular(300),
                              height: size.height * .4,
                              width: size.height * .4,
                            )
                          : SizedBox()),
                  AssetsAnimationSwitcher(
                      child: imagenFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imagenFile!,
                                height: size.height * .4,
                                width: size.height * .4,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : SizedBox.shrink())
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: buttonStyle2(),
                      onPressed: () async {
                        dialogPlataform(context);
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
                          ? AssetsCircularProgreesIndicator()
                          : P2Text(
                              text: 'Guardar ',
                              color: Colors.white,
                            ),
                    )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: decorationBox(color: Colors.white),
                width: 300,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    H2Text(text: 'Editar Contraseña'),
                    PasswordEdit(
                      runner: runner,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveeUpdateFoto(
      TParticipantesProvider runnerProvider, ParticipantesModel runner) async {
    await runnerProvider.updateTAsistenciaProvider(
        // id: runner.id,
        // idEvento: runner.idEvento,
        // idDistancia: runner.idDistancia,
        // nombre: runner.nombre,
        // apellidos: runner.apellidos,
        // dorsal: runner.dorsal,
        // pais: runner.pais,
        // telefono: runner.telefono,
        // estado: runner.estado,
        // genero: runner.genero,
        // numeroDeDocumentos: runner.numeroDeDocumentos,
        // tallaDePolo: runner.tallaDePolo,
        id: runner.id,
        idsheety: runner.idsheety,
        idEvento: runner.idEvento ?? '',
        idDistancia: runner.idDistancia ?? "",
        estado: runner.estado,
        dorsal: runner.dorsal,
        contrasena: runner.contrasena,
        date: runner.date,
        key: runner.key,
        title: runner.title,
        nombre: runner.nombre,
        apellidos: runner.apellidos,
        distancias: runner.distancias,
        pais: runner.pais,
        email: runner.email,
        telefono: runner.telefono,
        numeroDeWhatsapp: runner.numeroDeWhatsapp,
        tallaDePolo: runner.tallaDePolo,
        fechaDeNacimiento: runner.fechaDeNacimiento,
        documento: runner.documento,
        numeroDeDocumentos: runner.numeroDeDocumentos,
        team: runner.team,
        genero: runner.genero,
        rangoDeEdad: runner.rangoDeEdad,
        grupoSanguineo: runner.grupoSanguineo ?? '',
        haSidoVacunadoContraElCovid19: runner.haSidoVacunadoContraElCovid19,
        alergias: runner.alergias,
        nombreCompleto: runner.nombreCompleto,
        parentesco: runner.parentesco,
        telefonoPariente: runner.telefonoPariente,
        carrerasPrevias: runner.carrerasPrevias,
        porQueCorresElAndesRace: runner.porQueCorresElAndesRace,
        deCuscoAPartida: runner.deCuscoAPartida,
        deCuscoAOllantaytambo: runner.deCuscoAOllantaytambo,
        comoSupisteDeAndesRace: runner.comoSupisteDeAndesRace,
        imagenFile: imagenFile);
    setState(() {
      imagenFile = null;
    });
  }

  void dialogPlataform(BuildContext context) async {
    AssetAlertDialogPlatform.show(
      context: context,
      message: 'Selecione una opción:',
      title: 'Editar perfil',
      child:
          Material(color: Colors.transparent, child: _contentDialog(context)),
    );
  }

  Widget _contentDialog(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ElevatedButton(
        child: isLoadingCamera
            ? AssetsCircularProgreesIndicator()
            : H3Text(text: 'Camera'),
        onPressed: isLoadingCamera
            ? null
            : () async {
                setState(() {
                  isLoadingCamera = true;
                });

                try {
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker
                      .pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      )
                      .timeout(Duration(seconds: 60));
                  if (pickedFile == null) {
                    print('No image selected');
                  } else {
                    print('Image selected: ${pickedFile.path}');
                    setState(() {
                      imagenFile = File(pickedFile.path);
                      isLoadingCamera = false;
                    });
                  }
                } catch (e) {
                  print('Error selecting image: $e');
                } finally {
                  setState(() {
                    isLoadingCamera = false;
                  });
                }
                Navigator.of(context).pop();
              },
      ),
      SizedBox(width: 5),
      ElevatedButton(
        child: H3Text(text: 'Gallery'),
        onPressed: () async {
          try {
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
              // Check if the image is a PNG and convert it to JPEG if necessary
              if (imagenFile!.path.endsWith('.png')) {
                await convertPngToJpeg(imagenFile!);
                // Update imagenFile with the new JPEG file
                final jpegFile = File('${imagenFile!.path}.jpg');
                setState(() {
                  imagenFile = jpegFile;
                });
              }
            }
          } catch (e) {
            print('Error selecting image: $e');
          }
          Navigator.of(context).pop();
        },
      ),
    ]);
  }

  Future<void> convertPngToJpeg(File file) async {
    final image = img.decodeImage(file.readAsBytesSync());
    if (image != null) {
      final jpegBytes = Uint8List.fromList(img.encodeJpg(image));
      final jpegFile = File('${file.path}.jpg');
      await jpegFile.writeAsBytes(jpegBytes);
    }
  }
}



class PasswordEdit extends StatefulWidget {
  const PasswordEdit({
    super.key,
    required this.runner,
  });

  final ParticipantesModel runner;

  @override
  State<PasswordEdit> createState() => _PasswordEditState();
}

class _PasswordEditState extends State<PasswordEdit> {
  final TextEditingController _passwordEditController = TextEditingController();
  bool isEditable = false;
  bool _isPasswordVisible = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _passwordEditController.text = widget.runner.contrasena.toString();
  }

  bool _validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void _savePassword() async {
    final password = _passwordEditController.text;
    if (_validatePassword(password)) {
      widget.runner.contrasena = password;
      final dataProvider =
          Provider.of<TParticipantesProvider>(context, listen: false);
      await dataProvider.saveProductosApp(widget.runner);

      setState(() {
        isEditable = !isEditable;
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText =
            'Debe contener al menos 8 caracteres, una mayúscula, una minúscula y un número.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TParticipantesProvider>(context);
    return isEditable
        ? Container(
            margin: EdgeInsets.all(6),
            // height: 50,
            child: Column(
              children: [
                if (_errorText != null)
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isEditable = !isEditable;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                          )),
                      Expanded(
                        child: P3Text(
                          text: _errorText!,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                TextField(
                  style: TextStyle(fontSize: 12),
                  controller: _passwordEditController,
                  obscureText:
                      !_isPasswordVisible, // Ocultar o mostrar la contraseña
                  decoration: InputDecoration(
                    errorText: '', //_errorText,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        IconButton(
                          icon: dataProvider.isSyncing
                              ? CircularProgressIndicator()
                              : Icon(
                                  Icons.save,
                                  size: 20,
                                ),
                          onPressed:
                              dataProvider.isSyncing ? null : _savePassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : customListTitle(
            leading: 'Contraseña',
            title:
                '******', // Ocultar la contraseña actual para mayor seguridad
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              },
              child: Icon(
                Icons.edit,
                size: 15,
              ),
            ),
          );
  }
}
