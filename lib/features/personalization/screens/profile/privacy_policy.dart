import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';

import '../../../controller/home_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white),
        title: Text(
          languageController.isEnglish.value
              ? 'Privacy Policy'
              : 'پرائیویسی پالیسی',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                languageController.isEnglish.value
                    ? 'Privacy Policy'
                    : 'پرائیویسی پالیسی',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Introduction
              Text(
                languageController.isEnglish.value
                    ? 'This privacy policy explains how we collect, use, and protect your information when you use our Islamic App.'
                    : 'یہ پرائیویسی پالیسی اس بات کی وضاحت کرتی ہے کہ ہم آپ کی معلومات کو کیسے جمع کرتے ہیں، استعمال کرتے ہیں اور ہمارے اسلامی ایپ کے استعمال کے دوران آپ کی معلومات کی حفاظت کرتے ہیں۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Data Collection
              Text(
                languageController.isEnglish.value
                    ? 'Data Collection'
                    : 'معلومات کا جمع کرنا',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We collect personal information such as your name, email address, phone number, and other information when you use the app.'
                    : 'ہم ایپ کے استعمال کے دوران آپ کا نام، ای میل ایڈریس، فون نمبر اور دیگر معلومات جمع کرتے ہیں۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Data Usage
              Text(
                languageController.isEnglish.value
                    ? 'How We Use Your Data'
                    : 'ہم آپ کی معلومات کو کیسے استعمال کرتے ہیں',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We use your data to improve the app’s performance, provide personalized content, and offer you a better experience.'
                    : 'ہم آپ کی معلومات کو ایپ کی کارکردگی کو بہتر بنانے، ذاتی نوعیت کا مواد فراہم کرنے اور آپ کو بہتر تجربہ فراہم کرنے کے لئے استعمال کرتے ہیں۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Data Protection
              Text(
                languageController.isEnglish.value
                    ? 'Data Protection'
                    : 'معلومات کا تحفظ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We take appropriate security measures to protect your personal information and prevent unauthorized access.'
                    : 'ہم آپ کی ذاتی معلومات کو محفوظ رکھنے اور غیر مجاز رسائی سے بچانے کے لئے مناسب سیکیورٹی تدابیر اختیار کرتے ہیں۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Third-Party Sharing
              Text(
                languageController.isEnglish.value
                    ? 'Third-Party Sharing'
                    : 'تیسرے فریق کے ساتھ شیئرنگ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We do not share your personal information with any third parties without your consent, except when required by law.'
                    : 'ہم آپ کی ذاتی معلومات کو کسی بھی تیسرے فریق کے ساتھ آپ کی رضامندی کے بغیر شیئر نہیں کرتے، سوائے جب قانون کے تحت ضروری ہو۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Data Retention
              Text(
                languageController.isEnglish.value
                    ? 'Data Retention'
                    : 'معلومات کا ذخیرہ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We retain your personal data only for as long as necessary to provide the services and to comply with legal obligations.'
                    : 'ہم آپ کی ذاتی معلومات کو صرف اتنے عرصے تک رکھتے ہیں جتنا کہ خدمات فراہم کرنے کے لئے ضروری ہو اور قانونی ذمہ داریوں کو پورا کرنے کے لئے۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Changes to Policy
              Text(
                languageController.isEnglish.value
                    ? 'Changes to This Policy'
                    : 'اس پالیسی میں تبدیلیاں',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'We may update this privacy policy from time to time. Any changes will be posted on this page, and the effective date will be updated.'
                    : 'ہم وقتاً فوقتاً اس پرائیویسی پالیسی کو اپ ڈیٹ کر سکتے ہیں۔ کوئی بھی تبدیلیاں اس صفحے پر پوسٹ کی جائیں گی، اور مؤثر تاریخ کو اپ ڈیٹ کیا جائے گا۔',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Contact Us Section
              Text(
                languageController.isEnglish.value
                    ? 'Contact Us'
                    : 'ہم سے رابطہ کریں',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                languageController.isEnglish.value
                    ? 'If you have any questions about this privacy policy, please contact us at:\ninfo@yourcompany.com'
                    : 'اگر آپ کو اس پرائیویسی پالیسی کے بارے میں کوئی سوالات ہیں تو براہ کرم ہم سے رابطہ کریں:\ninfo@yourcompany.com',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
