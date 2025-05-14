import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';
import '../controller/dua_controller.dart';

class ManageDuasScreen extends StatelessWidget {
  ManageDuasScreen({super.key});

  final ManageDuaController controller = Get.put(ManageDuaController());

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _translationController = TextEditingController();

  void _showAddDuaDialog(BuildContext context) {
    _titleController.clear();
    _descriptionController.clear();
    _translationController.clear();

    Get.defaultDialog(
      title: "Add New Dua",
      content: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          SizedBox(
            height: TSizes.spaceBtwItem,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          SizedBox(
            height: TSizes.spaceBtwItem,
          ),
          TextField(
            controller: _translationController,
            decoration: const InputDecoration(labelText: 'Translation'),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();
                      final translation = _translationController.text.trim();

                      if (title.isEmpty || description.isEmpty) {
                        Get.snackbar(
                            'Error', 'Title and Description are required');
                        return;
                      }

                      await controller.addDua(title, description, translation);
                      if (!controller.isLoading.value) {
                        Get.back(); // Close dialog on success
                      }
                    },
                    child: const Text('Add Dua'),
                  );
          }),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _confirmDeleteDua(BuildContext context, String duaId) {
    Get.defaultDialog(
      title: "Delete Dua",
      content: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox(
              height: 60, child: Center(child: CircularProgressIndicator()));
        }
        return const Text("Are you sure you want to delete this dua?");
      }),
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await controller.deleteDua(duaId);
        if (!controller.isLoading.value) {
          Get.back(); // Close dialog after deletion
        }
      },
      barrierDismissible: !controller.isLoading.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Duas"),
        iconTheme: IconThemeData(
          color: TColors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('duas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var duas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: duas.length,
            itemBuilder: (context, index) {
              var dua = duas[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(dua['title'] ?? "No Title"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dua['description'] ?? "No Description"),
                    if ((dua['translation'] ?? "").toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          dua['translation'],
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteDua(context, duas[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDuaDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
