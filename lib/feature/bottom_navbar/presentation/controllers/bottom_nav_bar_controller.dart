import '../../../../../../../core/exported_files/exported_file.dart';

class BottomNavBarController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void onTabChanged(int index) {
    selectedIndex.value = index;
  }

  void navigateToChat() {
    selectedIndex.value = 0;
    // Navigate to chat/messages screen
  }

  void navigateToContacts() {
    selectedIndex.value = 1;
    // Navigate to contacts/users screen
  }

  void navigateToProfile() {
    selectedIndex.value = 2;
    // Navigate to profile screen
  }
}

