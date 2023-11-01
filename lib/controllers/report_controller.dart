import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/db/db_helper.dart';
import 'package:g_count/models/settings/user_master.dart';
import 'package:g_count/models/temp_count.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  var selectedRadio = 0.obs;
  final pageController = PageController();
  var scannedBarcodes = [];
  setSelectedRadio(int val) {
    selectedRadio.value = val;
    log(val.toString());
    pageController.animateToPage(val,
        duration: const Duration(microseconds: 100), curve: Curves.bounceIn);
    if (val == 0) {
      getSummeryReport();
    }
  }

  Future<void> getSummeryReport() async {
    var result =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountBackTable);
    var result2 = await DBHelper.getAllItems(tableName: DBHelper.usersTable);
    List<UserMaster> users =
        result2.map((e) => UserMaster.fromJson(e)).toList();

    List<TempCount> tempCount =
        result.map((e) => TempCount.fromJson(e)).toList();
    for (TempCount tempCount in tempCount) {
      UserMaster? userMaster = users.firstWhere(
        (user) => user.userCd == tempCount.userCode,
      );
      tempCount.userCode = userMaster.userName!;
    }
    log(tempCount.toString());
    log(users.toString());
  }

  void updateUserCodes() {}
}
