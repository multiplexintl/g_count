import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import '../repositories/dashboard_repo.dart';
import '/db/db_helper.dart';
import '/models/settings/count_setting.dart';
import '/models/settings/rack_master.dart';
import '/models/settings/user_master.dart';
import '/repositories/admin_repo.dart';
import 'package:get/get.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../routes.dart';

class AdminController extends GetxController {
  String _identifier = 'Unknown';

  var settingsImport = false.obs;
  var itemsImport = false.obs;
  var countExport = false.obs;
  var countFinalize = false.obs;
  var databaseCleared = false.obs;

  CountSetting countSetting = CountSetting();
  List<UserMaster> users = [];
  List<RackMaster> rack = [];

  @override
  void onInit() {
    initUniqueIdentifierState();
    getStatus();
    super.onInit();
  }

  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }
    _identifier = identifier;
  }

  Future<void> getStatus() async {
    var settingsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    log(settingsFromDB.toString());
    List<CountSetting> countSettings =
        settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();
    countSetting = countSettings.first;
    settingsImport.value = true;
    var length = await DBHelper.getTableLength(tableName: DBHelper.partTable);
    itemsImport.value = length > 0 ? true : false;
  }

  Future<void> importSettings() async {
    log(_identifier);
    var result = await AdminRepo().getCountSettings(_identifier);
    result.fold(
      (error) {
        log(error);
        CustomWidgets.stopLoader();
        CustomWidgets.customSnackBar(
          title: "Error!!",
          message: error,
          textColor: Colors.red,
          duration: 6,
        );
      },
      (settings) async {
        if (settings.countSettings != null &&
            settings.countSettings!.isNotEmpty) {
          await DBHelper.deleteAllItem(tableName: DBHelper.countSettingsTable);
          var countSettingToTable =
              settings.countSettings?.map((e) => e.toJson()).toList();
          var addtoSettings = await DBHelper.bulkInsert(
              tableName: DBHelper.countSettingsTable,
              items: countSettingToTable!);
          log(addtoSettings.toString());
          //  log(settings.userMaster.toString());
          var deleteUsers =
              await DBHelper.deleteAllItem(tableName: DBHelper.usersTable);
          log(deleteUsers.toString());
          var usersToTable =
              settings.userMaster?.map((e) => e.toJson()).toList();
          log(usersToTable.toString());
          await DBHelper.bulkInsert(
              tableName: DBHelper.usersTable, items: usersToTable!);
          var deleteRack =
              await DBHelper.deleteAllItem(tableName: DBHelper.rackTable);
          log(deleteRack.toString());
          var racksToTable =
              settings.rackMaster?.map((e) => e.toJson()).toList();
          await DBHelper.bulkInsert(
              tableName: DBHelper.rackTable, items: racksToTable!);
          await setSettings();
          CustomWidgets.stopLoader();
          CustomWidgets.customSnackBar(
            title: "Success",
            message: "Settings Imported Successfully",
            textColor: Colors.green,
            duration: 4,
          );
        } else {
          log("This Mobile is not authorized to perform this action.");
          CustomWidgets.stopLoader();
          CustomWidgets.customSnackBar(
            title: "Failed",
            message:
                "This Device is not authorized to perform this action. Please Contact IT.",
            textColor: Colors.red,
            duration: 6,
          );
        }
      },
    );
  }

  Future<void> setSettings() async {
    var settingsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    log(settingsFromDB.toString());
    List<CountSetting> countSettings =
        settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();
    countSetting = countSettings.first;
    settingsImport.value = true;
    var usersFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.usersTable);
    users = usersFromDB.map((e) => UserMaster.fromJson(e)).toList();
    // log(users.toString());
    var rackFromDB = await DBHelper.getAllItems(tableName: DBHelper.rackTable);
    rack = rackFromDB.map((e) => RackMaster.fromJson(e)).toList();
    // log(rack.toString());
  }

  Future<void> importItems() async {
    if (countSetting.countId != null) {
      var result = await AdminRepo().getitems(countSetting.countId!);
      result.fold(
        (error) {
          log(error);
          CustomWidgets.stopLoader();
          CustomWidgets.customSnackBar(
            title: "Error!!",
            message: error,
            textColor: Colors.red,
            duration: 6,
          );
        },
        (items) async {
          var itemsToTable = items.map((e) => e.toJson()).toList();
          var result = await DBHelper.bulkInsert(
              tableName: DBHelper.partTable, items: itemsToTable);
          log(result.length.toString());
          var length =
              await DBHelper.getTableLength(tableName: DBHelper.partTable);
          if (result != [] || result.isNotEmpty) {
            log("added $length items");
            itemsImport.value = true;
            Get.offAndToNamed(RouteLinks.home);
            CustomWidgets.stopLoader();
            CustomWidgets.customSnackBar(
              title: "Success",
              message: " $length Items have been imported.",
              textColor: Colors.green,
              duration: 4,
            );
          } else {
            // addingItem.value = "Error in adding items, try again";
            CustomWidgets.stopLoader();
            CustomWidgets.customSnackBar(
              title: "Error!!",
              message: "Error in adding items, try again.",
              textColor: Colors.red,
              duration: 6,
            );
          }
        },
      );
    } else {
      log("Import settings first");
      CustomWidgets.stopLoader();
      CustomWidgets.customSnackBar(
        title: "Error!!",
        message: "Import settings before importing items.",
        textColor: Colors.red,
        duration: 6,
      );
    }
  }

  // delete all database and bock back button too

  Future<void> deleteDatabase() async {
    // take a backup before deleting??
    var result = await Future.wait([
      DBHelper.deleteAllItem(tableName: DBHelper.countSettingsTable),
      DBHelper.deleteAllItem(tableName: DBHelper.partTable),
      DBHelper.deleteAllItem(tableName: DBHelper.phyDetailTable),
      DBHelper.deleteAllItem(tableName: DBHelper.rackTable),
      DBHelper.deleteAllItem(tableName: DBHelper.tempCountTable),
      DBHelper.deleteAllItem(tableName: DBHelper.tempCountBackTable),
      DBHelper.deleteAllItem(tableName: DBHelper.tempCountDeleteTable),
      DBHelper.deleteAllItem(tableName: DBHelper.usersTable),
      DBHelper.deleteAllItem(tableName: DBHelper.countUserTable),
    ]);
    log(result.toString());
    final finalResult = result.any((element) => element == -1);
    log(finalResult.toString());
    CustomWidgets.stopLoader();
    if (finalResult) {
      //error
      CustomWidgets.customSnackBar(
        title: "Failed",
        message: "Database Not Cleared, Try Again",
        textColor: Colors.red,
        duration: 6,
      );
    } else {
      //success
      Get.offAllNamed(RouteLinks.admin);
      CustomWidgets.customSnackBar(
        title: "Success",
        message: "Database Cleared",
        textColor: Colors.green,
        duration: 6,
      );
    }
  }

  void exportCount() async {
    log("auto sync called");
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var finalQuery =
        '''SELECT ct.${DBHelper.countIDCountSettings} AS CountID, pd.${DBHelper.partCodePhyDetail} AS ItCode, 
    ct.${DBHelper.machIDCountSettings} AS MachId, SUM(pd.${DBHelper.qtyPhyDetail}) AS Qty 
    FROM ${DBHelper.countSettingsTable} ct
    INNER JOIN ${DBHelper.phyDetailTable} pd
    GROUP BY pd.${DBHelper.partCodePhyDetail};''';
    var result2 = await DBHelper.getItemsByRawQuery(finalQuery);
    result2 = result2.map(
      (e) {
        return {...e, "Dt": formattedDate};
      },
    ).toList();
    var toUpload = {"PhyDetailsData": result2};
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
    List<bool> result = await Future.wait([
      DashboardRepo().uploadPhyDetails(toUpload),
      DashboardRepo().uploadTempCountBack(tempCountToUpload),
    ]);
    if (result.any((element) => false)) {
      log("not updated");
      CustomWidgets.customSnackBar(
        title: "Failed",
        message: "Count Not Updated Successfully",
        textColor: Colors.red,
      );
    } else {
      log("updated");
      countExport.value = true;
      CustomWidgets.customSnackBar(
        title: "Success",
        message: "Count Updated Successfully",
        textColor: Colors.green,
      );
    }
    CustomWidgets.stopLoader();
  }

  Future<void> finalizeCount() async {
    var result = await DashboardRepo()
        .getUpdatedQty(countSetting.countId!, countSetting.machId!);
    result.fold((l) {
      log("Error");
    }, (r) async {
      if (r.phyDetailQty == r.tempCountQty) {
        log("equal");
        // update count setting in variable and database
        countSetting.stat = "Completed";
        var res = await DBHelper.updateItem(
          tableName: DBHelper.countSettingsTable,
          data: countSetting.toJson(),
          keyColumn: DBHelper.countIDCountSettings,
          condition: countSetting.countId.toString(),
        );
        countFinalize.value = true;
        log(res.toString());
        Get.offAllNamed(RouteLinks.admin);
        CustomWidgets.customSnackBar(
          title: "Success",
          message: "The Physical Count and Temp Count Back is equal.",
          textColor: Colors.green,
        );
      } else {
        log("not equal");
        CustomWidgets.customSnackBar(
          title: "Failed",
          message: "The Physical Count and Temp Count Back is not equal.",
          textColor: Colors.red,
        );
      }
    });
    CustomWidgets.stopLoader();
    update();
  }

  void getDetails() async {
    await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    await DBHelper.getAllItems(tableName: DBHelper.usersTable);
    await DBHelper.getAllItems(tableName: DBHelper.rackTable);
    // await DBHelper.getAllItems(tableName: DBHelper.partTable);
    await DBHelper.getTableLength(tableName: DBHelper.partTable);
  }
}

// THIS SHORT CODE CAN SHOW WHAT IS BEIG UPDATED IN DB
// final database = await DBHelper.db;
// for (var i = 0; i < settings.userMaster!.length; i++) {
//   var result = await database.insert(
//       DBHelper.usersTable, settings.userMaster![i].toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace);
//   await Future.delayed(const Duration(seconds: 1));
//   if (result != 0) {
//     addingItem.value = settings.userMaster![i].userName!;
//   }
// }