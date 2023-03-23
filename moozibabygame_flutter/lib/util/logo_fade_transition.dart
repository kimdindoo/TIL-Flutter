import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moozibabygame_flutter/controller/ble_controller.dart';

class logoFade extends StatefulWidget {
  const logoFade({super.key});

  @override
  State<logoFade> createState() => _logoFadeState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _logoFadeState extends State<logoFade> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
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
    Get.put(BleController());
    return Obx(
      () => BleController.to.bleLoading == false
          ? Container(
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/logo_moozi.png',
                  height: 100.h,
                ),
              ),
            )
          : Container(
              child: Image.asset(
                'assets/logo_moozi.png',
                height: 100.h,
              ),
            ),
    );
  }
}
