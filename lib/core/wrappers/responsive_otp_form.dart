import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveOtpForm extends StatelessWidget {
  const ResponsiveOtpForm({
    super.key,
    required this.otpController,
    this.length = 4,
    this.fieldWidth,
    this.fieldHeight,
    this.borderRadius,
    this.spaceBetween,
    this.activeColor,
    this.inactiveColor,
    this.selectedColor,
    this.fillColor,
    this.selectedFillColor,
    this.activeFillColor,
    this.inactiveFillColor,
    this.backgroundColor,
    this.onCompleted,
    this.validator,
    this.keyboardType = TextInputType.number,
    this.autoDisposeControllers = false,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController otpController;
  final int length;
  final double? fieldWidth;
  final double? fieldHeight;
  final double? borderRadius;
  final double? spaceBetween;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? selectedColor;
  final Color? fillColor;
  final Color? selectedFillColor;
  final Color? activeFillColor;
  final Color? inactiveFillColor;
  final Color? backgroundColor;
  final Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool autoDisposeControllers;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    // ---------- Default Values ----------
    final double defaultFieldWidth = fieldWidth ?? 55;
    final double defaultFieldHeight = fieldHeight ?? 55;
    final double defaultRadius = borderRadius ?? 16;
    final double defaultSpace = spaceBetween ?? 24;

    return SizedBox(
      width: ((defaultFieldWidth + defaultSpace) * length).w, // 🔥 responsive
      child: PinCodeTextField(
        autoDisposeControllers: autoDisposeControllers,
        length: length,
        obscureText: false,
        animationType: AnimationType.fade,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: otpController,
        appContext: context,
        onCompleted: onCompleted,
        validator: validator,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: backgroundColor ?? Colors.transparent,
        enableActiveFill: true,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: defaultFieldHeight.h,
          fieldWidth: defaultFieldWidth.w,
          borderRadius: BorderRadius.circular(defaultRadius.w),
          activeColor: activeColor ?? const Color(0xFFFFFFFF),
          inactiveColor: inactiveColor ?? const Color(0xFFDFDFDF),
          selectedColor: selectedColor ?? AppColors.primary,
          activeFillColor: activeFillColor ?? Colors.transparent,
          inactiveFillColor: inactiveFillColor ?? Colors.transparent,
          selectedFillColor: selectedFillColor ?? const Color(0xFFFFFFFF),
        ),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
