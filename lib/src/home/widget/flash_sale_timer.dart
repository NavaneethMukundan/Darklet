import 'dart:async';

import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

/// Counts down to the end of the current day (HH:MM:SS).
class FlashSaleTimer extends StatefulWidget {
  const FlashSaleTimer({super.key});

  @override
  State<FlashSaleTimer> createState() => _FlashSaleTimerState();
}

class _FlashSaleTimerState extends State<FlashSaleTimer> {
  Timer? _timer;
  Duration _left = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day + 1);
    setState(() => _left = end.difference(now));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    final text =
        '${two(_left.inHours)}:${two(_left.inMinutes % 60)}:${two(_left.inSeconds % 60)}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: ts(13, w: FontWeight.w600, c: color.onPrimary),
      ),
    );
  }
}
