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

        return ListView.builder(
          itemCount: storyController.stories.length,
          itemBuilder: (context, index) {
            final story = storyController.stories[index];
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
                            textAlign: TextAlign.right,
                            story['title'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Obx(() {
                          final isSpeaking = speakController.isSpeaking.value;
                          return IconButton(
                            icon: Icon(isSpeaking
                                ? Icons.volume_off
                                : Icons.volume_up),
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
                    Text(story['content']),
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
