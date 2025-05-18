import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';

import 'controllers/dua_controller.dart';

class DuaScreen extends StatelessWidget {
  final DuaController controller = Get.put(DuaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: TColors.white),
        title: const Text(
          "Daily Duas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = controller.filteredCategories;

        return Column(
          children: [
            // Header Image
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
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Text(
                      "Beautiful Duas for Every Day",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (query) {
                  controller.searchQuery.value = query;
                  controller.filterDuas();
                },
                decoration: InputDecoration(
                  labelText: 'Search for Dua...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            // Dua List
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories.keys.elementAt(index);
                  final duas = categories[category]!;

                  return ExpansionTile(
                    title: Text(
                      category,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: duas.map((dua) {
                      final id = dua['id']
                          .toString(); // Make sure each dua has a unique ID

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dua['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Arabic (description) + speaker
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dua['description'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: TColors.golden,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    final isSpeaking =
                                        controller.currentSpeakingId.value ==
                                            "${id}_ar";
                                    return IconButton(
                                      icon: Icon(
                                        isSpeaking
                                            ? Icons.volume_up
                                            : Icons.volume_off,
                                        color: Colors.teal,
                                      ),
                                      onPressed: () {
                                        if (isSpeaking) {
                                          controller.stopSpeaking();
                                        } else {
                                          controller.speakText(
                                            dua['description'] ?? '',
                                            id: "${id}_ar",
                                            languageCode: "ar-SA",
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Translation + speaker
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dua['translation'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: TColors.golden,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    final isSpeaking =
                                        controller.currentSpeakingId.value ==
                                            "${id}_tr";
                                    return IconButton(
                                      icon: Icon(
                                        isSpeaking
                                            ? Icons.volume_up
                                            : Icons.volume_off,
                                        color: Colors.teal,
                                      ),
                                      onPressed: () {
                                        if (isSpeaking) {
                                          controller.stopSpeaking();
                                        } else {
                                          controller.speakText(
                                            dua['translation'] ?? '',
                                            id: "${id}_tr",
                                            languageCode: "ur-PK",
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(height: 8),
                              if (dua['reference'] != null &&
                                  dua['reference'].toString().isNotEmpty)
                                Text(
                                  "Reference: ${dua['reference']}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
