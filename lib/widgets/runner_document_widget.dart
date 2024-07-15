
import 'package:chasski/utils/assets_title_login.dart';
import 'package:chasski/widgets/assets_loties.dart';
import 'package:chasski/widgets/widget/runner_appbar_widget.dart';
import 'package:chasski/widgets/widget/runner_save_deslinde.dart';
import 'package:chasski/widgets/widget/steepers_routes_widget.dart';
import 'package:flutter/material.dart';

class DocumentRunnerWidget extends StatelessWidget {
  const DocumentRunnerWidget({
    super.key,
  });

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              AssetsListTitle(
                title1: 'Información Importante', 
                parrafo: 'Es importante generar y conservar el QR en todo momento del Andes Race. ' +
                'Completa los siguientes pasos obligatorios: ', 
                fontsize: 18, 
                duration: 500, 
                leading: IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  padding:EdgeInsets.all(0),
                  onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close, color: Colors.white,)),
                trailing: AppLoties(width: 100).qrLoties,),
              SteeprCustom(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SaveTablebarWidget(),
    );
  }

  
}
