import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../controller/quiz_controller.dart';

class ManageQuizScreen extends StatelessWidget {
  ManageQuizScreen({super.key});

  final QuizController controller = Get.put(QuizController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController questionController = TextEditingController();
  final TextEditingController correctAnswerController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());

  void clearForm() {
    questionController.clear();
    correctAnswerController.clear();
    for (var c in optionControllers) {
      c.clear();
    }
  }

  void showAddQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Quiz Question'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter a question'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: correctAnswerController,
                    decoration:
                        const InputDecoration(labelText: 'Correct Answer'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter correct answer'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: optionControllers[index],
                        decoration:
                            InputDecoration(labelText: 'Option ${index + 1}'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter option'
                                : null,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clearForm();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            final question = questionController.text.trim();
                            final correctAnswer =
                                correctAnswerController.text.trim();
                            final options = optionControllers
                                .map((c) => c.text.trim())
                                .toList();

                            controller
                                .addQuizQuestion(
                              question: question,
                              correctAnswer: correctAnswer,
                              options: options,
                            )
                                .then((_) {
                              clearForm();
                              Navigator.of(context).pop();
                            });
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Add'),
                )),
          ],
        );
      },
    );
  }

  void showDeleteConfirmDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this question?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.deleteQuizQuestion(id);
                          Navigator.of(context).pop();
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Delete'),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Quiz'),
        iconTheme: IconThemeData(
          color: TColors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showAddQuizDialog(context),
          )
        ],
      ),
      body: Obx(() {
        if (controller.quizzes.isEmpty) {
          return const Center(child: Text('No quiz questions found.'));
        }

        return ListView.builder(
          itemCount: controller.quizzes.length,
          itemBuilder: (context, index) {
            final quiz =
                controller.quizzes[index].data() as Map<String, dynamic>;
            final quizId = controller.quizzes[index].id;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(quiz['question'] ?? 'No Question'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Correct Answer: ${quiz['correctAnswer'] ?? 'N/A'}'),
                    const SizedBox(height: 4),
                    Text('Options:'),
                    ...List<String>.from(quiz['options'] ?? [])
                        .map((opt) => Text('• $opt')),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => showDeleteConfirmDialog(context, quizId),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
