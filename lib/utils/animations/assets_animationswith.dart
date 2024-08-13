
import 'package:flutter/cupertino.dart';

class AssetsAnimationSwitcher extends StatelessWidget {
  const AssetsAnimationSwitcher({
    super.key,
    required this.child,  this.duration = 2000,
  });
  final Widget child;
  final int duration;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: duration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              alignment: Alignment.topCenter,
              scale: animation,
              child: child,
            ),
          );
        },
        child: child);
  }
}
