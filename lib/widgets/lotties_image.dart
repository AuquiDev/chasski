
import 'package:chasski/widgets/color_custom.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class LottiesImage extends StatelessWidget {
  const LottiesImage({
    super.key,
    // required this.size,
  });

  // final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
        alignment: Alignment.bottomCenter,
        children: [
           Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(3.14159 /
                  3) 
              ..rotateZ(
                  3.14159),
            child: RippleAnimation(
              repeat: true,
              ripplesCount: 1,
              duration: const Duration(milliseconds: 2800),
              color: Color.fromARGB(6, 255, 255, 255).withOpacity(.1),
              child: SizedBox(
                width: 200,
                height: 60,
              ),
            ),
          ),
          Container(
            height: size.height * .3,
            child: runnerLoties,
          ),
         
        ],
      );
  }
}
