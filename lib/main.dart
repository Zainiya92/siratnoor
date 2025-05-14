import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'repositories/authentication/authentication_repository.dart';

late Size mq;

void main() async {
  // Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Init Local Storage
  await GetStorage.init();

  // Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  // Uploading the structured data to Firestore
  //await uploadCategoryDataToFirestore(prophetLifeData);
  //await uploadCategoryDataToFirestore(adultLifeData);
  //await uploadCategoryDataToFirestore(prophethoodData);
  //await uploadCategoryDataToFirestore(postProphethoodData);

  runApp(const MyApp());
}

Future<void> uploadCategoryDataToFirestore(
    Map<String, dynamic> categoryData) async {
  try {
    // Adding the category document to Firestore
    DocumentReference categoryRef =
        await FirebaseFirestore.instance.collection('categories').add({
      'title': categoryData['title'],
      'description': categoryData['description'],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Adding events and stories under the category
    for (var event in categoryData['events']) {
      DocumentReference eventRef = await categoryRef.collection('events').add({
        'title': event['title'],
        'description': event['description'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      for (var story in event['stories']) {
        await eventRef.collection('stories').add({
          'title': story['title'],
          'content': story['content'],
          'createdAt': story['createdAt'],
        });
      }
    }

    print("Category, events, and stories uploaded successfully!");
  } catch (e) {
    print("Error uploading data: $e");
  }
}

Map<String, dynamic> prophetLifeData = {
  'title': 'حضرت محمد ﷺ کی ابتدائی زندگی',
  'description': 'حضرت محمد ﷺ کی پیدائش، بچپن اور ابتدائی دور کی تفصیلات۔',
  'events': [
    {
      'title': 'واقعہ ۱ - ولادت باسعادت',
      'description': 'حضرت محمد ﷺ کی مکہ مکرمہ میں پیدائش کا واقعہ۔',
      'stories': [
        {
          'title': 'کہانی ۱ - پیدائش کا واقعہ',
          'content':
              'حضرت محمد ﷺ ۱۲ ربیع الاول کو مکہ مکرمہ میں پیدا ہوئے۔ آپ ﷺ کی پیدائش کے وقت دنیا میں کئی عجیب نشانیاں ظاہر ہوئیں۔ کسریٰ کے محل لرز گئے، آتش کدے بجھ گئے اور دنیا نور سے بھر گئی۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
    {
      'title': 'واقعہ ۲ - حضرت حلیمہ سعدیہ کی پرورش',
      'description': 'حضرت محمد ﷺ کی حضرت حلیمہ سعدیہ کے ساتھ ابتدائی پرورش۔',
      'stories': [
        {
          'title': 'کہانی ۱ - حلیمہ سعدیہ کا انتخاب',
          'content':
              'جب مکہ میں قحط سالی تھی تو قبیلہ بنی سعد کی عورتیں بچوں کو دودھ پلانے کے لئے آئیں۔ حضرت حلیمہ سعدیہ کو محمد ﷺ کو گود لینے کا اعزاز حاصل ہوا۔ آپ ﷺ کی آمد سے ان کے گھر میں برکتیں آ گئیں۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
  ],
};

// اگلا کیٹیگری: جوانی کی زندگی
Map<String, dynamic> adultLifeData = {
  'title': 'حضرت محمد ﷺ کی جوانی کی زندگی',
  'description': 'حضرت محمد ﷺ کی جوانی، امانت داری اور نکاح کا دور۔',
  'events': [
    {
      'title': 'واقعہ ۱ - تجارت کا آغاز',
      'description':
          'حضرت محمد ﷺ کا حضرت خدیجہ رضی اللہ عنہا کی تجارت میں شراکت۔',
      'stories': [
        {
          'title': 'کہانی ۱ - تجارت میں سچائی اور امانت',
          'content':
              'حضرت محمد ﷺ اپنی دیانت داری اور سچائی کی وجہ سے اہل مکہ میں "الصادق" اور "الامین" کے لقب سے مشہور ہو گئے۔ حضرت خدیجہ رضی اللہ عنہا نے آپ کی دیانت سے متاثر ہو کر نکاح کی پیشکش کی۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
    {
      'title': 'واقعہ ۲ - نکاح حضرت خدیجہ سے',
      'description': 'حضرت محمد ﷺ اور حضرت خدیجہ رضی اللہ عنہا کا نکاح۔',
      'stories': [
        {
          'title': 'کہانی ۱ - نکاح کا بابرکت بندھن',
          'content':
              'جب حضرت خدیجہ رضی اللہ عنہا نے حضرت محمد ﷺ کی سچائی دیکھی تو انہوں نے نکاح کی خواہش ظاہر کی۔ نکاح 25 سال کی عمر میں ہوا اور حضرت خدیجہ آپ ﷺ کی سب سے پہلی اور وفادار بیوی تھیں۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
  ],
};

// اگلا کیٹیگری: نبوت کا دور
Map<String, dynamic> prophethoodData = {
  'title': 'حضرت محمد ﷺ کی نبوت کا زمانہ',
  'description': 'وحی کا آغاز اور دعوتِ اسلام کی جدوجہد۔',
  'events': [
    {
      'title': 'واقعہ ۱ - پہلی وحی',
      'description': 'غارِ حرا میں حضرت جبرائیل علیہ السلام کا نزول۔',
      'stories': [
        {
          'title': 'کہانی ۱ - اقراء باسم ربک',
          'content':
              'غارِ حرا میں حضرت محمد ﷺ پر پہلی وحی نازل ہوئی: "اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ"۔ اس لمحے سے نبوت کا آغاز ہوا اور آپ ﷺ نے انسانیت کو اللہ کی طرف بلانا شروع کیا۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
    {
      'title': 'واقعہ ۲ - دعوتِ اسلام کی ابتدا',
      'description': 'خفیہ اور اعلانیہ دعوت کا آغاز۔',
      'stories': [
        {
          'title': 'کہانی ۱ - خفیہ دعوت',
          'content':
              'ابتدائی تین سال تک حضرت محمد ﷺ نے خفیہ طور پر اسلام کی دعوت دی تاکہ مخالفت کا سامنا کم ہو۔ قریبی دوستوں اور خاندان والوں کو ایمان کی دعوت دی گئی۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
  ],
};

// آخری کیٹیگری: نبوت کے بعد کی زندگی
Map<String, dynamic> postProphethoodData = {
  'title': 'حضرت محمد ﷺ کی نبوت کے بعد کی زندگی',
  'description': 'ہجرت، مدینہ کی زندگی اور آخری ایام۔',
  'events': [
    {
      'title': 'واقعہ ۱ - ہجرت مدینہ',
      'description': 'مکہ سے مدینہ کی طرف ہجرت۔',
      'stories': [
        {
          'title': 'کہانی ۱ - ہجرت کی رات',
          'content':
              'قریش کے مظالم سے تنگ آ کر حضرت محمد ﷺ نے اللہ کے حکم سے مدینہ کی طرف ہجرت کی۔ حضرت ابوبکر رضی اللہ عنہ آپ ﷺ کے ساتھ تھے۔ راستے میں کئی معجزے ظاہر ہوئے۔',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
    {
      'title': 'واقعہ ۲ - خطبہ حجۃ الوداع',
      'description': 'حضرت محمد ﷺ کا آخری خطبہ۔',
      'stories': [
        {
          'title': 'کہانی ۱ - مکمل دین کی تکمیل',
          'content':
              'حجۃ الوداع کے موقع پر عرفات کے میدان میں حضرت محمد ﷺ نے انسانیت کے لیے عظیم اصول بیان کیے اور فرمایا: "آج میں نے تمہارے لیے تمہارا دین مکمل کر دیا۔"',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ],
    },
  ],
};
