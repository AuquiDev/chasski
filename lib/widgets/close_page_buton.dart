
import 'package:flutter/material.dart';

class ClosePageButon extends StatelessWidget {
  const ClosePageButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CircleAvatar(
          backgroundColor: Colors.white10,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              )),
        ));
  }
}
