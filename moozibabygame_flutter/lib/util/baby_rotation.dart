import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';

class BabyRotation extends StatefulWidget {
  const BabyRotation({super.key});

  @override
  State<BabyRotation> createState() => _BabyRotationState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _BabyRotationState extends State<BabyRotation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  late final Animation<double> newAnimation =
      Tween<double>(begin: 0.03, end: -0.03).animate(_animation);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: BleController.to.babyImageLocationY.value.h +
            BleController.to.gyroY.value.toDouble(),
        // 레프트로만 하려면 레프트: 넓이의반 - 베이비넓이의반
        left: MediaQuery.of(context).size.width / 2 -
            100.w +
            BleController.to.gyroX.value.toDouble(),
        // right: 0,
        child: BleController.to.baby.value == true
            ? RotationTransition(
                turns: newAnimation,
                child: Image.asset(
                  'assets/baby_${BleController.to.babyImage}.png',
                  height: 350.h,
                  width: 200.w,
                ),
              )
            : Container(
                child: Image.asset(
                  'assets/baby_${BleController.to.babyImage}.png',
                  height: 350.h,
                  width: 300.w,
                ),
              ),
      ),
    );
  }
}
