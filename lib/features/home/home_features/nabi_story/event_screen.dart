import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../controllers/story_controller.dart';
import 'story_screen.dart';

class EventScreen extends StatelessWidget {
  final String categoryId;

  final StoryController storyController = Get.find();

  EventScreen({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        foregroundColor: TColors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
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
                    "Inspirational Events\n of the Prophet (SAW)",
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
          Expanded(
            child: Obx(() {
              if (storyController.isLoadingEvents.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (storyController.events.isEmpty) {
                return const Center(
                    child: Text("No events available",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)));
              }

              return ListView.builder(
                itemCount: storyController.events.length,
                itemBuilder: (context, index) {
                  final event = storyController.events[index];
                  return GestureDetector(
                    onTap: () {
                      storyController.fetchStories(categoryId, event['id']);
                      Get.to(() => StoryScreen());
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(event['title'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(event['description'],
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
