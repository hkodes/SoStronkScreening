import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class RipplesAnimation extends StatefulWidget {
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Color(0xFF0F1532),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 250),
              child: Positioned.fill(
                left: 10,
                right: 10,
                child: Stack(children: [
                  Positioned.fill(
                    child: RadarView(),
                  ),
                  Positioned(
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: Colors.deepPurple.shade700,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.shade700
                                          .withOpacity(.5),
                                      blurRadius: 5.0,
                                      spreadRadius: 3.0,
                                    ),
                                  ]),
                            ),
                          ]),
                    ),
                  ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.deepPurple.shade700,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                height: 300,
                width: 370,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepPurple.shade700,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          height: 70.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: Colors.deepPurple.shade700,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.shade700
                                      .withOpacity(.5),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Text(
                          "test",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          height: 70.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: Colors.deepPurple.shade700,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.shade700
                                      .withOpacity(.5),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Text(
                          "test",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class RadarView extends StatefulWidget {
  @override
  _RadarViewState createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween(begin: .0, end: pi * 2).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: RadarPainter(_animation.value),
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;

  Paint _bgPaint = Paint()
    ..color = Colors.amber.withOpacity(0.5)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.amber.withOpacity(0.3);

  int circleCount = 2;

  RadarPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = min(size.width / 2, size.height / 2);

    for (var i = 1; i <= circleCount; ++i) {
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), radius * i * 0.45, _bgPaint);
    }

    canvas.save();
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: radius * 0.9),
        0,
        pi / 1.3,
        true,
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
