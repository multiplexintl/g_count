import 'dart:developer';

import 'package:g_count/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/settings/count_setting.dart';

class HomeController extends GetxController {
  CountSetting countSetting = CountSetting();
  String? date;
  @override
  void onInit() {
    getSystemDate();
    super.onInit();
  }

  void getSystemDate() {
    var now = DateTime.now();
    date = DateFormat("dd-MM-yyyy").format(now);
  }

  Future<void> getSettings() async {
    var result =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    log(result.toString());
    if (result.isNotEmpty) {
      List<CountSetting> countSettings =
          result.map((e) => CountSetting.fromJson(e)).toList();
      // log(countSettings.toString());
      countSetting = countSettings.first;
    }
  }
}
