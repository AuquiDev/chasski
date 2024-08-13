import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/utils/animations/assets_delayed_display.dart';
import 'package:chasski/utils/button/assets_boton_style.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/routes/assets_url_lacuncher.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/runner_document_widget.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';

class TabBarBottom extends StatelessWidget {
  const TabBarBottom({
    super.key,
    required this.heightBotton,
  });

  final double heightBotton;

  @override
  Widget build(BuildContext context) {
    final runner = RunnerData.getRunner(context);
    final checkDoc = RunnerData.getCheckDeslinde(context, runner);
    return Container(
      height: heightBotton,
      child: DefaultTabController(
        length: 1,
        initialIndex: 0,
        child: Column(
          children: [
            H1Text(
              text: '${runner.title} ' + '${runner.apellidos}',
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            P2Text(text: '${runner.pais}'),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  AssetsDelayedDisplayYbasic(
                    duration: 100,
                    child: Container(
                      decoration: decorationBox(color: Colors.white),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AppSvg(width: 60).pasaporteSvg,
                          P2Text(text: runner.documento.toString().toUpperCase()),
                          H3Text(text: '${runner.numeroDeDocumentos}')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  AssetsDelayedDisplayYbasic(
                    duration: 400,
                    child: Container(
                      decoration: decorationBox(color: Colors.white),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AppSvg(width: 90).generoSvg,
                          P2Text(text: 'Genero'),
                          H3Text(text: '${runner.genero}')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  AssetsDelayedDisplayYbasic(
                    duration: 600,
                    child: Container(
                      decoration: decorationBox(color: Colors.white),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AppSvg(width: 60).poloSvg,
                          P2Text(text: 'TallaDePolo'),
                          H3Text(text: '${runner.tallaDePolo}')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(color: Colors.grey),
            ElevatedButton(
                style: buttonStyle2(backgroundColor: AppColors.primaryRed),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentRunnerWidget()));
                },
                child: H3Text(
                  text: !fileNoEmpty(checkDoc)
                      ? 'Cargar Documentos'
                      : 'Editar Documentos',
                  color: Colors.white,
                )),
            fileNoEmpty(checkDoc)
                ? FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                      children: [
                        ElevatedButton.icon(
                          style: buttonStyle2(),
                          onPressed: () {
                            launchServerURL(
                                file: checkDoc.deslinde,
                                collectionId: checkDoc.collectionId,
                                id: checkDoc.id);
                          },
                          label: H3Text(text: 'Doc. Deslinde'),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvg(width: 20).pdfSvg,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: buttonStyle2(),
                          onPressed: () {
                            launchServerURL(
                                file: checkDoc.file,
                                collectionId: checkDoc.collectionId,
                                id: checkDoc.id);
                          },
                          label: H3Text(text: 'Cert. Medíco'),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppSvg(width: 20).pdfSvg,
                          ),
                        )
                      ],
                    ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  bool fileNoEmpty(TChekListmodel02File checkDoc) {
    return (checkDoc.file != null && checkDoc.file!.isNotEmpty);
  }
}
