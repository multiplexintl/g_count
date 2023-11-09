import 'package:flutter/services.dart';
import 'package:g_count/controllers/admin_controller.dart';
import 'package:get/get.dart';
import 'package:unique_identifier/unique_identifier.dart';

class SettingController extends GetxController {
  String identifier = 'Unknown';
  var adminCon = Get.find<AdminController>();
  @override
  void onInit() {
    initUniqueIdentifierState();
    super.onInit();
  }

  Future<void> initUniqueIdentifierState() async {
    String id;
    try {
      id = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      id = 'Failed to get Unique Identifier';
    }
    identifier = id;
  }
}
