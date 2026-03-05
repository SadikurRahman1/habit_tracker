import '../../../../../../core/exported_files/exported_file.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResponsiveText(
            text: title,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),

          ResponsiveSpace(8),

          ResponsiveText(
            text: subTitle,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.gray,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
