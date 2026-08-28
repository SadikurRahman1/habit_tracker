import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateService {
  InAppUpdateService._();

  static bool _isChecking = false;

  static Future<void> checkForUpdate() async {
    if (_isChecking || !GetPlatform.isAndroid) return;

    _isChecking = true;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }

      if (updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (error) {
      debugPrint('In-app update check skipped: $error');
    } finally {
      _isChecking = false;
    }
  }
}
