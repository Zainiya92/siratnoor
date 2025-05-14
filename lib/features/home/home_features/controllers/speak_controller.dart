import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class SpeakController extends GetxController {
  final isSpeaking = false.obs;
  final FlutterTts flutterTts = FlutterTts();
  var currentSpeakingId = ''.obs;

  @override
  void onClose() {
    // Stop speaking when the controller is disposed
    flutterTts.stop();
    super.onClose();
  }

  Future<void> speak(String text, String id) async {
    await stopSpeaking(); // stop any previous
    await flutterTts.setLanguage("ur-PK"); // Urdu
    await flutterTts.setSpeechRate(0.5); // normal speed
    isSpeaking.value = true;
    currentSpeakingId.value = id;
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
      currentSpeakingId.value = '';
    });
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    isSpeaking.value = false;
    currentSpeakingId.value = '';
  }
}
