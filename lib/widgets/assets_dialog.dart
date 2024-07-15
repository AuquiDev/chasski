import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const PlatformAlertDialog(
      {Key? key, required this.message, required this.title})
      : super(key: key);

  static void show({BuildContext? context, String? message, String? title}) {
    showDialog(
      context: context!,
      builder: (context) =>
          PlatformAlertDialog(message: message!, title: title!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text('Alert'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}
