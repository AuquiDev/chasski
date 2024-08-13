import 'dart:async';

import 'package:flutter/material.dart';

class RepeatingPopup extends StatefulWidget {
  const RepeatingPopup(
      {super.key, required this.banner, required this.isPopupActive});
  final Widget banner;
  final bool isPopupActive;
  @override
  _RepeatingPopupState createState() => _RepeatingPopupState();
}

class _RepeatingPopupState extends State<RepeatingPopup> {
  // bool _isPopupActive = true;
  bool _isPopupVisible = false;
  // late bool _isPopupActive;
  Timer? _initialTimer;
  Timer? _repeatingTimer;

  @override
  void initState() {
    super.initState();

    _startInitialPopup();
  }

  @override
  void dispose() {
    _initialTimer?.cancel();
    _repeatingTimer?.cancel();
    super.dispose();
  }

  void _startInitialPopup() {
    _initialTimer = Timer(Duration(seconds: 3), () {
      if (widget.isPopupActive &&
          !_isPopupVisible &&
          ModalRoute.of(context)?.isCurrent == true) {
        _showPopup();
        _startRepeatingPopup();
      }
    });
  }

  void _startRepeatingPopup() {
    const duration = Duration(seconds: 30);
    _repeatingTimer = Timer.periodic(duration, (timer) {
      if (widget.isPopupActive &&
          !_isPopupVisible &&
          ModalRoute.of(context)?.isCurrent == true) {
        _showPopup();
      }
    });
  }

  void _showPopup() {
    if (!mounted) return;
    print('********************${widget.isPopupActive}*****************');
    _isPopupVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.white, //Colors.transparent,
          content: Stack(
            children: [
              widget.banner,
              IconButton(
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                    _isPopupVisible = false;
                  }
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isPopupVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircleAvatar(
      radius: 5,
      child: Text('popUp'),
    ));
  }
}
