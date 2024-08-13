import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/check%20list/provider_cl02.dart';
// import 'package:chasski/provider_cache/provider_runner.dart';
import 'package:chasski/utils/animations/assets_animationswith.dart';
import 'package:chasski/utils/files/assets-svg.dart';
import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/files/assets_loties.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/layuot/assets_circularprogrees.dart';
import 'package:chasski/utils/layuot/assets_pdfview.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
// import 'package:chasski/widgets/assets_loties.dart';
import 'package:chasski/page/runner/documento/widget/runner_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveTablebarWidget extends StatelessWidget {
  const SaveTablebarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheParticpantesProvider>(context);
    final double size = 35;
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
            SaveDocumentDeslinde(),
        ]),
      ],
    );
  }
}

class SaveDocumentDeslinde extends StatelessWidget {
  const SaveDocumentDeslinde({super.key});

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheParticpantesProvider>(context);
    final runner = RunnerData.getRunner(context);
    final checkDoc = RunnerData.getCheckDeslinde(context, runner);
    //COCUMENTOS CHECK POINTS, para acceder a su metodo de carga
    final docProvider = Provider.of<TCheckList02Provider>(context);
    //Luego modificamos el valor de estado del corredor de False a TRUE.
    final runnerProvider = Provider.of<TParticipantesProvider>(context);
    return GestureDetector(
        onTap: docProvider.isSyncing
            ? null
            : () async {
                checkDoc.nombre = runner.title + ' ' + runner.apellidos;
                await docProvider.saveProductosApp(context,
                    e: checkDoc,
                    fileFile: cache.medicalCertificateFile,
                    deslinde: cache.pdfFile);
                // Actualizar el estado del corredor a true
                runner.estado = true;

                await runnerProvider.saveProductosApp(runner);
              },
        child: Container(
          decoration: decorationBox(color: Colors.green),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: AssetsAnimationSwitcher(
                    duration: 400,
                    child: docProvider.isSyncing
                        ? AssetsCircularProgreesIndicator()
                        : AppLoties(width: 50).saveLoties),
              )
            ],
          ),
        ));
  }
}
