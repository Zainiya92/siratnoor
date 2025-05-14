import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class DuaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterTts flutterTts = FlutterTts();

  var isLoading = false.obs;
  var isSpeaking = false.obs;
  var searchQuery = ''.obs;

  // Format: { categoryName: [dua1, dua2, ...] }
  var categorizedDuas = <String, List<Map<String, dynamic>>>{}.obs;
  var filteredCategories = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    fetchDuas();
    super.onInit();
  }

  void fetchDuas() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
          await _firestore.collection('dua_category').get();

      final Map<String, List<Map<String, dynamic>>> data = {};

      for (var doc in snapshot.docs) {
        final category = doc['category'] as String;
        final duas = List<Map<String, dynamic>>.from(doc['duas']);
        data[category] = duas;
      }

      categorizedDuas.assignAll(data);
      filteredCategories.assignAll(data);
    } catch (e) {
      print("Error fetching duas: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterDuas() {
    final query = searchQuery.value.toLowerCase();
    final Map<String, List<Map<String, dynamic>>> filtered = {};

    categorizedDuas.forEach((category, duasList) {
      final matches = duasList
          .where((dua) =>
              dua['title'].toString().toLowerCase().contains(query) ||
              dua['translation'].toString().toLowerCase().contains(query))
          .toList();

      if (matches.isNotEmpty) {
        filtered[category] = matches;
      }
    });

    filteredCategories.assignAll(filtered);
  }

  Future<void> speakText(String text, {String languageCode = "ar-SA"}) async {
    try {
      isSpeaking.value = true;
      await flutterTts.setLanguage(languageCode);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    } catch (e) {
      print("TTS error: $e");
    } finally {
      isSpeaking.value = false;
    }
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    isSpeaking.value = false;
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
