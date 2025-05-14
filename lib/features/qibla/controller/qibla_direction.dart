import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart'; 

class QiblahController extends GetxController {
  // Observable to store the location status
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    checkLocationStatus();
  }

  @override
  void onClose() {
    _locationStreamController.close();  // Close the stream when the controller is disposed
    super.onClose();
  }


  // Check the location status
  Future<void> checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  // This method can be used to recheck the location status (for the retry button)
  Future<void> refreshLocationStatus() async {
    await checkLocationStatus();
  }
}
