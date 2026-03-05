

import '../exported_files/exported_file.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
    this.message,
    this.imageHeight,
    this.gap1,
    this.gap2,
    this.gap3,
  });
  final String? message;
  final double? imageHeight, gap1, gap2, gap3;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: gap1),
        Image.asset(ImagePath.noData, height: imageHeight ?? 200),
        ResponsiveSpace(gap2 ?? 10),
        ResponsiveText(text: message ?? "no_data_found",fontWeight: FontWeight.w700,
          color: AppColors.mainColor,
          textAlign: TextAlign.center,)
      ],
    );
  }
}
