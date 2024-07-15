import 'package:chasski/utils/assets_delayed_display.dart';
import 'package:chasski/widgets/assets_loties.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class LottiesImage extends StatelessWidget {
  const LottiesImage({
    super.key,  this.height,
  });
  final double? height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(3.14159 / 2.2)
            ..rotateZ(3.14159 * 2),
          child: RippleAnimation(
            repeat: true,
            ripplesCount: 5,
            duration: const Duration(milliseconds: 2800),
            color: Color.fromARGB(86, 188, 184, 184).withOpacity(.2),
            child: Container(
              height: 40,
            ),
          ),
        ),
        AssetsDelayedDisplayX(
          fadingDuration: 1000,
          duration: 300,
          curve: Curves.ease,
          child: SizedBox(
            height:height==null ? size.height * .3 : height,
            child: AppLoties(width: 150).runnerLoties,
          ),
        ),
      ],
    );
  }
}
