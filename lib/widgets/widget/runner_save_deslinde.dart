import 'package:chasski/provider/provider_t_checklist_02.dart';
import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/assets_animationswith.dart';
import 'package:chasski/widgets/assets-svg.dart';
import 'package:chasski/widgets/assets_colors.dart';
import 'package:chasski/widgets/assets_loties.dart';
import 'package:chasski/widgets/assets_pdfview.dart';
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/widget/app_provider_runner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveTablebarWidget extends StatelessWidget {
  const SaveTablebarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<RunnerProvider>(context);

    final double size = 40;
    return Table(
      border: TableBorder.all(color: AppColors.buttonSecondary.withOpacity(.2)),
      children: [
        TableRow(children: [
          if (cache.userPhotoBytes != null)
            Column(
              children: [
                H2Text(
                  text: '✅Foto',
                  textAlign: TextAlign.center,
                  fontSize: 14,
                ),
                SizedBox(
                    width: size,
                    height: size,
                    child: Image.memory(cache.userPhotoBytes!)),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Complete todos los documentos para habilitar guardar.'),
            ),
          if (cache.signatureImage != null)
            Column(
              children: [
                H2Text(
                  text: '✅Firma',
                  textAlign: TextAlign.center,
                  fontSize: 14,
                ),
                SizedBox(
                  width: size,
                  height: size,
                  child: Image.memory(cache.signatureImage!),
                ),
              ],
            ),
          if (cache.pdfFile != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AssetsPDfViewChild(selectedFile: cache.pdfFile)),
                );
              },
              child: Column(
                children: [
                  H2Text(
                    text: '✅Deslinde',
                    textAlign: TextAlign.center,
                    fontSize: 14,
                  ),
                  AppSvg(width: size).fileSvg
                ],
              ),
            ),
          if (cache.medicalCertificateFile != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssetsPDfViewChild(
                          selectedFile: cache.medicalCertificateFile)),
                );
              },
              child: Column(
                children: [
                  H2Text(
                    text: '✅Cert.Medico',
                    textAlign: TextAlign.center,
                    fontSize: 14,
                  ),
                  AppSvg(width: size).certificadoSgv
                ],
              ),
            ),
          if (cache.medicalCertificateFile != null && cache.pdfFile != null)
            SaveDocumentDeslinde()
        ]),
      ],
    );
  }
}

class SaveDocumentDeslinde extends StatelessWidget {
  const SaveDocumentDeslinde({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<RunnerProvider>(context);
    final runner = RunnerData.getRunner(context);
    final checkDoc = RunnerData.getCheckDeslinde(context, runner);
    //COCUMENTOS CHECK POINTS, para acceder a su metodo de carga
    final docProvider = Provider.of<TCheckList02Provider>(context);
    return GestureDetector(
        onTap: docProvider.isSyncing
            ? null
            : () async {
                await docProvider.saveProductosApp(context,
                    e: checkDoc,
                    fileFile: cache.medicalCertificateFile,
                    deslinde: cache.pdfFile);
              },
        child: Card(
          elevation: 10,
          color: Colors.green,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              H2Text(
                text: 'Guardar',
                textAlign: TextAlign.center,
                color: AppColors.backgroundLight,
                fontSize: 14,
              ),
              AssetsAnimationSwitcher(
                duration: 400,
                child:   docProvider.isSyncing
                  ? CircularProgressIndicator(
                      color: AppColors.backgroundLight,
                    )
                  : AppLoties(width: 50).saveLoties)
            ],
          ),
        ));
  }
}
