import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sirat_noor/features/personalization/screens/setting/settings.dart';
import 'package:sirat_noor/utils/constants/colors.dart';

import 'controller/home_controller.dart';
import 'home/home_screen.dart';
import 'prayer_time/prayer_time.dart';
import 'qibla/qibla_screen.dart';
import 'tasbeeh_counter/tasbeeh_counter.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

class BottomNavBarPage extends StatelessWidget {
  const BottomNavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());
    final languageController = Get.find<LanguageController>(); // <-- Add this

    List<Widget> pages = [
      HomeScreen(),
      PrayerTimingScreen(),
      QiblaDirectionScreen(),
      TashbihCounterScreen(),
      SettingScreen(),
    ];

    return Scaffold(
      body: Obx(() {
        return pages[controller.currentIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          backgroundColor: TColors.primary,
          selectedItemColor: TColors.golden,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: languageController.isEnglish.value ? 'Home' : 'ہوم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              label: languageController.isEnglish.value
                  ? 'Prayer Time'
                  : 'نماز کا وقت',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: languageController.isEnglish.value ? 'Qibla' : 'قبلہ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.calculator5),
              label: languageController.isEnglish.value ? 'Tasbeeh' : 'تسبیح',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: languageController.isEnglish.value ? 'Account' : 'اکاؤنٹ',
            ),
          ],
        );
      }),
    );
  }
}
