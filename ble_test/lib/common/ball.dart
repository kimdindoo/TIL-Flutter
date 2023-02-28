import 'package:ble_test/common/data.dart';
import 'package:flutter/material.dart';

class ReflectBall extends StatefulWidget {
  final double mapXsize;
  final double mapYsize;
  final double xPosition;
  final double yPosition;
  final int ballRad;
  final double xVector;
  final double yVector;
  final double xSpeed;
  final double ySpeed;

  const ReflectBall(
      {Key? key,
      required this.mapXsize,
      required this.mapYsize,
      required this.xPosition,
      required this.yPosition,
      required this.ballRad,
      this.xVector = 1,
      this.yVector = 1,
      required this.xSpeed,
      required this.ySpeed})
      : super(key: key);

  @override
  _ReflectBallState createState() => _ReflectBallState();
}

class _ReflectBallState extends State<ReflectBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double xPos;
  late double yPos;
  late double xVec;
  late double yVec;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    xPos = widget.xPosition;
    yPos = widget.yPosition;
    xVec = widget.xVector;
    yVec = widget.yVector;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1));
    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (xPos >= (widget.mapXsize - widget.ballRad) ||
              xPos <= widget.ballRad) {
            xVec *= -1;
          }
          if (yPos >= (widget.mapYsize - widget.ballRad) ||
              yPos <= widget.ballRad) {
            yVec *= -1;
          }

          xPos += widget.xSpeed * xVec;
          yPos += widget.ySpeed * yVec;
        });
        _animationController.value = 0;
        // _animationController.forward();
      }

      Offset postionPlus = Offset(200, 400);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.mapXsize,
          height: widget.mapYsize,
          color: Colors.lightGreen,
          child: CustomPaint(
            painter: _ball(
                animationValue: _animationController.value,
                xVector: xVec,
                yVector: yVec,
                xPosition: xPos,
                yPosition: yPos,
                ballRad: widget.ballRad,
                xSpeed: widget.xSpeed,
                ySpeed: widget.ySpeed),
          ),
        );
      },
    );
  }
}

class _ball extends CustomPainter {
  final animationValue;
  final xPosition;
  final yPosition;
  final xVector;
  final yVector;
  final ballRad;
  final xSpeed;
  final ySpeed;

  _ball({
    required this.animationValue,
    required this.xPosition,
    required this.yPosition,
    required this.xVector,
    required this.yVector,
    required this.ballRad,
    required this.xSpeed,
    required this.ySpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();

    for (double i = 0; i < ballRad; i++) {
      path.addOval(Rect.fromCircle(
          center: Offset(
            // Gyro.x + animationValue*xSpeed*xVector,
            // Gyro.y + animationValue*ySpeed*yVector,
            200 + Gyro.x.toDouble(),
            150 + Gyro.y.toDouble(),
          ),
          radius: i));
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
