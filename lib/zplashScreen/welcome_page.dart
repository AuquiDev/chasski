
import 'package:chasski/pages/t_login_home.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
        _showHomePage = true;
      });
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            // decoration: gradientBackgroundlogin(),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/img/logo_smallar.png',
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ),
                ),
                // AnimatedOpacity(
                //   opacity: _showHomePage ? 1.0 : 0.0,
                //   duration: const Duration(seconds: 4),
                //   child: LoginPage(),
                // )
                 AnimatedOpacity(
                  opacity: _showHomePage ? 1.0 : 0.0,
                  duration: const Duration(seconds: 4),
                  child: LoginHome(),
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
