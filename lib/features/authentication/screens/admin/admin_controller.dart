import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sirat_noor/features/authentication/screens/login/login.dart';
import 'admin_home.dart';

class AdminAuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage storage = GetStorage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  Future<void> adminLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required!",
          backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      DocumentSnapshot adminDoc =
          await _firestore.collection("admin").doc("admin_user").get();
      if (!adminDoc.exists) {
        Get.snackbar("Error", "Admin account not found!",
            backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      final adminData = adminDoc.data() as Map<String, dynamic>;
      final storedEmail = adminData['email'];
      final storedPassword =
          adminData['password']; // Should be hashed in production

      if (emailController.text == storedEmail &&
          passwordController.text == storedPassword) {
        storage.write('isAdminLoggedIn', true);
        Get.offAll(() => AdminHomeScreen());
      } else {
        Get.snackbar("Login Failed", "Invalid credentials",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!",
          backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }

  void logout() {
    storage.remove('isAdminLoggedIn');
    Get.offAll(() => LoginScreen());
  }
}
