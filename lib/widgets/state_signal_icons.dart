import 'dart:async';


import 'package:chasski/widgets/assets_textapp.dart';
import 'package:chasski/widgets/color_custom.dart';
import 'package:flutter/material.dart';
import 'package:chasski/provider_cache/provider_cache.dart';

import 'package:provider/provider.dart';

class OfflineSIgnalButon extends StatelessWidget {
  const OfflineSIgnalButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10,vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         const SignalAPi(),
          SizedBox(width: 2),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H2Text(
                text: 'Ayuda',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:  CustomColors.darkIndigo,
              ),
              // isoffline
              //     ? const H2Text(
              //         text: 'offline',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //         color: Color.fromARGB(255, 75, 69, 69),
              //       )
              //     : const H2Text(
              //         text: 'online',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.green,
              //       ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignalAPi extends StatefulWidget {
  const SignalAPi({super.key});

  @override
  State<SignalAPi> createState() => _SignalAPiState();
}

class _SignalAPiState extends State<SignalAPi> {
  late Timer _timer;
  int _signalStrength = 0;

  @override
  void initState() {
    super.initState();
    _startSignalAnimation();
  }

  void _startSignalAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Simulamos una actualización de intensidad de señal
        _signalStrength = (_signalStrength + 1) % 2;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;
    return Icon(
      _getSignalIcon(),
      size: 15,
      color:isoffline ? Colors.red : Colors.green,
    );
  }

  IconData _getSignalIcon() {
    switch (_signalStrength) {
      case 0:
        return Icons.offline_bolt;
      case 1:
        return Icons.offline_bolt_outlined;
      default:
        return Icons.offline_bolt;
    }
  }
}
