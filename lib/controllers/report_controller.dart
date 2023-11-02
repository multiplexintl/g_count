import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/db/db_helper.dart';
import 'package:g_count/models/settings/user_master.dart';
import 'package:g_count/models/summery_report.dart';
import 'package:g_count/models/temp_count.dart';
import 'package:get/get.dart';

import '../models/details_report.dart';

class ReportController extends GetxController {
  var selectedRadio = 0.obs;
  final pageController = PageController();
  RxList<SummeryReport> summeryReportItems = <SummeryReport>[].obs;
  List<TempCount>? totalCountItems;
  RxList<DetailsReport> detailsReport = <DetailsReport>[].obs;
  var totalQty = 0.obs;
  List<String>? items;
  String? selectedItem;
  List<String>? racks;
  String? selectedRack;
  List<UserMaster>? users;
  String? selectedUser;
  @override
  void onInit() {
    getSummeryReport();
    getItems();
    super.onInit();
  }

  void clearAll() async {
    selectedItem = null;
    selectedRack = null;
    selectedUser = null;
    detailsReport.clear();
    getItems();
    // racks?.clear();
    // users?.clear();
//    getItems();
    update();
  }

  void setSelectedRadio(int val) {
    selectedRadio.value = val;
    log(val.toString());
    pageController.animateToPage(val,
        duration: const Duration(microseconds: 100), curve: Curves.bounceIn);
    // if (val == 0) {
    //   getSummeryReport();
    // }
  }

  Future<void> getSummeryReport() async {
    var query =
        '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.userNameUser}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}, ${DBHelper.usersTable} 
    WHERE ${DBHelper.usersTable}.${DBHelper.userCodeUser} = ${DBHelper.tempCountBackTable}.${DBHelper.userCodeTempCountBack} 
    GROUP BY ${DBHelper.rackNoTempCountBack},${DBHelper.userNameUser}''';
    totalQty.value = await DBHelper.getSumofColumn(
        tableName: DBHelper.tempCountBackTable,
        columnName: DBHelper.qtyTempCountBack);
    var result = await DBHelper.getItemsByRawQuery(query);
    summeryReportItems.value =
        result.map((e) => SummeryReport.fromJson(e)).toList();
  }

  Future<void> getItems() async {
    var result1 =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountBackTable);
    var result2 = await DBHelper.getAllItems(tableName: DBHelper.usersTable);
    totalCountItems = result1.map((e) => TempCount.fromJson(e)).toList();
    items = totalCountItems?.map((e) => e.partCode.toString()).toSet().toList();
    racks = totalCountItems?.map((e) => e.rackNo.toString()).toSet().toList();
    users = result2.map((e) => UserMaster.fromJson(e)).toList();
    update();
  }

  void setItem({required String itemCode}) async {
    selectedItem = itemCode;
    update();
  }

  void setRack({required String rack}) async {
    selectedRack = rack;
    update();
  }

  void setUser({required String user}) async {
    selectedUser = user;
    update();
  }

  void getRack({required String itemCode}) async {
    selectedItem = itemCode;
    // racks?.clear();
    // selectedRack = null;
    // users?.clear();
    // selectedUser = null;
    // update();
    // racks = totalCountItems
    //     ?.where((element) => element.partCode == itemCode)
    //     .map((e) => e.rackNo)
    //     .toSet()
    //     .toList();
    // log(racks.toString());
    // update();
  }

  void getUsers({required String rack}) async {
    selectedRack = rack;
    // users?.clear();
    // selectedUser = null;
    // update();
    // List<String>? userCodes = totalCountItems
    //     ?.where((element) =>
    //         element.rackNo == rack && element.partCode == selectedItem)
    //     .map((e) => e.userCode)
    //     .toSet()
    //     .toList();
    // log(userCodes.toString());
    // String query = '''SELECT * FROM ${DBHelper.usersTable}
    //     WHERE ${DBHelper.userCodeUser} IN (${userCodes?.map((code) => '\'$code\'').join(', ')})
    //     ORDER BY ${DBHelper.userNameUser}''';
    // var result = await DBHelper.getItemsByRawQuery(query);
    // // log(result.toString());
    // users = result.map((e) => UserMaster.fromJson(e)).toList();
    // log(users!.length.toString());
    // if (users!.length == 1) {
    //   getDetailReport(user: users!.first.userCd!);
    // }
    update();
  }

  void getDetailReport() async {
    String query = "";
    if (selectedItem != null && selectedRack != null && selectedUser != null) {
      log("All 3 selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.partCodeTempCountBack} = "$selectedItem"
    AND ${DBHelper.rackNoTempCountBack} = "$selectedRack"
    AND ${DBHelper.userCodeTempCountBack} = "$selectedUser"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem != null &&
        selectedRack == null &&
        selectedUser == null) {
      log("item selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.partCodeTempCountBack} = '$selectedItem'
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem == null &&
        selectedRack != null &&
        selectedUser == null) {
      log("rack selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.rackNoTempCountBack} = "$selectedRack"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem == null &&
        selectedRack == null &&
        selectedUser != null) {
      log("user selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.userCodeTempCountBack} = "$selectedUser"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem != null &&
        selectedRack != null &&
        selectedUser == null) {
      log("item,rack selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.partCodeTempCountBack} = "$selectedItem"
    AND ${DBHelper.rackNoTempCountBack} = "$selectedRack"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem != null &&
        selectedRack == null &&
        selectedUser != null) {
      log("item, user slected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.partCodeTempCountBack} = "$selectedItem"
    AND ${DBHelper.userCodeTempCountBack} = "$selectedUser"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else if (selectedItem == null &&
        selectedRack != null &&
        selectedUser != null) {
      log("rack, user selected");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    WHERE ${DBHelper.rackNoTempCountBack} = "$selectedRack"
    AND ${DBHelper.userCodeTempCountBack} = "$selectedUser"
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    } else {
      log("select any one");
      query =
          '''SELECT ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}, SUM(${DBHelper.qtyTempCountBack}) AS Qty
    FROM ${DBHelper.tempCountBackTable}
    GROUP BY ${DBHelper.rackNoTempCountBack}, ${DBHelper.barcodeTempCountBack}
        ''';
    }
    var result = await DBHelper.getItemsByRawQuery(query);
    detailsReport.value = result.map((e) => DetailsReport.fromJson(e)).toList();
    log(detailsReport.toString());
    update();
  }
}
