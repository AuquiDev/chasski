import 'dart:ui';
import 'package:chasski/pages/t_empleado_login.dart';
import 'package:chasski/utils/gradient_background.dart';
import 'package:flutter/material.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({Key? key}) : super(key: key);

  @override
  _SplahScreenState createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  bool _showHomePage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showHomePage = true;
      });
    });
    
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginPage()),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: gradientBackground(),
              ),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, -1),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: Image.asset(
                    'assets/img/logo_small.png',
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_controller),
                  child: Image.asset(
                    'assets/img/logo_smallar.png',
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showHomePage ? 1.0 : 0.0,
                  duration: const Duration(seconds: 4),
                  child: LoginPage(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
