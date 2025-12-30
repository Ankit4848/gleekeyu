import 'dart:async';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final String dateTimeStr; // Example: "18:39"
  final String type; // Only "time" supported here

  const CountdownTimerWidget({
    Key? key,
    required this.dateTimeStr,
    required this.type,
  }) : super(key: key);

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();

    if (widget.type == "time") {
      final targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(widget.dateTimeStr.split(":")[0]),
        int.parse(widget.dateTimeStr.split(":")[1]),
      );

      final difference = targetTime.difference(now);
      _timeLeft = difference.isNegative ? Duration.zero : difference;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds <= 0) {
        timer.cancel();
        _animationController.stop();
      } else {
        setState(() {
          _timeLeft -= Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const SizedBox(width: 8),
        ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset("assets/images/image.png", width: 40),
        ),

       /* Text(
          _timeLeft.inSeconds <= 0
              ? "Time over"
              : "${_formatDuration(_timeLeft)} left",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        )*/
      ],
    );
  }
}
