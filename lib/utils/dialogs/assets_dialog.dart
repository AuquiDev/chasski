import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssetAlertDialogPlatform extends StatelessWidget {
  final String title;
  final String message;
  final Widget? child;

  const AssetAlertDialogPlatform(
      {Key? key, required this.message, required this.title, this.child})
      : super(key: key);

  static void show({required BuildContext context, required String message, required String title, Widget? child}) {
    showDialog(
      context: context,
      builder: (context) => AssetAlertDialogPlatform(
        message: message,
        title: title,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                if (child != null) child!,
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                if (child != null) child!,
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
  }
}
