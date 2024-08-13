import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/check%20list/model_list_check_list_ar.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/page/runner/navbar/progress/home_progrees_runner.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/page/runner/navbar/profile/profile__home.dart';
import 'package:chasski/page/runner/pop%20up/banner_popup_widget.dart';
import 'package:chasski/page/runner/pop%20up/popup_widget_child.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:chasski/provider/check%20list/provider_cl02.dart';
import 'package:chasski/provider/check%20list/provider__t_list_cheklist.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/dialogs/assets_butonsheets.dart';
import 'package:chasski/utils/routes/assets_img_urlserver.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/speack/assets_speack.dart';
import 'package:chasski/page/runner/navbar/home/home_bar.dart';
import 'package:chasski/widget/doc%20runner%20pdf/runner_qr_generate.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageHomeRunner extends StatefulWidget {
  const PageHomeRunner({super.key});

  @override
  State<PageHomeRunner> createState() => _PageHomeRunnerState();
}

class _PageHomeRunnerState extends State<PageHomeRunner> {
   SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
   
  int _selectindex = 0;

  void ontapIndex(int index) {
    setState(() {
      _selectindex = index;
    });
  }

  //ConsTruimos el widgte de acuerdo al Index
  Widget _buildBody() {
    print(_selectindex);
    switch (_selectindex) {
      case 0:
        return InformationPage();
      // case 1:
      //   return Container();
      // case 2:
      //   return Container();
      case 1:
        return ProgreesRunnerPage();
      case 2:
        return RunnerProfile();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    getUsers();
     sharedPrefs.getLoggedInRunner();
    super.initState();
  }

  void getUsers() {
    ParticipantesModel user =
        Provider.of<CacheParticpantesProvider>(context, listen: false)
            .usuarioEncontrado!;
    TextToSpeechService().speak('Bienvenido,${user.title}');
  }

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    //INICIAMOS la lista: de todos los check list
    final listcheckL =
        Provider.of<TListCheckListProvider>(context).listAsistencia;
    //Buscamos segun el orden el que tenga Orden 1 en la lista de Checklist,
    //El orden 2 se refeire al Doc Deslinde comfigurado en el servidor.
    TListChekListModel check = listcheckL.firstWhere((e) => e.orden == 2,
        orElse: () => checkListDefault());
    //Ahora llamamos al CheckList Deslinde
    final deslindeProvider = Provider.of<TCheckList02Provider>(context);

    //SI el USURIO ESTA REGISTRADO: Encontramos el id del correcdor, si ya esta registrado devolvemos null.
    TChekListmodel02File docUser = deslindeProvider.listAsistencia
        .firstWhere((doc) => doc.idCorredor == (runner.id ?? ''), //user.id;
            orElse: () => chekListDocDefault());

    TChekListmodel02File e = TChekListmodel02File(
        id: (docUser.id == null) ? '' : docUser.id,
        idCorredor: runner.id ?? '', //user.id;
        idCheckList: check.id ?? '',
        fileUrl: '',
        fecha: DateTime.now(),
        estado: docUser
            .estado, //EL estado controla la visivilidad de Crear o Editar.
        detalles: 'detallesController',
        nombre: runner.nombre.toString(),
        dorsal: runner.dorsal.toString(),
        collectionId: docUser.collectionId.toString(),
        file: docUser.file,
        deslinde: docUser.deslinde);
    bool isCompleted =
        (e.deslinde?.isEmpty ?? true) && (e.file?.isEmpty ?? true);
    // devulve true es decir activa el POPUP
    print('********************$isCompleted*****************00');

    return Scaffold(
      body: Stack(
        children: [
          RepeatingPopup(
            banner: BannerEvento(),
            isPopupActive: isCompleted, //SI es true se activa popUp
          ),
          _buildBody(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: isCompleted
          ? null
          : IconButton(
              onPressed: () {
                showCustomBottonSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Column(
                      children: [
                        Center(child: QrRunnerChild()),
                      ],
                    );
                  },
                );
              },
              icon: CircleAvatar(
                radius: 35,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        color: Colors.white,
                        child: AppLoties(width: 80).qrLoties),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.black,
            currentIndex: _selectindex,
            onTap: ontapIndex,
            items: [
              BottomNavigationBarItem(icon: AppSvg().home1Svg, label: 'Home'),
              // BottomNavigationBarItem(
              //     icon: AppSvg().checkSvg, label: 'CheckList'),
              // BottomNavigationBarItem(
              //     icon: AppSvg().checkPointsSvg, label: 'CheckPoints'),
              BottomNavigationBarItem(
                  icon: AppSvg().timeSvg, label: 'Progreso'),
              BottomNavigationBarItem(
                icon: GLobalImageUrlServer(
                    duration: 20,
                    width: 30,
                    height: 30,
                    image: runner.imagen ?? '',
                    collectionId: runner.collectionId ?? '',
                    id: runner.id ?? '',
                    borderRadius: BorderRadius.circular(100)),
                label: getFirstWord(runner.title ?? ''),
              )
            ]),
      ),
    );
  }

  String getFirstWord(String text) {
    int spaceIndex = text.indexOf(' ');
    if (spaceIndex == -1) {
      // Si no hay espacio, retorna el texto completo
      return text;
    }
    return text.substring(0, spaceIndex);
  }
}
