import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_count/controllers/dashboard_controller.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import 'settings_controller.dart';

class AdminController extends GetxController {
  var uniqueIdentifier = 'Unknown'.obs;
  var showId = false.obs;

  var settingsImport = false.obs;
  var itemsImport = false.obs;
  var countExport = false.obs;
  var countFinalize = false.obs;
  var databaseCleared = false.obs;

  //CountSetting dashCon.countSetting = CountSetting();
  var dashCon = Get.put(DashBoardController());
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
    uniqueIdentifier.value = identifier;
  }

  Future<void> getStatus() async {
    var settingsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
    if (settingsFromDB.isNotEmpty) {
      log(settingsFromDB.toString());
      List<CountSetting> countSettings =
          settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();
      dashCon.countSetting = countSettings.first;
      settingsImport.value = true;
    } else {
      settingsImport.value = false;
    }
    var length = await DBHelper.getTableLength(tableName: DBHelper.partTable);
    itemsImport.value = length > 0 ? true : false;
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    dashCon.connection.value = isConnected;
    checkAPIConnection();
  }

  Future<void> checkAPIConnection() async {
    dashCon.apiConnection.value =
        await AdminRepo().checkAPIConnection(uniqueIdentifier.value);
  }

  Future<void> importSettings() async {
    log(uniqueIdentifier.value);
    var result = await AdminRepo().getCountSettings(uniqueIdentifier.value);
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
          dashCon.countSetting = settings.countSettings!.first;
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
          log("This Device is not authorized to perform this action.");
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
    dashCon.countSetting = countSettings.first;
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
    if (dashCon.countSetting.countId != null) {
      var result = await AdminRepo().getitems(dashCon.countSetting.countId!);
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

  Future<int> dropAndCreate() async {
    try {
      await DBHelper.executeRawQuery(
          "DROP TABLE IF EXISTS ${DBHelper.tempCountTable}");
      DBHelper.executeRawQuery("""CREATE TABLE ${DBHelper.tempCountTable}(
      ${DBHelper.slNoTempCount} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DBHelper.partCodeTempCount} TEXT NOT NULL,
      ${DBHelper.barcodeTempCount} TEXT NOT NULL,
      ${DBHelper.qtyTempCount} TEXT NOT NULL,
      ${DBHelper.rackNoTempCount} TEXT NOT NULL,
      ${DBHelper.userCodeTempCount} TEXT NOT NULL)""");
    } catch (e) {
      return -1;
    }
    return 0;
  }

  Future<bool> checkIfDBDeletable() async {
    var result = await DBHelper.getItems(
        tableName: DBHelper.countSettingsTable,
        columnName: DBHelper.statCountSettings,
        condition: "Scheduled");
    log(result.toString());
    return result.isEmpty ? true : false;
  }

  // delete all database and block back button too
  Future<void> deleteDatabase() async {
    // count completed, can delete db
    // take a backup before deleting??
    var result = await Future.wait([
      DBHelper.deleteAllItem(tableName: DBHelper.countSettingsTable),
      DBHelper.deleteAllItem(tableName: DBHelper.partTable),
      DBHelper.deleteAllItem(tableName: DBHelper.rackTable),
      //DBHelper.deleteAllItem(tableName: DBHelper.tempCountTable),
      dropAndCreate(),
      DBHelper.deleteAllItem(tableName: DBHelper.tempCountBackTable),
      DBHelper.deleteAllItem(tableName: DBHelper.tempCountDeleteTable),
      DBHelper.deleteAllItem(tableName: DBHelper.phyDetailTable),
      DBHelper.deleteAllItem(tableName: DBHelper.usersTable),
      DBHelper.deleteAllItem(tableName: DBHelper.countUserTable),
    ]);
    SettingController().deleteAllFiles();
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
      getStatus();
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

  Future<bool> checkTempCountAndFinalizeCount() async {
    var result =
        await DBHelper.getTableLength(tableName: DBHelper.tempCountTable);
    if (result <= 0) {
      return true;
    } else {
      return false;
    }
  }

  void exportCount() async {
    log(dashCon.countSetting.stat.toString());

    log("export called");
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
        "CountID": dashCon.countSetting.countId,
        "SNo": e['SNo'],
        "ItCode": e["PartCode"],
        "Barcode": e['Barcode'],
        "Qty": e['Qty'],
        "RackNo": e['RackNo'],
        "UserCode": e['UserCode'],
        "MachId": dashCon.countSetting.machId,
        "Dt": formattedDate,
      };
    }).toList();
    var tempCountToUpload = {"TempCountBackData": tempCountBack};
    List<bool> result = await Future.wait([
      DashboardRepo().uploadPhyDetails(toUpload),
      DashboardRepo().uploadTempCountBack(tempCountToUpload),
    ]);
    log(result.toString());
    if (result.any((element) => element == false)) {
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
    var result = await DashboardRepo().getUpdatedQty(
        dashCon.countSetting.countId!, dashCon.countSetting.machId!);
    log(result.toString());
    var tempCountBaclLength = await DBHelper.getSumofColumn(
        tableName: DBHelper.tempCountBackTable,
        columnName: DBHelper.qtyTempCountBack);
    var phyDetailsLength = await DBHelper.getSumofColumn(
        tableName: DBHelper.phyDetailTable, columnName: DBHelper.qtyPhyDetail);

    result.fold((l) {
      log("Error");
    }, (count) async {
      bool allEqual = count.phyDetailQty == phyDetailsLength &&
          phyDetailsLength == tempCountBaclLength &&
          tempCountBaclLength == count.tempCountQty;
      log(allEqual.toString());

      if (allEqual) {
        log("equal");
        // if equal update server variables
        dashCon.countSetting.stat = "Completed";
        log(dashCon.countSetting.toString());
        var result2 = await DashboardRepo().finalizeCount(dashCon.countSetting);
        if (result2) {
          // update count setting in variable and database
          var res = await DBHelper.updateItem(
            tableName: DBHelper.countSettingsTable,
            data: dashCon.countSetting.toJson(),
            keyColumn: DBHelper.countIDCountSettings,
            condition: dashCon.countSetting.countId.toString(),
          );
          countFinalize.value = true;
          log(res.toString());
          // Get.offAllNamed(RouteLinks.admin);
          CustomWidgets.customSnackBar(
            title: "Success",
            message:
                "The Physical Count and Temp Count Back is equal. Count Finalized.",
            textColor: Colors.green,
          );
        } else {
          CustomWidgets.customSnackBar(
            title: "Failed",
            message: "Count Not Finalized. Try Again",
            textColor: Colors.red,
          );
        }
      } else {
        log("not equal");
        CustomWidgets.customSnackBar(
          title: "Failed",
          message: "The Physical Count and Temp Count Back is not equal.",
          textColor: Colors.red,
        );
      }
      CustomWidgets.stopLoader();
    });
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
