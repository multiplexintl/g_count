import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:g_count/models/settings/count_setting.dart';
import 'package:permission_handler/permission_handler.dart';

import '../db/db_helper.dart';
import '/routes.dart';

import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await getStoragePermission().then((value) async => await getRoute());
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

  Future<bool> getStoragePermission() async {
    bool storagePermissionStatus;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt >= 30) {
      storagePermissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      storagePermissionStatus = await Permission.storage.request().isGranted;
    }
    log(storagePermissionStatus.toString());
    return storagePermissionStatus;
  }
}
