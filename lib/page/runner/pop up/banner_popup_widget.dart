
import 'package:chasski/models/check%20list/model_list_check_list_ar.dart';
import 'package:chasski/provider/check%20list/provider__t_list_cheklist.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/runner_document_widget.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerEvento extends StatelessWidget {
  const BannerEvento({super.key});

  @override
  Widget build(BuildContext context) {
     final runner = RunnerData.getRunner(context);
     final checkDoc = RunnerData.getCheckDeslinde(context, runner);
     final checkList = Provider.of<TListCheckListProvider>(context).listAsistencia;
     final TListChekListModel data = checkList.firstWhere((e)=> checkDoc.idCheckList == e.id);
    return Container(
      width: 350,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundDark,
            AppColors.primaryRed,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: H1Text(
              text: '¡Atención!',
              fontSize: 40,
              color: AppColors.primaryWhite,
            ),
          ),
          SizedBox(height: 10),
          FittedBox(
            child: P2Text(
              text: 'Para competir en el evento necesitas:',
              textAlign: TextAlign.justify,
              maxLines: 2,
              color: AppColors.primaryWhite.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 10),
          Card(
            elevation: .5,
            color: Colors.transparent,//AppColors.buttonSecondary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: P2Text(
                      text: '1) Firmar Documento Deslinde',
                      fontSize: 16,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  FittedBox(
                    child: P2Text(
                      text: '2) Cargar Certificado Médico',
                      fontSize: 16,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          H1Text(text:
            'Fecha Límite:',
            fontSize: 28,
              color: AppColors.warningColor,
          ),
          FittedBox(
            child: Text(
              '${formatEventDates(data.horaApertura, data.horaCierre)}',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.warningColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'No te quedes fuera. Sube tus documentos antes de la fecha límite.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryWhite.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 20),
         ElevatedButton(
          style: buttonStyle1(backgroundColor: Colors.yellow),
          onPressed: (){  
            Navigator.push(context, MaterialPageRoute(builder: (context)=> DocumentRunnerWidget()));
         }, child: H3Text(text: 'Comenzar Ahora!'))
        ],
      ),
    );
  }
}
