
import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:flutter/material.dart';

class AlertNotification extends StatelessWidget {
  const AlertNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: CustomColors.tealListh,
        child: Column(
          children: [H2Text(text: 'AlertNotification')],
        ));
  }
}
