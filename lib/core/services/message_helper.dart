import '../exported_files/exported_file.dart';

class MessageHelper {
  static final MessageHelper _instance = MessageHelper._internal();
  MessageHelper._internal();
  factory MessageHelper() => _instance;

  void showWarning({required String title, required String message}) {
    _showSnackBar(
      title: title.tr,
      message: message.tr,
      backgroundColor: AppColors.danger,
      icon: Icons.warning_amber_rounded,
    );
  }

  void showAlert({required String title, required String message}) {
    _showSnackBar(
      title: title.tr,
      message: message.tr,
      backgroundColor: AppColors.mainColor,
      icon: Icons.notifications_active_outlined,
    );
  }

  void showDeleteConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_forever_outlined,
                color: AppColors.danger,
                size: 50.w,
              ),
              ResponsiveSpace(16),
              Text(
                title.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              ResponsiveSpace(8),
              Text(
                message.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              ResponsiveSpace(24),
              Row(
                children: [
                  Expanded(
                    child: ResponsiveButton(
                      title: "Cancel",
                      backgroundColor: AppColors.white,
                      titleColor: AppColors.black,
                      borderColor: AppColors.black.withValues(alpha: 0.1),
                      onTap: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ResponsiveButton(
                      borderColor: Colors.transparent,
                      title: "Delete",
                      backgroundColor: AppColors.danger,
                      onTap: () {
                        Get.back();
                        onConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final context = Get.context;
    if (context == null) return;

    // Use safe screenWidth with fallback to MediaQuery
    final screenWidth = ScreenConfig.screenWidth > 0
      ? ScreenConfig.screenWidth
      : MediaQuery.of(context).size.width;

    /// Responsive padding
    final horizontalPadding = screenWidth * 0.05;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: 20.h,
      ),
      content: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.w),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.35),
              blurRadius: 10.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 26.w, // Responsive icon size
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
