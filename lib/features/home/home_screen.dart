import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';
import '../../common_widget/common_app_bar.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    return Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting Section
              Obx(() => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          languageController.greetingTitle.value,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageController.greetingSubtitle.value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 20),
              _buildFeatureGrid(context),
              const SizedBox(height: 20),
              // Obx(() => _buildSectionCard(
              //       title: languageController.dailyDuaTitle.value,
              //       content: languageController.dailyDuaContent.value,
              //       subtitle: languageController.dailyDuaSubtitle.value,
              //     )),
              // const SizedBox(height: 20),
              // Obx(() => _buildSectionCard(
              //       title: languageController.dailyHadithTitle.value,
              //       content: languageController.dailyHadithContent.value,
              //       subtitle: languageController.dailyHadithSubtitle.value,
              //     )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // // Helper Method for Sections
  // static Widget _buildSectionCard({
  //   required String title,
  //   required String content,
  //   required String subtitle,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.2),
  //           blurRadius: 8,
  //           spreadRadius: 2,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.teal,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           content,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           subtitle,
  //           style: const TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey,
  //             fontStyle: FontStyle.italic,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Feature Grid Section
  static Widget _buildFeatureGrid(BuildContext context) {
    final LanguageController controller = Get.find();

    return Obx(() => GridView.builder(
          shrinkWrap: true,
          itemCount: controller.features.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final feature = controller.features[index];
            return GestureDetector(
              onTap: () {
                Get.to(feature['route'] as Widget);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature['icon'] as IconData,
                        color: TColors.white, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      feature['title'].value, // <-- important
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
