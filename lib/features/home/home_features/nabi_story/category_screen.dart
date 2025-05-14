import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';
import '../controllers/story_controller.dart';
import 'event_screen.dart';

class CategoryScreen extends StatelessWidget {
  final StoryController storyController = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prophet's Stories"),
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
                      "Inspirational Stories\n of the Prophet (SAW)",
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
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (value) {
                  storyController.setSearchAge(value);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter age to filter...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Obx(() {
              if (storyController.isLoadingCategories.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (storyController.filteredCategories.isEmpty) {
                return const Center(
                    child: Text("No categories available",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)));
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: storyController.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = storyController.filteredCategories[index];
                    return GestureDetector(
                      onTap: () {
                        storyController.fetchEvents(category['id']);
                        Get.to(() => EventScreen(categoryId: category['id']));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(category['title'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(category['description'],
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
