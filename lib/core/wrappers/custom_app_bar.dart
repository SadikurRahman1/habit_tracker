import '../../../../core/exported_files/exported_file.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: bottom!,
            )
          : null,
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      backgroundColor: backgroundColor,
      elevation: elevation,
      systemOverlayStyle: SystemUiOverlayStyle(
        // statusBarColor: AppColors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),

      // setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: brightness == Brightness.dark ? Colors.black : AppColors.primary400,
      //   // statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      // ));
      //
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: ResponsiveImage(path: IconsPath.arrowLeft, size: 32),
                onPressed: onBackPressed ?? () => Get.back(),
              ),
            )
          : null,
      title: ResponsiveText(
        text: title ?? "",
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
