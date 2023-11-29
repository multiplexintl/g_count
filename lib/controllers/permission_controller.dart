import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  @override
  void onInit() async {
    // await handlePermission();
    await getStoragePermission();
    super.onInit();
  }

  Future<void> getStoragePermission() async {
    bool storagePermissionStatus;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt >= 30) {
      storagePermissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      storagePermissionStatus = await Permission.storage.request().isGranted;
    }
    log(storagePermissionStatus.toString());
  }

  Future<dynamic> permissionDialogue(
      {required String title, required String subtitle}) {
    return Get.dialog(
      AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(subtitle),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }
}
