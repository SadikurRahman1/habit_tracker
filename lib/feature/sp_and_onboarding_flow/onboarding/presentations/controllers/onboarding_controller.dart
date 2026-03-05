import '../../../../../../../core/exported_files/exported_file.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Welcome to Message',
      description: 'Connect with your friends and family instantly',
      image: "",
    ),
    OnboardingModel(
      title: 'Stay Connected',
      description: 'Send messages, photos, and videos to anyone, anywhere',
      image: "",
    ),
    OnboardingModel(
      title: 'Get Started',
      description: 'Start your journey with us today',
      image: "",
    ),
  ];

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    STService().saveData(AuthConstants.onboardingCompletedKey, 'true');
    Get.offAllNamed(AppRoutes.mainBottomNavScreen);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

