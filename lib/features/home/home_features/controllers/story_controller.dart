import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoadingCategories = false.obs;
  var isLoadingEvents = false.obs;
  var isLoadingStories = false.obs;

  var categories = <Map<String, dynamic>>[].obs;
  var events = <Map<String, dynamic>>[].obs;
  var stories = <Map<String, dynamic>>[].obs;

  var searchAge = ''.obs;

  var filteredCategories = <Map<String, dynamic>>[].obs;

  void setSearchAge(String age) {
    searchAge.value = age;
    _filterCategories();
  }

  void _filterCategories() {
    if (searchAge.isEmpty) {
      filteredCategories.value = [...categories];
    } else {
      int enteredAge = int.tryParse(searchAge.value) ?? 0;

      filteredCategories.value = categories.where((cat) {
        final ageRange = cat['title'] ?? '';
        final match = RegExp(r'(\d+)\s*-\s*(\d+)').firstMatch(ageRange);
        if (match != null) {
          int minAge = int.parse(match.group(1)!);
          int maxAge = int.parse(match.group(2)!);
          return enteredAge >= minAge && enteredAge <= maxAge;
        }
        return false;
      }).toList();
    }

    // Optional: Sort by min age
    filteredCategories.sort((a, b) {
      int aMin = int.tryParse(
              RegExp(r'(\d+)').firstMatch(a['title'])?.group(1) ?? '0') ??
          0;
      int bMin = int.tryParse(
              RegExp(r'(\d+)').firstMatch(b['title'])?.group(1) ?? '0') ??
          0;
      return aMin.compareTo(bMin);
    });
  }

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    isLoadingCategories.value = true; // Start loading categories
    try {
      var snapshot = await _firestore.collection('categories').get();
      categories.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Ensure each category has its ID
        return data;
      }).toList();
    } catch (e) {
      print("❌ Error fetching categories: $e");
      categories.clear();
    }
    isLoadingCategories.value = false; // Stop loading
    _filterCategories();
  }

  void fetchEvents(String categoryId) async {
    isLoadingEvents.value = true; // Start loading events
    try {
      var snapshot = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('events')
          .get();

      events.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Ensure each event has its ID
        return data;
      }).toList();
    } catch (e) {
      print("❌ Error fetching events: $e");
      events.clear();
    }
    isLoadingEvents.value = false; // Stop loading
  }

  void fetchStories(String categoryId, String eventId) async {
    isLoadingStories.value = true; // Start loading stories
    try {
      var snapshot = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('events')
          .doc(eventId)
          .collection('stories')
          .get();

      stories.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Ensure each story has its ID
        return data;
      }).toList();
    } catch (e) {
      print("❌ Error fetching stories: $e");
      stories.clear();
    }
    isLoadingStories.value = false; // Stop loading
  }
}
