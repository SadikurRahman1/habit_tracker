// import '../../../../../../core/exported_files/exported_file.dart';
//
// class ResponsiveDropdown extends StatelessWidget {
//   const ResponsiveDropdown({
//     super.key,
//     required this.headerTitle,
//     this.prefixIcon,
//     this.suffixIcon,
//     required this.hintText,
//     required this.controller,
//     this.validator,
//     this.isObscureText,
//     this.maxLines,
//     this.optionalInputField = false,
//     this.fillColor,
//     this.isDatePicker = false,
//     this.isDropdown = false,
//     this.dropdownItems,
//     this.selectedValueNotifier,
//     this.borderColor,
//     this.textColor = AppColors.primaryText, // ✅ Added
//   });
//
//   final String headerTitle;
//   final String hintText;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//   final bool? isObscureText;
//   final int? maxLines;
//   final bool optionalInputField;
//   final Color? fillColor;
//   final Color? textColor;
//   final bool isDatePicker;
//
//   final bool isDropdown;
//   final List<String>? dropdownItems;
//   final ValueNotifier<String?>? selectedValueNotifier;
//
//   final Color? borderColor; // ✅ Nullable borderColor
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ResponsiveText(
//               text: headerTitle,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//             if (optionalInputField)
//               Row(
//                 children: [
//                   ResponsiveSpace(8.w),
//                   ResponsiveText(
//                     text: "(Optional)",
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.white,
//                   ),
//                 ],
//               ),
//           ],
//         ),
//         ResponsiveSpace(8.h),
//
//         // ---------------------- DROPDOWN ------------------------
//         if (isDropdown &&
//             dropdownItems != null &&
//             selectedValueNotifier != null)
//           ValueListenableBuilder<String?>(
//             valueListenable: selectedValueNotifier!,
//             builder: (context, selectedValue, _) {
//               return Container(
//                 // margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4.h),
//                 // child: DropdownButtonFormField<String>(
//                 //   dropdownColor: AppColors.white,
//                 //   menuMaxHeight: 300.h,
//                 //   initialValue: selectedValue,
//                 //   decoration: InputDecoration(
//                 //     contentPadding: EdgeInsets.symmetric(
//                 //       vertical: 16.h,
//                 //       horizontal: 12.w,
//                 //     ),
//                 //     border: _buildOutlineInputBorder(),
//                 //     enabledBorder: _buildOutlineInputBorder(),
//                 //     focusedBorder: _buildOutlineInputBorder(),
//                 //     errorBorder: _buildOutlineInputBorder(),
//                 //     focusedErrorBorder: _buildOutlineInputBorder(),
//                 //     filled: true,
//                 //     fillColor: fillColor ?? const Color(0xFFE5D4BE),
//                 //   ),
//                 //   icon: Icon(
//                 //     Icons.keyboard_arrow_down_rounded,
//                 //     color: const Color(0xFF6B6B6B),
//                 //     size: 24.w,
//                 //   ),
//                 //   hint: ResponsiveText(
//                 //     text: hintText,
//                 //     fontSize: 14.sp,
//                 //     color: const Color(0xFF6B6B6B),
//                 //   ),
//                 //   items: dropdownItems!
//                 //       .map(
//                 //         (item) => DropdownMenuItem<String>(
//                 //           value: item,
//                 //           child: ResponsiveText(
//                 //             text: item,
//                 //             fontSize: 14.sp,
//                 //             color: const Color(0xFF6B6B6B),
//                 //           ),
//                 //         ),
//                 //       )
//                 //       .toList(),
//                 //   onChanged: (val) {
//                 //     selectedValueNotifier!.value = val;
//                 //     controller.text = val ?? "";
//                 //   },
//                 // ),
//                 child: DropdownButtonFormField<String>(
//                   menuMaxHeight: 300.h,
//                   initialValue: selectedValue,
//                   decoration: InputDecoration(
//                     contentPadding:
//                     EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
//                     border: _buildOutlineInputBorder(),
//                     enabledBorder: _buildOutlineInputBorder(),
//                     focusedBorder: _buildOutlineInputBorder(),
//                     filled: true,
//                     fillColor: fillColor ?? const Color(0xFFE5D4BE),
//                   ),
//                   icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24.w),
//                   hint: Text(
//                     hintText,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   selectedItemBuilder: (context) {
//                     return dropdownItems!.map((item) {
//                       return Text(
//                         item,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       );
//                     }).toList();
//                   },
//                   items: dropdownItems!.map((item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: Text(
//                           item,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (val) {
//                     selectedValueNotifier!.value = val;
//                     controller.text = val ?? "";
//                   },
//                 ),
//
//               );
//             },
//           )
//         // ---------------------- TEXTFIELD + DATE_PICKER ------------------------
//         else
//           GestureDetector(
//             onTap: isDatePicker
//                 ? () async {
//                     FocusScope.of(context).unfocus();
//                     final DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime(2000),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (pickedDate != null) {
//                       controller.text =
//                           "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                     }
//                   }
//                 : null,
//             child: AbsorbPointer(
//               absorbing: isDatePicker,
//               child: ResponsiveInputField(
//                 fillColor: fillColor ?? const Color(0xFFE5D4BE),
//                 borderColor: borderColor ?? const Color(0xFFB3A28A),
//                 // ✅ updated
//                 borderWidth: 1.w,
//                 prefixIcon: prefixIcon != null
//                     ? Icon(
//                         prefixIcon,
//                         color: const Color(0xFF6B6B6B),
//                         size: 24.w,
//                       )
//                     : null,
//                 hintText: hintText,
//                 suffixIcon: suffixIcon != null
//                     ? Icon(
//                         suffixIcon,
//                         color: const Color(0xFF6B6B6B),
//                         size: 24.w,
//                       )
//                     : null,
//                 controller: controller,
//                 validator: validator,
//                 obscureText: isObscureText ?? false,
//                 maxLines: maxLines,
//               ),
//             ),
//           ),
//
//         ResponsiveSpace(16.h),
//       ],
//     );
//   }
//
//   // ---------------------- BORDER STYLE ------------------------
//   OutlineInputBorder _buildOutlineInputBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8.w),
//       borderSide: BorderSide(
//         color: borderColor ?? const Color(0xFFB3A28A), // ⭐ nullable handled
//         width: 1.w,
//       ),
//     );
//   }
// }

import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveDropdown extends StatelessWidget {
  const ResponsiveDropdown({
    super.key,
    required this.headerTitle,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isObscureText,
    this.maxLines,
    this.optionalInputField = false,
    this.fillColor,
    this.isDatePicker = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedValueNotifier,
    this.borderColor,
    this.textColor = AppColors.primaryText,
  });

  final String headerTitle;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isObscureText;
  final int? maxLines;
  final bool optionalInputField;
  final Color? fillColor;
  final Color? textColor;
  final bool isDatePicker;

  final bool isDropdown;
  final List<String>? dropdownItems;
  final ValueNotifier<String?>? selectedValueNotifier;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- HEADER ----------------
        Row(
          children: [
            Expanded(
              child: ResponsiveText(
                text: headerTitle,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (optionalInputField) ...[
              ResponsiveSpace(8.w),
              ResponsiveText(
                text: "(Optional)",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ],
          ],
        ),

        ResponsiveSpace(8.h),

        // ---------------- DROPDOWN ----------------
        if (isDropdown &&
            dropdownItems != null &&
            selectedValueNotifier != null)
          ValueListenableBuilder<String?>(
            valueListenable: selectedValueNotifier!,
            builder: (context, selectedValue, _) {
              return DropdownButtonFormField<String>(
                isExpanded: true, // 🔥 MOST IMPORTANT
                menuMaxHeight: 300.h,
                value: selectedValue,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
                  border: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  focusedBorder: _buildOutlineInputBorder(),
                  errorBorder: _buildOutlineInputBorder(),
                  focusedErrorBorder: _buildOutlineInputBorder(),
                  filled: true,
                  fillColor: fillColor ?? const Color(0xFFE5D4BE),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24.w,
                  color: const Color(0xFF6B6B6B),
                ),
                hint: Text(
                  hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                selectedItemBuilder: (context) {
                  return dropdownItems!.map((item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B6B6B),
                        ),
                      ),
                    );
                  }).toList();
                },
                items: dropdownItems!.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  selectedValueNotifier!.value = val;
                  controller.text = val ?? "";
                },
              );
            },
          )

        // ---------------- TEXTFIELD / DATE PICKER ----------------
        else
          GestureDetector(
            onTap: isDatePicker
                ? () async {
              FocusScope.of(context).unfocus();
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                controller.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              }
            }
                : null,
            child: AbsorbPointer(
              absorbing: isDatePicker,
              child: ResponsiveInputField(
                fillColor: fillColor ?? const Color(0xFFE5D4BE),
                borderColor: borderColor ?? const Color(0xFFB3A28A),
                borderWidth: 1.w,
                prefixIcon: prefixIcon != null
                    ? Icon(
                  prefixIcon,
                  color: const Color(0xFF6B6B6B),
                  size: 24.w,
                )
                    : null,
                hintText: hintText,
                suffixIcon: suffixIcon != null
                    ? Icon(
                  suffixIcon,
                  color: const Color(0xFF6B6B6B),
                  size: 24.w,
                )
                    : null,
                controller: controller,
                validator: validator,
                obscureText: isObscureText ?? false,
                maxLines: maxLines,
              ),
            ),
          ),

        ResponsiveSpace(16.h),
      ],
    );
  }

  // ---------------- BORDER ----------------
  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.w),
      borderSide: BorderSide(
        color: borderColor ?? const Color(0xFFB3A28A),
        width: 1.w,
      ),
    );
  }
}
