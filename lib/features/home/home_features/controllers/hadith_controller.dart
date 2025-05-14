import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../hadith_model.dart';

class HadithController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var hadiths = <HadithModel>[].obs;
  var filteredHadiths = <HadithModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHadiths();

    // Listen to search query
    ever(searchQuery, (_) => filterHadiths());
  }

  void fetchHadiths() async {
    try {
      isLoading.value = true;
      hadiths.clear();

      final snapshot = await _firestore.collection('hadiths').get();

      final list = snapshot.docs.map((doc) {
        return HadithModel.fromFirestore(doc.data());
      }).toList();

      hadiths.assignAll(list);
      filteredHadiths.assignAll(list); // Start with all data
    } catch (e) {
      print("Error fetching hadiths: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterHadiths() {
    final query = searchQuery.value.toLowerCase();

    filteredHadiths.assignAll(
      hadiths.where((hadith) {
        return hadith.arabic.toLowerCase().contains(query) ||
            hadith.narrator.toLowerCase().contains(query) ||
            hadith.englishText.toLowerCase().contains(query);
      }).toList(),
    );
  }
}
