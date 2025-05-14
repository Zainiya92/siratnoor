import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repositories/authentication/authentication_repository.dart';
import '../../../../repositories/user/user_repoistory.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/user_model.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final hidepassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstname = TextEditingController();
  final phonenumber = TextEditingController();
  var gender = 'Male'.obs;
  var religion = ''.obs;

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Signup
  void signup() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialogue(
        'We are Processing your information...',
        TImages.docerAnimation,
      );

      // check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check

      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create account, you must have to read and accept the Privacy Policy & Terms of use',
        );
        TFullScreenLoader.stopLoading();
        return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firbase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailandPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firbase Firebase
      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstname: firstname.text.trim(),
          lastname: lastname.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phonenumber.text.trim(),
          profilePicture: '',
          gender: gender.value,
          religion: religion.value);

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Sucess Message

      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      // Move to Verify Email screen
      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
