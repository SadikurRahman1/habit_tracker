import '../../../../../../../core/exported_files/exported_file.dart';
import '../../../../../core/wrappers/custom_input_field.dart';
import '../../../../../core/wrappers/responsive_checkbox.dart';
import '../../../common/widget/auth_header.dart';
import '../controllers/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegistrationController>();
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CommonBody(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              const ResponsiveSpace(70),
              SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: ResponsiveImage(
                    path: ImagePath.logo2,
                    size: mediaQuery.width * 0.3,
                  ),
                ),
              ),
              const ResponsiveSpace(30),
              AuthHeader(
                title:  " Create Account",
                subTitle: 'Sign up to get started',
              ),
              const ResponsiveSpace(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  CustomInputField(
                    labelText: 'Full name',
                    controller: controller.nameController,
                  ),

                  // Email Field
                  CustomInputField(
                    labelText: 'Email',
                    controller: controller.emailController,
                  ),

                  // Password Field
                  CustomInputField(
                    labelText: 'Password',
                    controller: controller.passwordController,
                    isObscureText: true,
                  ),

                  // Confirm Password Field
                  CustomInputField(
                    labelText: 'Confirm password',
                    controller: controller.confirmPasswordController,
                    isObscureText: true,
                  ),

                  // ResponsiveInputField(
                  //   labelText: 'Email',
                  //   borderColor: AppColors.mainColor,
                  //   focusedBorderColor: AppColors.mainColor,
                  //   controller: controller.emailController,
                  //   keyboardType: TextInputType.phone,
                  //
                  // ),

                  const ResponsiveSpace(8),

                  // Terms & Conditions
                  // Row(
                  //   children: [
                  //     Obx(
                  //       () => ResponsiveCheckbox(
                  //         checkColor: AppColors.white,
                  //         activeColor: AppColors.mainColor,
                  //         value: controller.agreeToTerms.value,
                  //         onChanged: controller.agreeToTermsChanged,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     // Expanded(
                  //     //   child: Row(
                  //     //     children: [
                  //     //       ResponsiveText(
                  //     //         text: 'I agree to',
                  //     //         fontSize: 14,
                  //     //         fontWeight: FontWeight.w400,
                  //     //         color: AppColors.gray,
                  //     //       ),
                  //     //       const SizedBox(width: 4),
                  //     //       ResponsiveText(
                  //     //         text: 'Trerms conditions',
                  //     //         fontSize: 14,
                  //     //         fontWeight: FontWeight.w600,
                  //     //         color: AppColors.mainColor,
                  //     //       ),
                  //     //     ],
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),

                  const ResponsiveSpace(40),

                  // Register Button
                  Obx(() {
                    return controller.isLoading.value
                        ? const Center(child: CircleLoader())
                        : ResponsiveButton(
                            title: 'Register',
                            onTap: () => controller.registerUser(),
                            width: double.infinity,
                            height: 50,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          );
                  }),

                  const ResponsiveSpace(20),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveText(
                        text: 'Already have Account',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.gray,
                      ),
                      GestureDetector(
                        onTap: () => controller.gotoLoginScreen(),
                        child: ResponsiveText(
                          text: ' Log In',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),

                  const ResponsiveSpace(30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
