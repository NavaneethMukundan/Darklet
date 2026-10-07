import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

/// Read-only search bar that opens the search screen when tapped.
class SearchFieldWidget extends StatelessWidget {
  final String content;
  final VoidCallback? onTap;
  const SearchFieldWidget({super.key, required this.content, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: content,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.kWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.kLightGrey.withValues(alpha: 0.6),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              kWidth15,
              Icon(Icons.search_rounded, color: color.kBlackSecondary),
              kWidth10,
              Expanded(
                child: Text(
                  content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ts(14, w: FontWeight.w400, c: color.kGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
