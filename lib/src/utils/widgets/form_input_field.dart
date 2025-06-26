import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInputWidget extends StatelessWidget {
  final String hintText;
  final bool? readOnly;
  final bool? enablePrifix;
  final bool? isRequired;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final String? doc;
  final TextInputType? inputType;
  const FormInputWidget(
      {super.key,
      required this.hintText,
      this.hintStyle,
      this.inputFormatters,
      this.readOnly,
      this.controller,
      this.isRequired,
      this.doc,
      this.inputType,
      this.enablePrifix,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 4),
            child: Row(
              children: [
                Text(
                  hintText,
                  style: FontStyles().randomTextStylePoppins(
                      color: ColorManager().kBlack,
                      size: 14,
                      weight: FontWeight.w500),
                ),
                // isRequired == false
                //     ? const SizedBox.shrink()
                //     : Padding(
                //         padding: const EdgeInsets.only(
                //           bottom: 10,
                //           left: 3,
                //         ),
                //         child: Image.asset(
                //           AssetStore().star,
                //           height: 10,
                //           color: const Color.fromARGB(255, 191, 19, 6),
                //         ),
                //       )
              ],
            ),
          ),
          SizedBox(
            // height: 55,
            child: TextFormField(
              readOnly: readOnly ?? false,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $hintText';
                }
                return null;
              },
              onChanged: onChanged,
              keyboardType: inputType,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                prefixIcon: enablePrifix == true
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                        child: Text(
                          '+971',
                          style: FontStyles().randomTextStylePoppins(
                              color: ColorManager().kBlack,
                              size: 16,
                              weight: FontWeight.w400),
                        ),
                      )
                    : null,
                hintText: doc ?? 'Please enter $hintText',
                hintStyle: hintStyle ??
                    FontStyles().randomTextStylePoppins(
                        color: ColorManager().kBlackSecondary,
                        size: 14,
                        weight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          kHeight10,
        ],
      ),
    );
  }
}
