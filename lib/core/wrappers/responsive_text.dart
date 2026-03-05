import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/exported_files/exported_file.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final double? height;
  final VoidCallback? onTap;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? backgroundColor;
  final List<Shadow>? shadows;
  final double? wordSpacing;

  const ResponsiveText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.height,
    this.onTap,
    this.fontStyle,
    this.decoration,
    this.backgroundColor,
    this.shadows,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text.tr,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontStyle: fontStyle,
        fontSize: fontSize.sp, // 🔥 Super Responsive
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        letterSpacing: letterSpacing?.sp,
        height: height,
        decoration: decoration,
        backgroundColor: backgroundColor,
        shadows: shadows,
        wordSpacing: wordSpacing?.sp,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
