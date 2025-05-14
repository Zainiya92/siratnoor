import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PrayerTimeController extends GetxController {
  var currentDate = ''.obs;
  var prayerTimes = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
    currentDate.value = DateFormat.yMMMMd().format(DateTime.now());
  }

  // Fetch prayer times from Aladhan API
  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;

    final response = await http.get(Uri.parse(
        'http://api.aladhan.com/v1/timingsByCity?city=Rawalpindi&country=Pakistan&method=2'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      prayerTimes.assignAll(data['data']['timings']);
    } else {
      throw Exception('Failed to load prayer times');
    }

    isLoading.value = false;
  }
}
