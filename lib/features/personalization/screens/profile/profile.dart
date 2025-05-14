import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar.dart/appbar.dart';
import '../../../../common/widgets/image/t_circular_image.dart';
import '../../../../common/widgets/text/section_heading.dart';
import '../../../../repositories/user/user_repoistory.dart';
import '../../../../utils/constants/colors.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../controller/home_controller.dart';
import '../../controllers/user_controller.dart';
import 'widget/change_name.dart';
import 'widget/profile_menu.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: TAppBar(
        bg: TColors.primary,
        showBackArrow: true,
        title: Text(
          languageController.isEnglish.value ? 'Profile' : 'پروفائل',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: TColors.white),
        ),
      ),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture Section
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : TImages.user;
                      return controller.imageUploading.value
                          ? CircularProgressIndicator()
                          : TCircularimage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetwork: networkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () {
                        controller.uploadUserProfilePicture();
                      },
                      child: Text(languageController.isEnglish.value
                          ? 'Change Profile Picture'
                          : 'پروفائل کی تصویر تبدیل کریں'),
                    ),
                  ],
                ),
              ),

              // Details Section
              const SizedBox(
                height: TSizes.spaceBtwItem / 2,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),
              // Heading Information: Profile Information
              SectionHeading(
                title: languageController.isEnglish.value
                    ? 'Profile Information'
                    : 'پروفائل کی معلومات',
                showActionButton: false,
              ),

              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),

              ProfileMenu(
                ontap: () {
                  Get.to(const ChangeName());
                },
                title: languageController.isEnglish.value ? 'Name' : 'نام',
                value: controller.user.value.fullname,
                icon: Iconsax.arrow_right_34,
              ),
              ProfileMenu(
                ontap: () {},
                title: languageController.isEnglish.value
                    ? 'Username'
                    : 'صارف کا نام',
                value: controller.user.value.username,
              ),

              ProfileMenu(
                ontap: () {},
                title: languageController.isEnglish.value ? 'Gender' : 'جنس',
                value: controller.user.value.gender.isEmpty
                    ? (languageController.isEnglish.value
                        ? 'Select Gender'
                        : 'جنس منتخب کریں')
                    : controller.user.value.gender,
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.user.value.gender.isEmpty
                        ? null
                        : controller.user.value.gender,
                    items: [
                      DropdownMenuItem(
                          value: "Male",
                          child: Text(languageController.isEnglish.value
                              ? "Male"
                              : "مرد")),
                      DropdownMenuItem(
                          value: "Female",
                          child: Text(languageController.isEnglish.value
                              ? "Female"
                              : "خواتین")),
                      DropdownMenuItem(
                          value: "Other",
                          child: Text(languageController.isEnglish.value
                              ? "Other"
                              : "دیگر")),
                    ],
                    decoration: InputDecoration(
                      labelText: languageController.isEnglish.value
                          ? "Select Gender"
                          : "جنس منتخب کریں",
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        controller.user.value.gender = value;
                        UserRepository.instance
                            .updateSingleField({'Gender': value});
                        // Show Snackbar after success
                        Get.snackbar(
                          languageController.isEnglish.value
                              ? "Success"
                              : "کامیابی",
                          languageController.isEnglish.value
                              ? "Profile Updated Successfully"
                              : "پروفائل کامیابی سے اپ ڈیٹ ہوگیا",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.7),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                  );
                }),
              ),

              ProfileMenu(
                ontap: () {},
                title: languageController.isEnglish.value ? 'Religion' : 'مذہب',
                value: controller.user.value.religion.isEmpty
                    ? (languageController.isEnglish.value
                        ? 'Select Religion'
                        : 'مذہب منتخب کریں')
                    : controller.user.value.religion,
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.user.value.religion.isEmpty
                        ? null
                        : controller.user.value.religion,
                    items: const [
                      DropdownMenuItem(value: "Sunni", child: Text("Sunni")),
                      DropdownMenuItem(value: "Shia", child: Text("Shia")),
                      DropdownMenuItem(
                          value: "Wahhabi", child: Text("Wahhabi")),
                    ],
                    decoration: InputDecoration(
                      labelText: languageController.isEnglish.value
                          ? "Select Religion"
                          : "مذہب منتخب کریں",
                      prefixIcon: Icon(Icons.book),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        controller.user.value.religion = value;
                        UserRepository.instance
                            .updateSingleField({'Religion': value});
                        // Show Snackbar after success
                        Get.snackbar(
                          languageController.isEnglish.value
                              ? "Success"
                              : "کامیابی",
                          languageController.isEnglish.value
                              ? "Profile Updated Successfully"
                              : "پروفائل کامیابی سے اپ ڈیٹ ہوگیا",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.7),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                  );
                }),
              ),

              // Personal Information Section
              const SizedBox(
                height: TSizes.spaceBtwItem / 2,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),
              // Heading Information: Personal Information
              SectionHeading(
                title: languageController.isEnglish.value
                    ? 'Personal Information'
                    : 'ذاتی معلومات',
                showActionButton: false,
              ),

              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),
              ProfileMenu(
                  ontap: () {},
                  title: languageController.isEnglish.value
                      ? 'User ID'
                      : 'یوزر آئی ڈی',
                  icon: Iconsax.copy,
                  value: controller.user.value.id),
              ProfileMenu(
                  ontap: () {},
                  title:
                      languageController.isEnglish.value ? 'E-Mail' : 'ای میل',
                  value: controller.user.value.email),
              ProfileMenu(
                  ontap: () {},
                  title: languageController.isEnglish.value
                      ? 'Phone No'
                      : 'فون نمبر',
                  value: controller.user.value.phoneNumber),

              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.deleteAccountWarningPopup();
                  },
                  child: Text(
                    languageController.isEnglish.value
                        ? 'Close Account'
                        : 'اکاؤنٹ بند کریں',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
