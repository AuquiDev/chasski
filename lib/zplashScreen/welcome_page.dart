
import 'package:chasski/pges/t_login_home.dart';
import 'package:chasski/widgets/assets_imge.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  bool showhomePage = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showhomePage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                        .animate(_controller),
                child: Image.asset(
                  AppImages.logoAdidas,
                  color: Colors.white,
                  width: 80,
                ),
              ),
              SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(_controller),
                child: Image.asset(
                  AppImages.logoAndesRace,
                  width: 80,
                ),
              ),
              AnimatedOpacity(
                curve: Curves.easeInOut,
                  opacity: showhomePage ? 1 : 0,
                  duration: const Duration(seconds: 5),
                  child: const LoginHome(),
                  )
            ],
          ),
        ));
  }
}
