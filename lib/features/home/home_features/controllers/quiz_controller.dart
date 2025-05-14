import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var currentQuestionIndex = 0.obs;
  var score = 0.obs;
  var isQuizCompleted = false.obs;

  var questions = <Map<String, dynamic>>[].obs;
  var selectedQuestions =
      <Map<String, dynamic>>[].obs; // For the 10 random questions
  var selectedOption = "".obs; // Store the selected option

  @override
  void onInit() {
    super.onInit();
    fetchQuizQuestions();
  }

  // Fetch quiz questions from Firebase
  Future<void> fetchQuizQuestions() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
          await _firestore.collection('quiz_questions').get();
      final data = snapshot.docs
          .map((doc) => {
                "question": doc['question'],
                "options": List<String>.from(doc['options']),
                "correctAnswer": doc['correctAnswer'],
              })
          .toList();

      questions.assignAll(data);

      // Randomly select 10 questions from the fetched data
      selectedQuestions.assignAll(_getRandomQuestions(10));
    } catch (e) {
      print("Error fetching quiz questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to randomly select questions
  List<Map<String, dynamic>> _getRandomQuestions(int count) {
    final List<Map<String, dynamic>> temp = List.from(questions);
    temp.shuffle();
    return temp.take(count).toList();
  }

  // Function to check the answer
  void checkAnswer(String selectedOption) {
    if (selectedOption ==
        selectedQuestions[currentQuestionIndex.value]["correctAnswer"]) {
      score++;
    }

    if (currentQuestionIndex.value < selectedQuestions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      isQuizCompleted.value = true;
    }
  }

  // Function to reset quiz
  void resetQuiz() {
    score.value = 0;
    currentQuestionIndex.value = 0;
    isQuizCompleted.value = false;
    selectedOption.value = ""; // Reset selected option
    fetchQuizQuestions(); // Refetch quiz questions
  }
}
