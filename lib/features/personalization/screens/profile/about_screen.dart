import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';
import '../../../controller/home_controller.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white),
        title: Text(
          languageController.isEnglish.value
              ? 'About the App'
              : 'ایپ کے بارے میں',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                languageController.isEnglish.value
                    ? 'Welcome to the Islamic App'
                    : 'اسلامی ایپ میں خوش آمدید',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Introduction
              Text(
                languageController.isEnglish.value
                    ? 'This app is designed to provide Muslims with daily Islamic content, including Duas, Hadiths, Quranic verses, and much more.'
                    : 'یہ ایپ مسلمانوں کو روزانہ اسلامی مواد فراہم کرنے کے لئے ڈیزائن کی گئی ہے، جس میں دعائیں، حدیث، قرآن کے آیات اور بہت کچھ شامل ہے۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Features Section
              Text(
                languageController.isEnglish.value ? 'Features' : 'خصوصیات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? '• Daily Duas (Prayers)\n• Daily Hadith\n• Quranic Verses\n• Islamic Reminders\n• Islamic Quiz\n• Prayer Times\n• Islamic Calendar'
                    : '• روزانہ دعائیں\n• روزانہ حدیث\n• قرآن کے آیات\n• اسلامی یاد دہانیاں\n• اسلامی کوئز\n• نماز کے اوقات\n• اسلامی کیلنڈر',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Purpose Section
              Text(
                languageController.isEnglish.value ? 'Purpose' : 'مقصد',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'The purpose of this app is to help Muslims stay connected with their faith, increase their knowledge, and engage in daily Islamic practices.'
                    : 'اس ایپ کا مقصد مسلمانوں کو ان کے ایمان کے ساتھ جڑے رہنے میں مدد فراہم کرنا، ان کے علم میں اضافہ کرنا، اور روزانہ اسلامی اعمال میں مشغول کرنا ہے۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Developer Section
              Text(
                languageController.isEnglish.value ? 'Developer' : 'ڈویلپر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'Developed by [Your Company Name].\nWe hope this app helps you in your Islamic journey and brings you closer to Allah (SWT).'
                    : 'ڈویلپر: [آپ کے کمپنی کا نام].\nہم امید کرتے ہیں کہ یہ ایپ آپ کو اسلامی سفر میں مدد فراہم کرے گی اور اللہ (سبحانہ و تعالیٰ) کے قریب لے آئے گی۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Contact Information
              Text(
                languageController.isEnglish.value
                    ? 'Contact Us'
                    : 'ہم سے رابطہ کریں',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'For any inquiries, please contact us at:\ninfo@yourcompany.com'
                    : 'کسی بھی سوالات کے لئے، براہ کرم ہم سے رابطہ کریں:\ninfo@yourcompany.com',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
