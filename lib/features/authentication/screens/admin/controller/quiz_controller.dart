import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  var isLoading = false.obs;
  var quizzes = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  void fetchQuizzes() {
    FirebaseFirestore.instance
        .collection('quiz_questions')
        .snapshots()
        .listen((snapshot) {
      quizzes.value = snapshot.docs;
    });
  }

  Future<void> addQuizQuestion({
    required String question,
    required String correctAnswer,
    required List<String> options,
  }) async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance.collection('quiz_questions').add({
        'question': question,
        'correctAnswer': correctAnswer,
        'options': options,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteQuizQuestion(String id) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('quiz_questions')
          .doc(id)
          .delete();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
