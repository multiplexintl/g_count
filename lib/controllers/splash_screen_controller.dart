import 'dart:developer';

import 'package:g_count/models/settings/count_setting.dart';

import '../db/db_helper.dart';
import '/routes.dart';

import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await getRoute();
  }

  Future<void> getRoute() async {
    var settingsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    //log(settingsFromDB.toString());

    var settings = settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();

    if (settings.isNotEmpty) {
      Get.offAndToNamed(RouteLinks.home);
    } else {
      Get.offAndToNamed(RouteLinks.admin, arguments: false);
    }
  }
}
