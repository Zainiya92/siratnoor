import 'package:flutter/material.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';
import 'widget/signup_widgets.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const Image(
                    height: 150,
                    width: 200,
                    image: AssetImage(
                      TImages.blacklogo,
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),
                  // Title
                  Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections + 10,
                  ),
                  // Form
                  TSignUpForm(dark: dark),
                  const SizedBox(
                    height: TSizes.spaceBtwItem,
                  ),
                  // Divider
                  // TFormDivider(dark: dark, dividerText: TTexts.orSignUpWith),
                  // const SizedBox(
                  //   height: TSizes.spaceBtwItem,
                  // ),
                  // Social Buttons
                  // const TSocialButtons()
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
          ],
        ),
      ),
    );
  }
}
