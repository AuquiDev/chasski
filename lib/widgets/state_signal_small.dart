import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chasski/provider_cache/provider_cache.dart';
import 'package:chasski/utils/custom_text.dart';
import 'package:provider/provider.dart';

class OfflineSIgnalButonSmall extends StatelessWidget {
  const OfflineSIgnalButonSmall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
         isoffline
            ? const H2Text(
                text: 'offline',
                fontSize: 10,
                color: Colors.red,
              )
            : const H2Text(
                text: 'online',
                fontSize: 10,
                color: Colors.green,
              ),
        Container(
          padding: EdgeInsets.all(5),
          child: 
               isoffline ? const OnSignalOffline() : const SignalAPi(),
        ),
       
      ],
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
    return Icon(
      _getSignalIcon(),
      size: 15,
      color: Colors.green,
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

class OnSignalOffline extends StatefulWidget {
  const OnSignalOffline({super.key});

  @override
  State<OnSignalOffline> createState() => _OnSignalOfflineState();
}

class _OnSignalOfflineState extends State<OnSignalOffline> {
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
    return Icon(
      _getSignalIcon(),
      size: 15,
      color: Colors.redAccent,
    );
  }

  IconData _getSignalIcon() {
    switch (_signalStrength) {
      case 0:
        return Icons.offline_bolt_rounded;
      case 1:
        return Icons.offline_bolt_outlined;
      default:
        return Icons.offline_bolt_rounded;
    }
  }
}
