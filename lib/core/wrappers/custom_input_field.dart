import '../../../core/exported_files/exported_file.dart';

class CustomInputField extends StatelessWidget {
  final String? headerTitle;
  final String? hintText;
  final String? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isObscureText;
  final int? maxLines;
  final int? maxLength;
  final bool optionalInputField;
  final Color? fillColor;
  final Color? textColor;
  final bool isDatePicker; // 📌 Date Picker Enable
  final bool isTimePicker; // ⏰ Time Picker Enable (new)
  final double borderRadius;
  final bool hasBorder;
  final bool readOnly;
  final bool isShadow;
  final String? labelText;
  final TextInputType? keyboardType;

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomInputField({
    super.key,
    this.headerTitle,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    required this.controller,
    this.validator,
    this.isObscureText,
    this.maxLines,
    this.optionalInputField = false,
    this.fillColor = AppColors.white,
    this.isDatePicker = false,
    this.isTimePicker = false, // NEW
    this.borderRadius = 8,
    this.maxLength,
    this.hasBorder = false,
    this.readOnly = false,
    this.isShadow = false,
    this.textColor = AppColors.black,
    this.keyboardType,

    // 🆕 DatePicker config (nullable)
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// -------- Header Title --------
        Row(
          children: [
            if (headerTitle != null)
              ResponsiveText(
                text: headerTitle!,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            if (optionalInputField) ...[
              const ResponsiveSpace(8),
              ResponsiveText(
                text: "(Optional)",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ],
          ],
        ),

        const ResponsiveSpace(8),

        /// -------- Input Box --------
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();

            /// 📌 DATE PICKER
            if (isDatePicker) {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.mainColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                controller.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              }
            }
            /// ⏰ TIME PICKER
            else if (isTimePicker) {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                controller.text = pickedTime.format(context);
              }
            }
          },
          child: AbsorbPointer(
            absorbing: isDatePicker || isTimePicker,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(borderRadius),

                /// shadow if enabled
                boxShadow: isShadow
                    ? [
                        BoxShadow(
                          color: AppColors.mainColor.withValues(alpha: .08),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,

                border: hasBorder
                    ? Border.all(
                        color: AppColors.mainColor.withValues(alpha: .2),
                        width: 1,
                      )
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),

              child: ResponsiveInputField(
                isReadOnly: readOnly,
                borderRadius: borderRadius,
                fillColor: Colors.white,
                borderWidth: 1.3,
                borderColor: AppColors.mainColor,
                focusedBorderColor: AppColors.mainColor,
                labelStyle: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                // fixed icon problem
                prefixIcon: prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ResponsiveImage(path: prefixIcon!, size: 16),
                      )
                    : null,
                hintText: hintText?.tr,
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey.shade700)
                    : null,
                labelText: labelText,
                controller: controller,
                validator: validator,
                obscureText: isObscureText ?? false,
                maxLines: maxLines ?? 1,
                maxLength: maxLength,
                keyboardType: keyboardType,
              ),
            ),
          ),
        ),

        const ResponsiveSpace(12),
      ],
    );
  }
}
