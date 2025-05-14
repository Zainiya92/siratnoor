import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:translator/translator.dart';

import '../home/home_features/dua_screen.dart';
import '../home/home_features/hadith_screen.dart';
import '../home/home_features/islamic_places_screen.dart';
import '../home/home_features/nabi_story/category_screen.dart';
import '../home/home_features/quiz_screen.dart';
import '../home/home_features/religion_event_screen.dart';

class LanguageController extends GetxController {
  var isEnglish = false.obs;
  final storage = GetStorage();
  final translator = GoogleTranslator();

  // Store translated texts
  var greetingTitle = "السلام علیکم!".obs;
  var greetingSubtitle = "آپ کو اسلامی ایپ میں خوش آمدید۔".obs;
  var dailyDuaTitle = "روزانہ دعا".obs;
  var dailyDuaContent =
      "اللّهُـمَّ اكْفِـني بِحَلالِـكَ عَنْ حَرامِـكَ، وَاغْنِـني بِفَضْـلِكَ عَمَّـنْ سِـواكَ."
          .obs;
  var dailyDuaSubtitle = "اے اللہ، مجھے حلال کے ذریعے حرام سے بچا۔".obs;
  var dailyHadithTitle = "روزانہ حدیث".obs;
  var dailyHadithContent =
      "نبی کریم ﷺ نے فرمایا: 'طاقتور وہ ہے جو غصے کے وقت اپنے آپ پر قابو رکھے۔'"
          .obs;
  var dailyHadithSubtitle = "صحیح بخاری، کتاب 76، حدیث 4".obs;

  // Backup original Urdu texts
  final originalTexts = {
    "greetingTitle": "السلام علیکم!",
    "greetingSubtitle": "آپ کو اسلامی ایپ میں خوش آمدید۔",
    "dailyDuaTitle": "روزانہ دعا",
    "dailyDuaContent":
        "اللّهُـمَّ اكْفِـني بِحَلالِـكَ عَنْ حَرامِـكَ، وَاغْنِـني بِفَضْـلِكَ عَمَّـنْ سِـواكَ.",
    "dailyDuaSubtitle": "اے اللہ، مجھے حلال کے ذریعے حرام سے بچا۔",
    "dailyHadithTitle": "روزانہ حدیث",
    "dailyHadithContent":
        "نبی کریم ﷺ نے فرمایا: 'طاقتور وہ ہے جو غصے کے وقت اپنے آپ پر قابو رکھے۔' ",
    "dailyHadithSubtitle": "صحیح بخاری، کتاب 76، حدیث 4",
  };

  // Feature Titles (Static)
  final List<String> urduFeatureTitles = [
    "نبی کریم ﷺ کی کہانیاں",
    "حدیث",
    "کوئز",
    "دُعا",
    "مذہبی تقریبات",
    "مقاماتِ مقدسہ",
  ];

  final List<String> englishFeatureTitles = [
    "Stories of Prophet",
    "Hadith",
    "Quiz",
    "Dua",
    "Religious Events",
    "Holy Places",
  ];

  var features = <Map<String, dynamic>>[
    {
      "title": "نبی کریم ﷺ کی کہانیاں".obs,
      "icon": Icons.menu_book,
      "route": CategoryScreen()
    },
    {"title": "حدیث".obs, "icon": Icons.receipt_long, "route": HadithScreen()},
    {"title": "کوئز".obs, "icon": Icons.quiz, "route": QuizScreen()},
    {"title": "دُعا".obs, "icon": Icons.mosque, "route": DuaScreen()},
    {
      "title": "مذہبی تقریبات".obs,
      "icon": Iconsax.activity,
      "route": ReligiousEventsScreen()
    },
    {
      "title": "مقاماتِ مقدسہ".obs,
      "icon": Icons.location_city,
      "route": IslamicPlacesScreen()
    },
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    isEnglish.value = storage.read('isEnglish') ?? false;
    await toggleLanguage(isEnglish.value);
  }

  Future<void> toggleLanguage(bool value) async {
    isEnglish.value = value;
    storage.write('isEnglish', value);

    if (value) {
      // Switch to English titles
      for (int i = 0; i < features.length; i++) {
        features[i]["title"].value = englishFeatureTitles[i];
      }
    } else {
      // Switch back to Urdu titles
      for (int i = 0; i < features.length; i++) {
        features[i]["title"].value = urduFeatureTitles[i];
      }
    }

    // Update other translations (not needed for feature titles, but could be added here if required)
    greetingTitle.value = value ? "Asslam o Alikum!" : "السلام علیکم!";
    greetingSubtitle.value = value
        ? "Welcome to the Islamic App."
        : "آپ کو اسلامی ایپ میں خوش آمدید۔";
    dailyDuaTitle.value = value ? "Daily Dua" : "روزانہ دعا";
    dailyDuaContent.value = value
        ? "O Allah, provide me with what is halal and keep me away from what is haram."
        : "اللّهُـمَّ اكْفِـني بِحَلالِـكَ عَنْ حَرامِـكَ، وَاغْنِـني بِفَضْـلِكَ عَمَّـنْ سِـواكَ.";
    dailyDuaSubtitle.value = value
        ? "O Allah, protect me through halal."
        : "اے اللہ، مجھے حلال کے ذریعے حرام سے بچا۔";
    dailyHadithTitle.value = value ? "Daily Hadith" : "روزانہ حدیث";
    dailyHadithContent.value = value
        ? "The Prophet ﷺ said: 'The strong is the one who controls themselves when angry.'"
        : "نبی کریم ﷺ نے فرمایا: 'طاقتور وہ ہے جو غصے کے وقت اپنے آپ پر قابو رکھے۔'";
    dailyHadithSubtitle.value = value
        ? "Sahih Bukhari, Book 76, Hadith 4"
        : "صحیح بخاری، کتاب 76، حدیث 4";
  }

  // Translate dynamic text from Firebase (e.g. fullname)
  Future<String> translateText(String text, String from, String to) async {
    try {
      var translation = await translator.translate(text, from: from, to: to);
      return translation.text;
    } catch (e) {
      print("Translation error: $e");
      return text; // In case of error, return the original text
    }
  }
}
