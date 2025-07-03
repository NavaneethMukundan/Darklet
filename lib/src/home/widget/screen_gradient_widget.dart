import 'package:flutter/material.dart';

class ScreenGradientWidget extends StatelessWidget {
  final Widget child;
  const ScreenGradientWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0XFFD6F3A2),
            Color.fromARGB(255, 242, 253, 224),
            Color.fromARGB(255, 254, 255, 251),
            Color.fromARGB(255, 254, 255, 251),
            Color(0XFFFFFFFF),
          ],
        ),
      ),
      child: child,
    );
  }
}
