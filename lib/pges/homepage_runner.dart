
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/utils/assets_speack.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/runner_avisos_widget.dart';
import 'package:chasski/widgets/runner_hom_optionwidget.dart';
import 'package:chasski/widgets/runner_home_widget.dart';
import 'package:chasski/widgets/runner_qr_generate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PageHomeRunner extends StatefulWidget {
  const PageHomeRunner({super.key});

  @override
  State<PageHomeRunner> createState() => _PageHomeRunnerState();
}

class _PageHomeRunnerState extends State<PageHomeRunner> {
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  //Index de navigator Bar: Default
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
        return HomeOptions();
      case 1:
        return QrRunnerChild();
      case 2:
        return AlertNotification();
      default:
        return HomeRunnerChild();
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  //FIREBASE
  void getUsers() {
  String user = Provider.of<RunnerProvider>(context, listen: false)
      .usuarioEncontrado!.nombre;
     TextToSpeechService()
        .speak('Bienvenido,${user}');
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildBody(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: IconButton(
        onPressed: () {
          setState(() {
            ontapIndex(1);
          });
        },
        icon: CircleAvatar(
          radius: 40,
          backgroundColor: CustomColors.darkIndigo,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                  color: CustomColors.light1Grey, child: runnerLotiesQR),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Color de splash transparente
          highlightColor: Colors.transparent, // Color de highlight transparente
        ),
        child: BottomNavigationBar(
            elevation: 10,
            backgroundColor:Colors.white,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.black,
            currentIndex: _selectindex,
            onTap: ontapIndex,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/homes.svg',
                    width: 30,
                  ),
                  label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.adjust_outlined,
                    color: Colors.transparent,
                    size: 30,
                  ),
                  label: 'Mi QR'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/notification.svg',
                    width: 30,
                  ),
                  label: 'Avisos'),
            ]),
      ),
    );
  }
}
