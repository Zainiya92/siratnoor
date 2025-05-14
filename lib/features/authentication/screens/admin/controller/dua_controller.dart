import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ManageDuaController extends GetxController {
  var isLoading = false.obs;

  Future<void> addDua(
      String title, String description, String translation) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance.collection('duas').add({
        'title': title,
        'description': description,
        'translation': translation,
      });
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteDua(String duaId) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance.collection('duas').doc(duaId).delete();
    } finally {
      isLoading(false);
    }
  }
}
