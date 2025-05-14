import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/hadith_controller.dart';
import '../../../../../utils/constants/colors.dart';

class ManageHadithsScreen extends StatelessWidget {
  ManageHadithsScreen({super.key});

  final ManageHadithController controller = Get.put(ManageHadithController());

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final RxString _selectedCategory = ''.obs;
  final RxList<String> _categories = <String>[].obs;

  void _showAddHadithDialog(BuildContext context) async {
    _titleController.clear();
    _contentController.clear();

    // Load categories from controller (from categoryReligionMapping keys)
    _categories.value = controller.categoryReligionMapping.keys.toList();

    if (_categories.isNotEmpty) {
      _selectedCategory.value = _categories.first;
    } else {
      _selectedCategory.value = '';
    }

    Get.defaultDialog(
      title: "Add New Hadith",
      content: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              const SizedBox(height: 10),
              _categories.isEmpty
                  ? const Text('No categories found.')
                  : DropdownButton<String>(
                      value: _selectedCategory.value,
                      isExpanded: true,
                      items: _categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectedCategory.value = value;
                        }
                      },
                    ),
              const SizedBox(height: 10),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final title = _titleController.text.trim();
                          final content = _contentController.text.trim();
                          final category = _selectedCategory.value;

                          if (title.isEmpty ||
                              content.isEmpty ||
                              category.isEmpty) {
                            Get.snackbar('Error', 'All fields are required');
                            return;
                          }

                          // 👇 Auto-fetch religion based on selected category
                          final religion =
                              controller.categoryReligionMapping[category] ??
                                  'Unknown';

                          await controller.addHadith(
                              title, content, category, religion);

                          if (!controller.isLoading.value) {
                            Get.back();
                          }
                        },
                        child: const Text('Add Hadith'),
                      ),
                    ),
            ],
          ),
        );
      }),
      barrierDismissible: false,
    );
  }

  void _confirmDeleteHadith(BuildContext context, String hadithId) {
    Get.defaultDialog(
      title: "Delete Hadith",
      content: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox(
              height: 60, child: Center(child: CircularProgressIndicator()));
        }
        return const Text("Are you sure you want to delete this hadith?");
      }),
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await controller.deleteHadith(hadithId);
        if (!controller.isLoading.value) {
          Get.back();
        }
      },
      barrierDismissible: !controller.isLoading.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Hadiths"),
        iconTheme: const IconThemeData(color: TColors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hadiths').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var hadiths = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hadiths.length,
            itemBuilder: (context, index) {
              var hadith = hadiths[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(hadith['title'] ?? "No Title"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hadith['content'] ?? "No Content"),
                    if ((hadith['category'] ?? "").toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Category: ${hadith['category']}",
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      ),
                    if ((hadith['religion'] ?? "").toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Religion: ${hadith['religion']}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blueGrey),
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _confirmDeleteHadith(context, hadiths[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHadithDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
