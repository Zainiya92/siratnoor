import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../admin/admin_home.dart';
import '../admin/admin_login_screen.dart';
import 'widgets/login_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: TSpacingStyle.paddingWithAppBarHeight,
              child: Column(
                children: [
                  // Logo , Title , Sub Title
                  LoginHeader(dark: dark),

                  // Form
                  const LoginForm(),

                  // Divider
                  TFormDivider(
                    dark: dark,
                    dividerText: TTexts.orSignInWith,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItem,
                  ),

                  // Footer
                  const TSocialButtons(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Glow.png',
                height: 250,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/Glow.png',
                height: 250,
              ),
            ),

            // **New: Admin Login Button at top right corner**
            Positioned(
              top: 40, // some padding from top
              right: 20, // some padding from right
              child: TextButton(
                onPressed: () {
                  final GetStorage storage = GetStorage();
                  if (storage.read('isAdminLoggedIn') == true) {
                    Get.offAll(() => AdminHomeScreen());
                  } else {
                    Get.to(AdminLoginScreen());
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: dark ? Colors.white24 : Colors.black12,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Admin Login",
                  style: TextStyle(
                    color: dark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
