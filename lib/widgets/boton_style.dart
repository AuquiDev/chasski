import 'package:flutter/material.dart';

ButtonStyle buttonStyle2() {
    return const ButtonStyle(
        maximumSize: MaterialStatePropertyAll(Size(150, 80)),
        // minimumSize: MaterialStatePropertyAll(Size(80, 40)),
        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 0, right: 0)),
        elevation: MaterialStatePropertyAll(2),
        visualDensity: VisualDensity.compact,
        surfaceTintColor: MaterialStatePropertyAll(Colors.brown),
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        overlayColor: MaterialStatePropertyAll(Colors.brown),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        )));
  }