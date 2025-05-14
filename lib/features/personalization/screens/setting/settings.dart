import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar.dart/appbar.dart';
import '../../../../common/widgets/custom_shape/containers/primary_header_container.dart';
import '../../../../common/widgets/list_title/setting_menu_title.dart';
import '../../../../common/widgets/list_title/user_profile_title.dart';
import '../../../../common/widgets/text/section_heading.dart';
import '../../../../repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../controller/home_controller.dart';
import '../profile/about_screen.dart';
import '../profile/privacy_policy.dart';
import '../profile/profile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Obx(() => Text(
                          languageController.isEnglish.value
                              ? "Account"
                              : "اکاؤنٹ",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white),
                        )),
                  ),
                  // User Profile Card
                  TUserProfileTitle(
                    onpressed: () => Get.to(const UserProfile()),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Obx(
                () => Column(
                  children: [
                    // Account Setting Section
                    SectionHeading(
                      title: languageController.isEnglish.value
                          ? 'Account Setting'
                          : 'اکاؤنٹ کی سیٹنگ',
                      showActionButton: false,
                    ),
                    TSettingMenuTitle(
                      icon: Icons.info, // Using a relevant icon for "About App"
                      title: languageController.isEnglish.value
                          ? 'About App'
                          : 'ایپ کے بارے میں', // "About App" in Urdu
                      subtitle: languageController.isEnglish.value
                          ? 'Learn more about the app and its features'
                          : 'ایپ اور اس کی خصوصیات کے بارے میں مزید جانیں',
                      onpressed: () {
                        Get.to(AboutAppScreen());
                      },
                    ),

                    TSettingMenuTitle(
                      icon: Iconsax.security_card,
                      title: languageController.isEnglish.value
                          ? 'Account Privacy'
                          : 'اکاؤنٹ کی پرائیویسی',
                      subtitle: languageController.isEnglish.value
                          ? 'Manage data usage and connected accounts'
                          : 'ڈیٹا کے استعمال اور جڑے ہوئے اکاؤنٹس کو منظم کریں',
                      onpressed: () {
                        Get.to(PrivacyPolicyScreen());
                      },
                    ),

                    // App Settings Section
                    const SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),
                    SectionHeading(
                      title: languageController.isEnglish.value
                          ? 'App Setting'
                          : 'ایپ کی سیٹنگ',
                      showActionButton: false,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItem,
                    ),
                    TSettingMenuTitle(
                      icon: Iconsax.document_upload,
                      title: languageController.isEnglish.value
                          ? 'Language'
                          : 'زبان',
                      subtitle: languageController.isEnglish.value
                          ? 'Toggle to switch between languages'
                          : 'زبانوں کے درمیان سوئچ کرنے کے لیے ٹوگل کریں',
                      trailing: Obx(() => Switch(
                            value: languageController.isEnglish.value,
                            onChanged: (value) {
                              languageController.toggleLanguage(value);
                            },
                          )),
                    ),
                    // Logout Button
                    const SizedBox(
                      height: TSizes.spaceBtwItem,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: languageController.isEnglish.value
                                ? 'Logout!'
                                : 'لاگ آؤٹ!',
                            middleText: languageController.isEnglish.value
                                ? 'Are you sure you want to logout?'
                                : 'کیا آپ کو لاگ آؤٹ ہونے کا یقین ہے؟',
                            onConfirm: () {
                              AuthenticationRepository.instance.logout();
                            },
                            onCancel: () => Get.back(),
                          );
                        },
                        child: Text(
                          languageController.isEnglish.value
                              ? 'Logout'
                              : 'لاگ آؤٹ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections * 2.5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
