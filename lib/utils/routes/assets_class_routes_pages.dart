
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';
class RoutesLocalStorage {
  Widget icon;
  String title;
  Widget path;
  String? content;
  RoutesLocalStorage(
      {required this.icon, required this.title, required this.path, this.content});
}


class ChartData {
  final String action;
  final double percentage;
  final Color color;

  ChartData(this.action, this.percentage, this.color);
}



Widget buildLegendItem(String text, String peecent, Color color) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: color,
            ),
            SizedBox(width: 8),
            Text(text),
          ],
        ),
        H1Text(text: peecent),
      ],
    ),
  );
}
