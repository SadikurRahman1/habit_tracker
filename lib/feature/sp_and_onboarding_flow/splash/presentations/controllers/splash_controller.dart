import 'dart:async';

import 'package:habit/core/services/in_app_update_service.dart';
import '../../../../../../../core/exported_files/exported_file.dart';

class SplashController extends GetxController {
  Future<void> _moveToNext() async {
    await Future.delayed(const Duration(seconds: 1));

    // final String? onboardingCompeted = STService().getData(
    //   AuthConstants.onboardingCompletedKey,
    // );
    final String? onboardingCompeted = null;

    // if (onboardingCompeted != null) {
    //   String? token = STService().getData(AuthConstants.tokenKey);
    //   if (token != null) {
    //     // Get.offAllNamed(AppRoutes.mainBottomNavScreen);
    //   } else {
    //     // Get.offAllNamed(AppRoutes.loginScreen);
    //   }
    // } else {
    Get.offAllNamed(AppRoutes.mainBottomNavScreen);
    // }
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(InAppUpdateService.checkForUpdate());
    _moveToNext();
  }
}
