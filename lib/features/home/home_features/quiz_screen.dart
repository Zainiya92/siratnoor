import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import 'controllers/quiz_controller.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(QuizController());
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Obx(() {
          return Text(
            languageController.isEnglish.value
                ? "Quiz on Prophet Muhammad (SAW)"
                : "سوالات پیغمبر محمد (صلى الله عليه وسلم)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return controller.isQuizCompleted.value
            ? _buildResultScreen(controller, languageController)
            : _buildQuestionScreen(controller, context, languageController);
      }),
    );
  }

  // Question Screen
  Widget _buildQuestionScreen(QuizController controller, BuildContext context,
      LanguageController languageController) {
    final question =
        controller.selectedQuestions[controller.currentQuestionIndex.value];

    String toArabicNumber(int number) {
      const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      final digits = number.toString().split('');
      return digits.map((d) => arabicNumbers[int.parse(d)]).join();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Question
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            textAlign: TextAlign.right, // Align text to the right
            "سوال ${controller.currentQuestionIndex.value + 1}: ${question["question"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Options with Radio Buttons
        Column(
          children: question["options"].asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final option = entry.value;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                children: [
                  // Option Text (Text comes second)
                  Text(option, textAlign: TextAlign.right),
                  // Radio Button (Radio comes first)
                  Radio<String>(
                    value: option,
                    groupValue: controller.selectedOption.value,
                    onChanged: (value) {
                      controller.selectedOption.value = value!;
                    },
                  ),
                  Text(toArabicNumber(index + 1),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        ),

        // Submit Button
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              if (controller.selectedOption.value.isNotEmpty) {
                controller.checkAnswer(controller.selectedOption.value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(languageController.isEnglish.value
                          ? "Please select an option!"
                          : "براہ کرم کوئی آپشن منتخب کریں!")),
                );
              }
            },
            child: Obx(() {
              return Text(
                languageController.isEnglish.value ? "Submit" : "جمع کرائیں",
              );
            }),
          ),
        ),
      ],
    );
  }

  // Result Screen
  Widget _buildResultScreen(
      QuizController controller, LanguageController languageController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Obx(() {
            return Text(
              languageController.isEnglish.value
                  ? "Quiz Completed!"
                  : "کوئز مکمل ہو گیا!",
              style: TextStyle(fontSize: 24),
            );
          }),
          const SizedBox(height: 20),
          Text(
            languageController.isEnglish.value
                ? "Your Score: ${controller.score.value}/${controller.selectedQuestions.length}"
                : "آپ کا سکور: ${controller.score.value}/${controller.selectedQuestions.length}",
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: controller.resetQuiz,
              child: Obx(() {
                return Text(
                  languageController.isEnglish.value
                      ? "Retake Quiz"
                      : "دوبارہ کوئز کریں",
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
