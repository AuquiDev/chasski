import 'package:chasski/utils/colors/assets_colors.dart';
import 'package:chasski/utils/layuot/asset_boxdecoration.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:chasski/page/runner/documento/widget/runner_save_deslinde.dart';
import 'package:chasski/page/runner/documento/widget/steepers_routes_widget.dart';
import 'package:flutter/material.dart';

class DocumentRunnerWidget extends StatelessWidget {
  const DocumentRunnerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: H1Text(
            text: 'Información Importante'.toUpperCase(),
            color: AppColors.backgroundLight,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: SaveTablebarWidget()),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: decorationBox(),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(5),
                constraints: BoxConstraints(maxWidth: 360),
                child: FittedBox(
                  child: P2Text(
                    text:
                        'Es importante generar y conservar el QR en todo\nmomento del Andes Race. ' +
                            'Completa los siguientes\npasos obligatorios: ',
                    textAlign: TextAlign.justify,
                    color: AppColors.backgroundLight,
                  ),
                ),
              ),
              SteeprCustom(),
            ],
          ),
        ),
      ),
    );
  }
}
