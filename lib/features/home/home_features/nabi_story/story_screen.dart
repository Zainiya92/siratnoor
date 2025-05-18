import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../controllers/story_controller.dart';
import '../controllers/speak_controller.dart';

class StoryScreen extends StatelessWidget {
  final StoryController storyController = Get.find();
  final SpeakController speakController = Get.put(SpeakController());

  StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int extractStoryNumber(String title) {
      final regex = RegExp(r'کہانی\s*(\d+)');
      final match = regex.firstMatch(title);
      if (match != null) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
      return 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stories"),
        foregroundColor: TColors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (storyController.isLoadingStories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (storyController.stories.isEmpty) {
          return const Center(
              child: Text("No stories available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }

        // Copy and sort stories safely
        final sortedStories =
            List<Map<String, dynamic>>.from(storyController.stories);

        sortedStories.sort((a, b) {
          final aTitle = a['title']?.toString() ?? '';
          final bTitle = b['title']?.toString() ?? '';
          final aNum = extractStoryNumber(aTitle);
          final bNum = extractStoryNumber(bTitle);
          return aNum.compareTo(bNum);
        });

        return ListView.builder(
          itemCount: sortedStories.length,
          itemBuilder: (context, index) {
            final story = sortedStories[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            story['title'] ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(() {
                          final isSpeaking =
                              speakController.currentSpeakingId.value ==
                                  story['title'];
                          return IconButton(
                            icon: Icon(isSpeaking
                                ? Icons.volume_up
                                : Icons.volume_off),
                            onPressed: () {
                              if (isSpeaking) {
                                speakController.stopSpeaking();
                              } else {
                                speakController.speak(
                                    story['content'], story['title']);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(story['content'] ?? ''),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
