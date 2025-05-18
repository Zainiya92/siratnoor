import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import 'controllers/hadith_controller.dart';
import 'controllers/speak_controller.dart';

class HadithScreen extends StatelessWidget {
  final HadithController hadithController = Get.put(HadithController());
  final SpeakController speakController = Get.put(SpeakController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white),
        title: const Text("Hadith"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Mosque.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 150,
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: Text(
                    "Selected Sayings of Prophet Muhammad (SAW)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                hadithController.searchQuery.value = value;
                hadithController
                    .filterHadiths(); // Filter based on search query
              },
              decoration: InputDecoration(
                hintText: 'Search Hadith...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Inside the build method:
          Expanded(
            child: Obx(() {
              if (hadithController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (hadithController.filteredHadiths.isEmpty) {
                return const Center(child: Text("No Hadiths Found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: hadithController.filteredHadiths.length,
                itemBuilder: (context, index) {
                  final hadith = hadithController.filteredHadiths[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hadith.arabic,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Narrated by: ${hadith.narrator}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hadith.englishText,
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Obx(() {
                              final isSpeaking =
                                  speakController.currentSpeakingId.value ==
                                      hadith.id.toString();
                              return IconButton(
                                icon: Icon(
                                  isSpeaking
                                      ? Icons.volume_up
                                      : Icons
                                          .volume_off, // ✅ correct icon logic
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  if (isSpeaking) {
                                    speakController.stopSpeaking();
                                  } else {
                                    speakController.speak(hadith.englishText,
                                        hadith.id.toString());
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
