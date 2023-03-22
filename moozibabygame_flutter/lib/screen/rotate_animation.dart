import "dart:math" show pi;
import 'package:flutter/material.dart';

class RotateAnimation extends StatefulWidget {
  RotateAnimation({Key? key, this.child}) : super(key: key);
  final child;

  @override
  RotateAnimationState createState() => RotateAnimationState();
}

class RotateAnimationState extends State<RotateAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  bool forwardDirection = false;
  double rotationAngle = 0.0;
  double oldAngle = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animationController.value = 0.0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      //초기화
      rotationAngle = 0.0;
      oldAngle = 0.0;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 200,
      child: TextButton(
        onPressed: () {
          if (isStopAnimation()) {
            if (forwardDirection) {
              startRotateAnimation(false);
            } else {
              startRotateAnimation(true);
            }
          } else {
            stopRotateAnimation();
          }
        },
        child: AnimatedBuilder(
          animation: animationController,
          child: widget.child,
          builder: (BuildContext context, Widget? _widget) {
            final value = animationController.value;
            double step = 0.0;
            if (oldAngle > value) {
              step = (1.0 - oldAngle) + value;
            } else {
              step = value - oldAngle;
            }
            oldAngle = value;
            if (forwardDirection) {
              rotationAngle += step;
              if (0.5 < rotationAngle) {
                rotationAngle -= step;
              }
            } else {
              rotationAngle -= step;
              if (0.5 < rotationAngle) {
                rotationAngle += step;
              }
            }
            final angle = rotationAngle * (pi * 2);
            return Transform.rotate(
              angle: angle,
              child: _widget,
            );
          },
        ),
      ),
    );
  }

  startRotateAnimation(bool direction) async {
    forwardDirection = direction;
    oldAngle = animationController.value;
    animationController.repeat();
  }

  isStopAnimation() {
    return !animationController.isAnimating;
  }

  stopRotateAnimation() {
    animationController.stop();
    setState(() {});
  }
}
