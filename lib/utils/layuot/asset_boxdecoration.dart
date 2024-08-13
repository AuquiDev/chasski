import 'package:flutter/material.dart';

BoxDecoration decorationBox({Color? color}) {
    return BoxDecoration(
        color: color ?? Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 3.0),
          )
        ]);
  }