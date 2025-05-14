import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import '../controller/home_controller.dart';
import '../controller/prayer_time_controller.dart';

class PrayerTimingScreen extends StatelessWidget {
  const PrayerTimingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PrayerTimeController controller = Get.put(PrayerTimeController());
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Image.asset('assets/images/Mosque.png'),
          Container(
            width: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: TColors.golden,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Obx(() {
                  return Text(
                    languageController.isEnglish.value
                        ? "Today's Date"
                        : 'آج کی تاریخ',
                    style: TextStyle(
                      color: TColors.primary,
                      fontSize: 16,
                    ),
                  );
                }),
                const SizedBox(height: 4),
                Obx(() {
                  return Text(
                    controller.currentDate.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Prayer Times List
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: controller.prayerTimes.isNotEmpty
                    ? controller.prayerTimes.entries.map<Widget>((entry) {
                        return PrayerTimeRow(
                            prayerName: entry.key, time: entry.value);
                      }).toList()
                    : [],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PrayerTimeRow extends StatelessWidget {
  final String prayerName;
  final String time;

  const PrayerTimeRow({
    Key? key,
    required this.prayerName,
    required this.time,
  }) : super(key: key);

  // Helper function to format time
  String formatTime(String time24) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time24);
      return DateFormat("h:mm a").format(parsedTime);
    } catch (e) {
      return time24; // Fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = formatTime(time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  prayerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
