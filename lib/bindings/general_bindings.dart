import 'package:get/get.dart';

import '../features/controller/home_controller.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
    Get.put(UserController());
    Get.put(LanguageController());
  }
}
