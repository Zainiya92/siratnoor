import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstname,
                  validator: (value) =>
                      TValidator.validateOnlyLetters('First Name', value),
                  expands: false,
                  decoration: InputDecoration(
                    labelText: TTexts.firstName,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    prefixIcon: const Icon(Iconsax.user),
                    errorStyle: const TextStyle(
                      fontSize: 12, // smaller font size for error text
                      color: Colors.red, // default error color
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwInputFields,
              ),
              Expanded(
                child: TextFormField(
                  expands: false,
                  controller: controller.lastname,
                  validator: (value) =>
                      TValidator.validateOnlyLetters('Last Name', value),
                  decoration: InputDecoration(
                    labelText: TTexts.lastName,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    prefixIcon: const Icon(
                      Iconsax.user,
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 12, // smaller font size for error text
                      color: Colors.red, // default error color
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          // Add this inside the Column children, maybe after Phone Number field:

          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gender:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8), // space between title and radios
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: controller.gender.value,
                        onChanged: (value) => controller.gender.value = value!,
                      ),
                      const Text("Male"),
                      Radio<String>(
                        value: 'Female',
                        groupValue: controller.gender.value,
                        onChanged: (value) => controller.gender.value = value!,
                      ),
                      const Text("Female"),
                    ],
                  ),
                ],
              )),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            expands: false,
            controller: controller.username,
            validator: (value) =>
                TValidator.validateOnlyLetters('User Name', value),
            decoration: InputDecoration(
              labelText: TTexts.username,
              labelStyle: Theme.of(context).textTheme.labelSmall,
              prefixIcon: const Icon(Iconsax.user_edit),
              errorStyle: const TextStyle(
                fontSize: 12, // smaller font size for error text
                color: Colors.red, // default error color
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          // Email
          TextFormField(
            expands: false,
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: InputDecoration(
              labelText: TTexts.email,
              labelStyle: Theme.of(context).textTheme.labelSmall,
              prefixIcon: const Icon(Iconsax.direct),
              errorStyle: const TextStyle(
                fontSize: 12, // smaller font size for error text
                color: Colors.red, // default error color
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          // Phone Number
          TextFormField(
            expands: false,
            controller: controller.phonenumber,
            validator: (value) =>
                TValidator.validatePhoneNumberStartsWithZero(value),
            decoration: InputDecoration(
              labelText: TTexts.phoneNo,
              labelStyle: Theme.of(context).textTheme.labelSmall,
              prefixIcon: const Icon(Iconsax.call),
              errorStyle: const TextStyle(
                fontSize: 12, // smaller font size for error text
                color: Colors.red, // default error color
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          // Add this inside the Column children, maybe after Gender:

          Obx(() => DropdownButtonFormField<String>(
                value: controller.religion.value.isEmpty
                    ? null
                    : controller.religion.value,
                items: const [
                  DropdownMenuItem(value: "Sunni", child: Text("Sunni")),
                  DropdownMenuItem(value: "Shia", child: Text("Shia")),
                  DropdownMenuItem(value: "Wahhabi", child: Text("Wahhabi")),
                ],
                decoration: InputDecoration(
                  labelText: "Firqa",
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  prefixIcon: const Icon(Iconsax.book),
                  errorStyle: const TextStyle(
                    fontSize: 12, // smaller font size for error text
                    color: Colors.red, // default error color
                  ),
                ),
                onChanged: (value) {
                  controller.religion.value = value ?? '';
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select your religion'
                    : null,
              )),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password
          Obx(
            () => TextFormField(
              expands: false,
              controller: controller.password,
              obscureText: controller.hidepassword.value,
              validator: (value) => TValidator.validatePassword(value),
              decoration: InputDecoration(
                labelText: TTexts.password,
                labelStyle: Theme.of(context).textTheme.labelSmall,
                prefixIcon: const Icon(Iconsax.password_check),
                errorStyle: const TextStyle(
                  fontSize: 12, // smaller font size for error text
                  color: Colors.red, // default error color
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidepassword.value =
                      !controller.hidepassword.value,
                  icon: Icon(
                    controller.hidepassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          // Term & Condition checkbox
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Obx(
                  () => Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) => controller.privacyPolicy.value =
                        !controller.privacyPolicy.value,
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwItem,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: TTexts.iAgreeTo,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextSpan(
                      text: TTexts.privacyPolicy,
                      style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: TTexts.and,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextSpan(
                      text: TTexts.termsOfUse,
                      style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // SignUp Button
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
