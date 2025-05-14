import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirat_noor/features/personalization/screens/profile/widget/re_authenticate_user_login_form.dart';

import '../../../repositories/authentication/authentication_repository.dart';
import '../../../repositories/user/user_repoistory.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/models/user_model.dart';
import '../../authentication/screens/login/login.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileloading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEnail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }
  // Fetch User Details

  // Fetch User Details
  Future<void> fetchUserRecord() async {
    try {
      profileloading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user); // This will trigger the reactive update
      profileloading.value = false;
    } catch (e) {
      user(UserModel.empty()); // Set user to empty if there's an error
    } finally {
      profileloading.value = false;
    }
  }

  // Save user Record from any Registration Provider
  Future<void> saveuserRecord(UserCredential? userCredentials) async {
    try {
      // Refreah User Record
      await fetchUserRecord();

      // if no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First Name and Last Name
          final namePasrts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(
              id: userCredentials.user!.uid,
              firstname: namePasrts[0],
              lastname:
                  namePasrts.length > 1 ? namePasrts.sublist(1).join('') : '',
              username: username,
              email: userCredentials.user!.email ?? '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '',
              gender: 'Male',
              religion: 'Sunni');

          // Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not Saved',
          message:
              'Something went wrong while saving your information. You can re-save your data in your profile');
    }
  }

  // Delete Account Warnings
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you Sure you went to delete account permanently? This action is not reversible and all of your data will be removed permanently',
      confirm: ElevatedButton(
        onPressed: () => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            side: const BorderSide(color: TColors.primary)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  // Delete User Account
  void deleteUserAccount() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialogue(
        'Processing...',
        TImages.docerAnimation,
      );

      // First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider.isNotEmpty) {
          // Re Verify Auth Email
          if (provider == 'google.com') {
            await auth.signinWithGoogle();
            await auth.deleteAccount();
            TFullScreenLoader.stopLoading();
            Get.offAll(() => const LoginScreen());
          } else if (provider == 'password') {
            TFullScreenLoader.stopLoading();
            Get.to(() => const ReAuthLoginForm());
          }
        }
      }
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Re- Authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialogue(
        'Processing...',
        TImages.docerAnimation,
      );

      // check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!reAuthFormKey.currentState!.validate()) {
        // Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //
      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEnail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(const LoginScreen());
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Uploading Profile Picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (image != null) {
        imageUploading.value = true;
        // Upload
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);
        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Image has been updated!');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Opps!', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}
