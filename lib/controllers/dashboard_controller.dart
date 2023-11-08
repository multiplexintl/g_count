import 'dart:async';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/models/dashboard.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:intl/intl.dart';

import '../db/db_helper.dart';
import '../models/settings/count_setting.dart';
import '../models/settings/user_master.dart';
import '../repositories/dashboard_repo.dart';

class DashBoardController extends GetxController {
  Timer? timer;

  var isSyncing = false.obs;

  @override
  void onInit() async {
    await createDashboard().then((value) {
      if (countSetting.countId != null && countSetting.stat != "Completed") {
        timer = Timer.periodic(const Duration(minutes: 15), (Timer t) {
          log("auto sync called for ${t.tick} times");
          synchronousSyncFunction();
        });
      }
    });
    super.onInit();
  }

  var dashBoard = DashBoard().obs;
  CountSetting countSetting = CountSetting();
  List<UserMaster> users = [];
  int partLength = 0;

  final InternetConnectionChecker customInstance =
      InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(minutes: 1),
    checkInterval: const Duration(seconds: 1),
  );

  Future<void> createDashboard() async {
    recursiveConnectionCheck();
    await getSettings();
    await setDashBoard();
  }

  Future<void> updateDashboard() async {
    //  recursiveConnectionCheck();
    await getSettings();
    await setDashBoard();
  }

  Future<void> getSettings() async {
    var settingsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    List<CountSetting> countSettings =
        settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();
    countSetting = countSettings.first;
    var usersFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.usersTable);
    users = usersFromDB.map((e) => UserMaster.fromJson(e)).toList();
    partLength = await DBHelper.getTableLength(tableName: DBHelper.partTable);
  }

  Future<void> setDashBoard() async {
    log(users.toString());
    try {
      dashBoard.value.countDate = getFormattedDate(countSetting.countDate!);
      dashBoard.value.locCode = countSetting.locCd;
      dashBoard.value.locName = countSetting.locationName;
      dashBoard.value.machID = countSetting.machId;
      // need to check for internet connection here
      // dashBoard.value.connection = false;
      dashBoard.value.countID = countSetting.countId;
      // get count in charge
      dashBoard.value.countInCharge = users
          .singleWhere((element) => element.userCd == countSetting.inCharge)
          .userName;
      // need to get counted racks from somewhere
      countedRacks();
      countQty();
      getUpdatedQty();
      dashBoard.value.totalQty = partLength;
      log(dashBoard.toString());
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> countedRacks() async {
    var result = await DBHelper.getItemsByRawQuery(
        "SELECT * FROM ${DBHelper.tempCountBackTable} GROUP BY ${DBHelper.rackNoTempCountBack}");
    //log(result.length.toString());
    dashBoard.value.countedRacks = result.length;
    update();
  }

  Future<void> countQty() async {
    var sum = await DBHelper.getSumofColumn(
        tableName: DBHelper.tempCountBackTable,
        columnName: DBHelper.qtyTempCountBack);
    dashBoard.value.countedQty = sum;
    update();
    log(sum.toString());
  }

  Future<void> getUpdatedQty() async {
    var result = await DashboardRepo()
        .getUpdatedQty(countSetting.countId!, countSetting.machId!);
    result.fold((l) {
      log("Error");
      dashBoard.value.updatedQty = 0;
    }, (r) {
      dashBoard.value.updatedQty = r.phyDetailQty;
    });
    update();
  }

  Future<void> sync() async {
    if (countSetting.countId != null) {
      isSyncing.value = true;
      update();
      List<bool> finalResults = await synchronousSyncFunction();
      if (finalResults.every((element) => true)) {
        // get updated count
        await getUpdatedQty();
        CustomWidgets.customSnackBar(
            title: "Updated",
            message: "Items updated to server",
            textColor: Colors.green);
      } else {
        CustomWidgets.customSnackBar(
            title: "Not Updated",
            message: "Items not updated to server",
            textColor: Colors.red);
      }
    } else {
      await createDashboard().then((value) => sync());
    }
    isSyncing.value = false;
    update();
  }

  Future<List<bool>> synchronousSyncFunction() async {
    log("sync called");
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var result3 =
        await DBHelper.getAllItems(tableName: DBHelper.phyDetailTable);
    log(result3.toString());
    var result2 = result3.map(
      (e) {
        return {
          "CountID": countSetting.countId,
          "ItCode": e['PartCode'],
          "MachId": countSetting.machId,
          "Qty": e['Qty'],
          "Dt": formattedDate,
        };
      },
    ).toList();
    var toUpload = {"PhyDetailsData": result2};

    log(toUpload.toString());

    var tempCountBack =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountBackTable);
    tempCountBack = tempCountBack.map((e) {
      return {
        "CountID": countSetting.countId,
        "SNo": e['SNo'],
        "ItCode": e["PartCode"],
        "Barcode": e['Barcode'],
        "Qty": e['Qty'],
        "RackNo": e['RackNo'],
        "UserCode": e['UserCode'],
        "MachId": countSetting.machId,
        "Dt": formattedDate,
      };
    }).toList();
    var tempCountToUpload = {"TempCountBackData": tempCountBack};

    var finalResults = await Future.wait<bool>([
      DashboardRepo().uploadPhyDetails(toUpload),
      DashboardRepo().uploadTempCountBack(tempCountToUpload)
    ]);
    return finalResults;
  }

  // void synchronousSyncFunction() async {
  //   log("auto sync called");
  //   String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  //   var finalQuery =
  //       '''SELECT ct.${DBHelper.countIDCountSettings} AS CountID, pd.${DBHelper.partCodePhyDetail} AS ItCode,
  //   ct.${DBHelper.machIDCountSettings} AS MachId, SUM(pd.${DBHelper.qtyPhyDetail}) AS Qty
  //   FROM ${DBHelper.countSettingsTable} ct
  //   INNER JOIN ${DBHelper.phyDetailTable} pd
  //   GROUP BY pd.${DBHelper.partCodePhyDetail};''';
  //   var result2 = await DBHelper.getItemsByRawQuery(finalQuery);
  //   result2 = result2.map(
  //     (e) {
  //       return {...e, "Dt": formattedDate};
  //     },
  //   ).toList();
  //   var toUpload = {"PhyDetailsData": result2};
  //   var tempCountBack =
  //       await DBHelper.getAllItems(tableName: DBHelper.tempCountBackTable);
  //   tempCountBack = tempCountBack.map((e) {
  //     return {
  //       "CountID": countSetting.countId,
  //       "SNo": e['SNo'],
  //       "ItCode": e["PartCode"],
  //       "Barcode": e['Barcode'],
  //       "Qty": e['Qty'],
  //       "RackNo": e['RackNo'],
  //       "UserCode": e['UserCode'],
  //       "MachId": countSetting.machId,
  //       "Dt": formattedDate,
  //     };
  //   }).toList();
  //   var tempCountToUpload = {"TempCountBackData": tempCountBack};
  //   DashboardRepo().uploadPhyDetails(toUpload);
  //   DashboardRepo().uploadTempCountBack(tempCountToUpload);
  // }

  Future<void> checkInternetConnection() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    dashBoard.value.connection = isConnected;
    update();
  }

  void recursiveConnectionCheck() async {
    customInstance.onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            dashBoard.value.connection = true;
            log('Data connection is available.');
            update();
          // break;
          case InternetConnectionStatus.disconnected:
            dashBoard.value.connection = false;
            update();
            log('You are disconnected from the internet.');
          //  break;
        }
      },
    );
  }

  String getFormattedDate(String string) {
    try {
      var newString = string.substring(0, string.indexOf("T"));
      DateTime dateTime = DateTime.parse(newString);
      String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      //log(e.toString());
      return string;
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
