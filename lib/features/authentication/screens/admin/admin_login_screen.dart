import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import 'admin_controller.dart';

class AdminLoginScreen extends StatelessWidget {
  final AdminAuthController controller = Get.put(AdminAuthController());

  AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Login",
            style: GoogleFonts.urbanist(
                fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text("Welcome, Admin",
                style: GoogleFonts.urbanist(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Sign in to continue",
                style: GoogleFonts.urbanist(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              controller.isPasswordVisible.toggle();
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )),
                  const SizedBox(height: 30),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.adminLogin,
                              child: const Text(TTexts.signIn),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
