import '../../../../../../../core/exported_files/exported_file.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: CommonBody(
        widget: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  child: ResponsiveText(
                    text: 'Skip',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = controller.onboardingPages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveImage(
                        path: page.image,
                        fit: BoxFit.contain,
                        size: 250,
                      ),
                      const SizedBox(height: 40),
                      ResponsiveText(
                        text: page.title,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: ResponsiveText(
                          text: page.description,
                          color: Colors.white70,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Page indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingPages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: controller.currentPage.value == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? Colors.white
                          : Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(
                () => ResponsiveButton(
                  onTap: controller.nextPage,
                  title: controller.currentPage.value ==
                          controller.onboardingPages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  backgroundColor: Colors.white,
                  titleColor: AppColors.mainColor,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


