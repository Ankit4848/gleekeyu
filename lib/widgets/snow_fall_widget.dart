import 'dart:math';
import 'package:flutter/material.dart';

class SnowFallWidget extends StatefulWidget {
  final Widget child;

  const SnowFallWidget({Key? key, required this.child}) : super(key: key);

  @override
  _SnowFallWidgetState createState() => _SnowFallWidgetState();
}

class _SnowFallWidgetState extends State<SnowFallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final Random _random = Random();

  // Unicode snowflake characters
  final List<String> _snowflakeChars = ['❄', '❅', '❆', '✻', '✼', '✽'];

  @override
  void initState() {
    super.initState();
    // Initialize snowflakes
    for (int i = 0; i < 100; i++) {
      _snowflakes.add(_createSnowflake(initial: true));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  Snowflake _createSnowflake({bool initial = false}) {
    return Snowflake(
      x: _random.nextDouble(),
      y: initial ? _random.nextDouble() : -0.1,
      size: _random.nextDouble() * 14 + 10, // Size between 10 and 24
      speed: _random.nextDouble() * 0.002 + 0.001,
      rotation: _random.nextDouble() * 2 * pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.02,
      character: _snowflakeChars[_random.nextInt(_snowflakeChars.length)],
      opacity: _random.nextDouble() * 0.5 + 0.3, // Opacity between 0.3 and 0.8
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              _updateSnowflakes();
              return CustomPaint(
                size: Size.infinite,
                painter: SnowPainter(_snowflakes),
              );
            },
          ),
        ),
      ],
    );
  }

  void _updateSnowflakes() {
    for (var flake in _snowflakes) {
      flake.y += flake.speed;
      flake.rotation += flake.rotationSpeed;

      if (flake.y > 1.1) {
        // Recycle flake
        flake.y = -0.1;
        flake.x = _random.nextDouble();
        flake.size = _random.nextDouble() * 14 + 10;
        flake.speed = _random.nextDouble() * 0.002 + 0.001;
        flake.rotation = _random.nextDouble() * 2 * pi;
        flake.rotationSpeed = (_random.nextDouble() - 0.5) * 0.02;
        flake.character =
            _snowflakeChars[_random.nextInt(_snowflakeChars.length)];
        flake.opacity = _random.nextDouble() * 0.5 + 0.3;
      }
    }
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;
  double rotation;
  double rotationSpeed;
  String character;
  double opacity;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
    required this.character,
    required this.opacity,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in snowflakes) {
      _drawSnowflake(canvas, size, flake);
    }
  }

  void _drawSnowflake(Canvas canvas, Size size, Snowflake flake) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: flake.character,
        style: TextStyle(
          color: Colors.white.withOpacity(flake.opacity),
          fontSize: flake.size,
          fontFamily:
              'Arial', // Ensure a font that supports these chars usually works, or rely on default
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final x = flake.x * size.width;
    final y = flake.y * size.height;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(flake.rotation);
    // Center the text on the coordinate
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
