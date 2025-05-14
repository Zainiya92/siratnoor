import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ManageHadithController extends GetxController {
  var isLoading = false.obs;

  final Map<String, String> categoryReligionMapping = {
    // Sunni Hadith Collections
    'صحیح البخاری': 'Sunni',
    'صحیح مسلم': 'Sunni',
    'سنن ابوداؤد': 'Sunni',
    'جامع الترمذی': 'Sunni',
    'سنن نسائی': 'Sunni',
    'سنن ابن ماجہ': 'Sunni',

    // Additional famous Sunni books
    'موطا امام مالک': 'Sunni',
    'مسند احمد بن حنبل': 'Sunni',

    // Shia Hadith Collections
    'الکافی': 'Shia',
    'من لا یحضره الفقیہ': 'Shia',
    'تهذیب الأحكام': 'Shia',
    'الاستبصار': 'Shia',

    // Wahhabi/Salafi Recommended Sources
    'کتاب التوحید': 'Wahhabi',
    'سنن النسائی الکبریٰ': 'Wahhabi',

    // Neutral Islamic books
    'ریاض الصالحین': 'Sunni',
    'شرح السنہ': 'Sunni',
  };

  // ✅ Corrected function
  List<String> getCategoriesByReligion(String religion) {
    return categoryReligionMapping.entries
        .where((entry) => entry.value == religion)
        .map((entry) => entry.key)
        .toList();
  }

  // Add Hadith to Firebase
  Future<void> addHadith(
      String title, String content, String category, String religion) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance.collection('hadiths').add({
        'title': title,
        'content': content,
        'category': category,
        'religion': religion,
      });
    } finally {
      isLoading(false);
    }
  }

  // Delete Hadith from Firebase
  Future<void> deleteHadith(String hadithId) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('hadiths')
          .doc(hadithId)
          .delete();
    } finally {
      isLoading(false);
    }
  }
}
