import 'dart:math' as math;

import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';

/// Original, code-drawn illustration: concentric brand circles with a large
/// icon and a few orbiting dots. No image assets, so nothing to license.
class OnboardingArt extends StatelessWidget {
  final IconData icon;
  const OnboardingArt({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final size = math.min(c.maxWidth, c.maxHeight).clamp(160.0, 320.0);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _circle(size, color.secondaryColor.withValues(alpha: 0.5)),
              _circle(size * 0.72, color.secondaryColor),
              _circle(size * 0.46, color.primaryColor),
              Icon(icon, size: size * 0.24, color: color.onPrimary),
              for (final (angle, r, d) in const [
                (0.6, 0.48, 14.0),
                (2.4, 0.5, 10.0),
                (4.1, 0.46, 18.0),
                (5.3, 0.5, 8.0),
              ])
                Transform.translate(
                  offset: Offset(
                    math.cos(angle) * size * r,
                    math.sin(angle) * size * r,
                  ),
                  child: Container(
                    width: d,
                    height: d,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primaryDarkColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _circle(double d, Color c) => Container(
    width: d,
    height: d,
    decoration: BoxDecoration(shape: BoxShape.circle, color: c),
  );
}

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(
            child: Center(child: OnboardingArt(icon: icon)),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: ts(30, w: FontWeight.w700),
          ),
          kHeight15,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: ts(15, w: FontWeight.w400, c: color.kGrey),
          ),
          kHeight20,
        ],
      ),
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  final int currentIndex;
  final int count;
  final String label;
  final VoidCallback onNext;
  const OnboardingFooter({
    super.key,
    required this.currentIndex,
    required this.count,
    required this.label,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              count,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == currentIndex ? 26 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i == currentIndex
                      ? color.primaryDarkColor
                      : color.kLightGrey,
                ),
              ),
            ),
          ),
          kHeight25,
          PrimaryButton(label: label, onPressed: onNext),
        ],
      ),
    );
  }
}
