import 'package:chasski/pages/runner_edit_profile_page.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';
import 'package:chasski/utils/gradient_background.dart';
import 'package:chasski/widgets/cerrar_sesion.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:chasski/widgets/runner_appbar_customwidget.dart';
import 'package:chasski/widgets/runner_avisos_widget.dart';
import 'package:chasski/widgets/runner_hom_optionwidget.dart';
import 'package:chasski/widgets/runner_home_widget.dart';
import 'package:chasski/widgets/runner_qr_generate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageHomeRunner extends StatefulWidget {
  const PageHomeRunner({super.key});

  @override
  State<PageHomeRunner> createState() => _PageHomeRunnerState();
}

class _PageHomeRunnerState extends State<PageHomeRunner> {
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  //Index de navigator Bar
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
      // Default manda el index 0
      default:
        return HomeRunnerChild();
    }
  }

  @override
  void initState() {
    super.initState();
  }
  //FIREBASE 
  void getUsers(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackgroundlogin(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            AppCustomRunner(),
            _buildBody(),
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> EditUSerPage()));
                        },
                        icon: SvgPicture.asset(
                          'assets/img/edit_user.svg',
                          width: 30,
                        )),
                    CloseSesionS(),
                  ],
                ),
              ),
            )
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
            elevation: 60,
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


class CloseSesionS extends StatelessWidget {
  const CloseSesionS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Theme.of(context).platform ==
              TargetPlatform.iOS) {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text('Cerrar Sesión'),
                content: CloseSesion(),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                // title: Text('Cerrar Sesión'),
                content: CloseSesion(),
                // actions: <Widget>[
                //   TextButton(
                //     child: Text('Ok'),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //   ),
                // ],
              ),
            );
          }
        },
        icon: SvgPicture.asset(
          'assets/img/off.svg',
          width: 22,
        ));
  }
}
