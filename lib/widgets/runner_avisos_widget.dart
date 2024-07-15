
import 'package:chasski/utils/custom_text.dart';
import 'package:flutter/material.dart';

class AlertNotification extends StatelessWidget {
  const AlertNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 200),
        child: Column(
          children: [H2Text(text: 'AlertNotification')],
        ));
  }
}