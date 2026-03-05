import '../../../../../../../core/exported_files/exported_file.dart';
import '../../../../../core/wrappers/custom_input_field.dart';
import '../../../../../core/wrappers/responsive_checkbox.dart';
import '../../../common/widget/auth_header.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
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
                title: 'Welcome Back',
                subTitle: 'Sign in to your account',
              ),
              const ResponsiveSpace(30),
              SingleChildScrollView(
                physics: PageScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputField(
                      labelText: 'Email',
                      controller: controller.emailController,
                    ),

                    // ResponsiveSpace(8),
                    CustomInputField(
                      labelText: 'Password',
                      controller: controller.passwordController,
                      isObscureText: true,
                    ),

                    ResponsiveSpace(8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => ResponsiveCheckbox(
                                checkColor: AppColors.white,
                                activeColor: AppColors.mainColor,
                                value: controller.rememberMe.value,
                                onChanged: controller.rememberMeChanged,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ResponsiveText(
                              text: 'Remember Me'.tr,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainColor,
                            ),
                          ],
                        ),
                        // GestureDetector(
                        //   onTap: () => controller.gotoForgotPasswordScreen(),
                        //   child: ResponsiveText(
                        //     text: 'forgot_password'.tr,
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w500,
                        //     color: AppColors.mainColor,
                        //   ),
                        // ),
                      ],
                    ),

                    const ResponsiveSpace(40),
                    Obx(() {
                      return controller.isLoading.value
                          ? const Center(child: CircleLoader())
                          : ResponsiveButton(
                              title: 'Login',
                              onTap: () => controller.loginUser(),
                              width: double.infinity,
                              height: 50,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            );
                    }),

                    const ResponsiveSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveText(
                          text: "Don't have Account",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.gray,
                        ),
                        GestureDetector(
                          onTap: () => controller.gotoRegisterScreen(),
                          child: ResponsiveText(
                            text: ' Register',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),

                    const ResponsiveSpace(30),

                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       controller.guestUserLogin();
                    //     },
                    //     child: ResponsiveText(
                    //       text: 'continue_as_guest'.tr,
                    //       color: AppColors.mainColor,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                    // const ResponsiveSpace(30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
