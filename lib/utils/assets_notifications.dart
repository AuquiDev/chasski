import 'package:chasski/widgets/assets_textapp.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';

void showCustomNotification(BuildContext context, {required String title}) {
  ElegantNotification.error(
    stackedOptions: StackedOptions(
      key: 'topRight',
      type: StackedType.same,
      itemOffset: Offset(0, 0),
      scaleFactor: BorderSide.strokeAlignOutside
    ),
    position: Alignment.bottomCenter,
    animation: AnimationType.fromBottom,
    description: P2Text(
      text: title,
      color: Colors.black,
    ),
    // background: Colors.red.withOpacity(.2),
    height: 60,
    width: 350,
  ).show(context);
}
