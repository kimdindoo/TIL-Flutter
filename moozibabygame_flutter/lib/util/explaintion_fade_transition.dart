import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplaintionFade extends StatefulWidget {
  const ExplaintionFade({super.key});

  @override
  State<ExplaintionFade> createState() => _ExplaintionFadeState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _ExplaintionFadeState extends State<ExplaintionFade>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.h,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _animation,
        child: Image.asset(
          'assets/explaintion.png',
          height: 200.h,
        ),
      ),
    );
  }
}
