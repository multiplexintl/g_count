import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:g_count/db/db_helper.dart';
import 'package:g_count/models/count_user.dart';
import 'package:g_count/models/item.dart';
import 'package:g_count/models/temp_count.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

import '../models/settings/count_setting.dart';
import '../models/settings/rack_master.dart';
import '../models/settings/user_master.dart';
import '../routes.dart';
import '../widgets/custom_widgets.dart';

class CountController extends GetxController {
  @override
  void onInit() {
    // createUser();
    super.onInit();
  }

  var textEditingController = TextEditingController();
  var individualtextEditingController = TextEditingController().obs;
  var individualQtytextEditingController = TextEditingController();
  var byCodetextEditingController = TextEditingController().obs;
  var byCodeQtytextEditingController = TextEditingController();
  String? selectedBrand;
  Item? selectedItem;
  var indBarcodevalid = false.obs;

  CountUser countUser = CountUser();
  var adding = true.obs;
  var totalQty = 0.obs;
  List<Item> items = [];
  List<String?> brands = [];
  List<Item?> itemCodes = [];
  List<String> barcodesList = [];
  CountSetting countSetting = CountSetting();
  List<UserMaster> users = [];
  List<RackMaster> rackMaster = [];
  List<String> rack = [];
  List<String?> bayNo = [];
  List<String?> levelNo = [];
  var rackNumberController = TextEditingController().obs;
  String? rackNumber;
  Item? lastItem;
  Item? itemFromSearch;

  List<TempCount> scannedBarcodes = [];
  final player = AudioPlayer();
  final String errorSound = "sound/wrong_barcode_1.wav";
  final String okSound = "sound/wrong_barcode_1.wav";

  //
  Future<void> setSettings({Item? item}) async {
    //item from items view is coming here
    // instead of checking count user, check for temp count length
    log(item.toString());
    if (item != null) {
      itemFromSearch = item;
      individualtextEditingController.value.text = itemFromSearch!.barcode!;
      lastItem = itemFromSearch;
    }

    int tempLength =
        await DBHelper.getTableLength(tableName: DBHelper.tempCountTable);
    if (tempLength <= 0) {
      var settingsFromDB =
          await DBHelper.getAllItems(tableName: DBHelper.countSettingsTable);
      List<CountSetting> countSettings =
          settingsFromDB.map((e) => CountSetting.fromJson(e)).toList();
      countSetting = countSettings.first;
      var usersFromDB =
          await DBHelper.getAllItems(tableName: DBHelper.usersTable);
      users = usersFromDB.map((e) => UserMaster.fromJson(e)).toList();
      var rackFromDB =
          await DBHelper.getAllItems(tableName: DBHelper.rackTable);
      rackMaster = rackFromDB.map((e) => RackMaster.fromJson(e)).toList();
      countUser = CountUser();
      rackNumberController.value.text = "";
      rack.clear();
      bayNo.clear();
      levelNo.clear();
      Get.toNamed(RouteLinks.count);
    } else {
      // log(countUserFromDB.toString());
      var countUserFromDB =
          await DBHelper.getAllItems(tableName: DBHelper.countUserTable);
      countUser = countUserFromDB
          .map((json) => CountUser.fromJson(json))
          .toList()
          .first;
      await getCountItems();
      await getItems();
      log(countUser.toJson().toString());
      Get.toNamed(RouteLinks.counting);
    }
  }

  Future<void> getCountItems() async {
    var countItemsFromDB =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountTable);
    log(countItemsFromDB.toString());
    List<TempCount> finalItem =
        countItemsFromDB.map((e) => TempCount.fromJson(e)).toList();
    scannedBarcodes = finalItem.reversed.toList();
    // log(finalItem.toString());
    adding.value = true;
    await getSumOfQty();
    update();
  }

  Future<void> getItems() async {
    var itemsFromDB = await DBHelper.getAllItems(tableName: DBHelper.partTable);
    // log(itemsFromDB.toString());
    items = itemsFromDB.map((e) => Item.fromJson(e)).toList();
    brands = items.map((e) => e.brand).toSet().toList();
    brands.sort();
    onSelectBrand(brand: brands.first!);
    //log(brands.toString());
  }

  void createRack({required UserMaster value}) {
    countUser.user = value;
    rack = rackMaster.map((e) => e.rackNo!).toSet().toList();
    // bayNo.clear();
    // levelNo.clear();
    // rackNumberController.value.text = "";
    update();
  }

  void createBay({required String rack}) {
    countUser.rack = rack;
    List<String?> bayNumbers = rackMaster
        .where((rackMaster) => rackMaster.rackNo == rack)
        .map((rackMaster) => rackMaster.bayNo)
        .toSet()
        .toList();
    log(bayNumbers.toString());
    bayNo.clear();
    countUser.bay = null;
    countUser.level = null;
    levelNo.clear();
    rackNumberController.value.text = "";
    bayNo = bayNumbers;
    update();
  }

  void createlevel({required String bay}) {
    countUser.bay = bay;
    List<String?> levelNumbers = rackMaster
        .where((rackMaster) =>
            rackMaster.rackNo == countUser.rack && rackMaster.bayNo == bay)
        .map((rackMaster) => rackMaster.levelNo)
        .toSet()
        .toList();
    log(levelNumbers.toString());
    levelNo.clear();
    rackNumberController.value.text = "";
    countUser.level = null;
    levelNo = levelNumbers;
    update();
  }

  void createRackNumber({required String value}) {
    countUser.level = value;
    rackNumberController.value.text =
        "${countUser.rack}-${countUser.bay}-${countUser.level}";
    update();
  }

  void createCountUser() async {
    log(countUser.toString());
    if (rackNumber == rackNumberController.value.text) {
      log("same");
      CustomWidgets.customDialogue(
        title: "Same Rack?",
        subTitle: "Are you sure you want to update to same rack??",
        onPressed: () async {
          Get.back();
          await createRackUser();
        },
      );
    } else {
      log("diffrent");
      await createRackUser();
    }
  }

  Future<void> createRackUser() async {
    var data = countUser.toJson();
    await DBHelper.deleteAllItem(tableName: DBHelper.countUserTable);
    var result = await DBHelper.insertItem(
        tableName: DBHelper.countUserTable, data: data);
    if (result > 0) {
      await getItems();
      rackNumber = rackNumberController.value.text;
      textEditingController.clear();
      individualtextEditingController.value.clear();
      individualQtytextEditingController.clear();
      byCodeQtytextEditingController.clear();
      selectedItem = null;
      lastItem = null;
      Get.toNamed(RouteLinks.counting);
    } else {}
  }

  void onSelectBrand({required String brand}) {
    selectedItem = null;
    byCodetextEditingController.value.clear();
    selectedBrand = brand;
    itemCodes = items.where((element) => element.brand == brand).toList();
    update();
  }

  List<Item?> getSuggestions(String query) {
    List<Item?> matches = <Item>[];
    matches.addAll(itemCodes);
    matches.retainWhere(
        (s) => s!.itemCode!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void onSelectItem({required Item item}) {
    lastItem = item;
    byCodetextEditingController.value.text = item.itemCode!;
    update();
    selectedItem = item;
  }

  void onByCodeSave() {
    if (selectedBrand == null) {
      Get.dialog(const WrongBarcodeAlert(
        content: "Select a brand first.",
      ));
    } else if (selectedItem == null) {
      Get.dialog(const WrongBarcodeAlert(
        content: "Select an item.",
      ));
    } else if (byCodeQtytextEditingController.text == "" ||
        byCodeQtytextEditingController.text.isEmpty ||
        int.tryParse(byCodeQtytextEditingController.text) is! int ||
        int.tryParse(byCodeQtytextEditingController.text)! <= 0) {
      Get.dialog(const WrongBarcodeAlert(
        content: "Enter valid quantity",
      ));
    } else {
      onByCodeBarcode(
          item: selectedItem!,
          qty: int.tryParse(byCodeQtytextEditingController.text)!);
    }
  }

  void onByCodeBarcode({required Item item, required int qty}) async {
    log(item.toString());
    log(qty.toString());
    TempCount tempCount = TempCount(
      partCode: item.itemCode!,
      barcode: item.barcode!,
      qty: adding.value ? qty : -qty,
      rackNo: "${countUser.rack}-${countUser.bay}-${countUser.level}",
      userCode: "${countUser.user?.userCd}",
    );
    //log(tempCount.toString());
    await DBHelper.insertItem(
        tableName: DBHelper.tempCountTable, data: tempCount.toJson());
    // log(toTable.toString());
    var itemFromTable =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountTable);
    List<TempCount> finalItem =
        itemFromTable.map((e) => TempCount.fromJson(e)).toList();
    scannedBarcodes = finalItem.reversed.toList();
    selectedItem = null;
    byCodeQtytextEditingController.text = "";
    byCodetextEditingController.value.clear();
    adding.value = true;
    await getSumOfQty();
    update();
  }

  void addingRemoving(bool value) {
    adding.value = value;
  }

  // Continues Barcode Read

  Future<void> onBarcodeReadContinues(String value) async {
    value = value.replaceAll('^', '');
    log(value);
    Item? readItem;
    readItem = items.firstWhereOrNull((element) => element.barcode == value);
    if (readItem != null) {
      log(readItem.toString());
      lastItem = readItem;
      update();
      try {
        TempCount tempCount = TempCount(
          partCode: readItem.itemCode!,
          barcode: readItem.barcode!,
          qty: adding.value ? 1 : -1,
          rackNo: "${countUser.rack}-${countUser.bay}-${countUser.level}",
          userCode: "${countUser.user?.userCd}",
        );
        log(tempCount.toString());
        await DBHelper.insertItem(
            tableName: DBHelper.tempCountTable, data: tempCount.toJson());
        // log(toTable.toString());
        var itemFromTable =
            await DBHelper.getAllItems(tableName: DBHelper.tempCountTable);
        List<TempCount> finalItem =
            itemFromTable.map((e) => TempCount.fromJson(e)).toList();
        scannedBarcodes = finalItem.reversed.toList();
        // log(finalItem.toString());
        adding.value = true;
        await getSumOfQty();
        update();
      } catch (e) {
        Get.dialog(const WrongBarcodeAlert(
          title: "Error!!",
          content: "Error reading barcode, try again",
        ));
      }
    } else {
      lastItem = Item(barcode: value, itemName: "Item Not Found");
      update();
      log("invalid barcode");
      soundAndVibrate(error: true);
      Get.dialog(const WrongBarcodeAlert());
    }
    await Future.delayed(const Duration(milliseconds: 300))
        .then((value) => textEditingController.clear());
    // log(scannedBarcodes.toString());
  }

  void clearText() async {
    individualtextEditingController.value.clear();
    update();
  }

  void soundAndVibrate({required bool error}) async {
    player.play(AssetSource(error ? errorSound : okSound), volume: 1);
    // if (await Vibration.hasVibrator()) {
    error ? Vibration.vibrate() : null;
    // }
  }

// on individual Barcode read
  void onIndividualBarcodeUpdate() async {
    Item? readItem;
    readItem = items.firstWhereOrNull((element) =>
        element.barcode ==
        individualtextEditingController.value.text.replaceAll('^', ""));
    if (readItem != null) {
      log(readItem.toString());
      try {
        TempCount tempCount = TempCount(
          partCode: readItem.itemCode!,
          barcode: readItem.barcode!,
          qty: adding.value
              ? int.tryParse(individualQtytextEditingController.text)!
              : -int.tryParse(individualQtytextEditingController.text)!,
          rackNo: "${countUser.rack}-${countUser.bay}-${countUser.level}",
          userCode: "${countUser.user?.userCd}",
        );
        log(tempCount.toString());
        var toTable = await DBHelper.insertItem(
            tableName: DBHelper.tempCountTable, data: tempCount.toJson());
        log(toTable.toString());
        var itemFromTable =
            await DBHelper.getAllItems(tableName: DBHelper.tempCountTable);
        List<TempCount> finalItem =
            itemFromTable.map((e) => TempCount.fromJson(e)).toList();
        scannedBarcodes = finalItem.reversed.toList();
        log(finalItem.toString());
        adding.value = true;
        await getSumOfQty();

        update();
      } catch (e) {
        Get.dialog(const WrongBarcodeAlert(
          title: "Error!!",
          content: "Error reading barcode, try again",
        ));
      }
    } else {
      log("invalid barcode");
      Get.dialog(const WrongBarcodeAlert());
    }
    individualQtytextEditingController.clear();
    individualtextEditingController.value.clear();
    indBarcodevalid.value = false;
    itemFromSearch = null;
  }

  Future<bool> onIndividualBarcodeRead(String value) async {
    value = value.replaceAll('^', '');
    individualtextEditingController.value.text = value;
    Item? readItem;
    readItem = items.firstWhereOrNull((element) => element.barcode == value);
    if (readItem != null) {
      lastItem = readItem;
      indBarcodevalid.value = true;
      update();
      return true;
    } else {
      indBarcodevalid.value = false;
      // soundAndVibrate(error: true);
      // Get.dialog(const WrongBarcodeAlert());
      return false;
    }
  }

  Future<void> onIndividualBarcodeSave() async {
    log(individualQtytextEditingController.text);
    if (!await onIndividualBarcodeRead(
            individualtextEditingController.value.text) ||
        individualQtytextEditingController.text == "") {
      log("not validated");
      soundAndVibrate(error: true);
      Get.dialog(const WrongBarcodeAlert(
        content: "Wrong Barcode!!!",
      ));
    } else if (!(int.tryParse(individualQtytextEditingController.text)! > 0)) {
      log("not validated qty");
      soundAndVibrate(error: true);
      Get.dialog(const WrongBarcodeAlert(
        content: "Not a valid quantity",
      ));
    } else {
      log("valid barcode and qty");
      onIndividualBarcodeUpdate();
    }
  }

  //clear count from temp count table
  Future<void> clearCount() async {
    var tempCount =
        await DBHelper.getTableLength(tableName: DBHelper.tempCountTable);
    if (tempCount <= 0) {
      log("no items to clear. Delete User");
      CustomWidgets.customDialogue(
        title: "No Count!!",
        subTitle: "No count in table. Do you want to change User/Rack??",
        onPressed: () async {
          Get.back();
          await clearUser().then((value) {
            if (value != -1) {
              lastItem = null;
              Get.back();
            }
          });
        },
      );
    } else {
      log("items found to clear. Delete User");
      CustomWidgets.customDialogue(
        title: "Clear Count??",
        subTitle: "Are you sure to clear the count? This is not reversible!!",
        onPressed: () async {
          Get.back();
          var result =
              await DBHelper.deleteAllItem(tableName: DBHelper.tempCountTable);
          if (result != -1) {
            scannedBarcodes.clear();
            lastItem = null;
            await getSumOfQty();
          }
          update();
        },
      );
    }
  }

  Future<int> clearUser() async {
    var result =
        await DBHelper.deleteAllItem(tableName: DBHelper.countUserTable);
    // if (result != -1) {
    //   Get.back();
    // }
    return result;
  }

  // go back or not

  Future<bool> goBack() async {
    var tempCount =
        await DBHelper.getTableLength(tableName: DBHelper.tempCountTable);
    bool? shouldClose;
    if (tempCount <= 0) {
      Get.back();
    } else {
      Get.back();
      Get.back();

      // shouldClose = await CustomWidgets.customDialogue(
      //   title: "Are you sure??",
      //   subTitle:
      //       "There are items counted. If you go back, this will be cleared. This is not reversible!!!",
      //   onPressed: () async {
      //     var result =
      //         await DBHelper.deleteAllItem(tableName: DBHelper.tempCountTable);
      //     if (result != -1) {
      //       scannedBarcodes.clear();
      //       await getSumOfQty();
      //     }
      //     Get.back(result: true);
      //   },
      //   onPressedBack: () => Get.back(result: false),
      // );
    }
    return true;
  }

  // update counts to temp count

  Future<void> updateTempCount() async {
    // await DBHelper.deleteAllItem(tableName: DBHelper.phyDetailTable);
    // await DBHelper.deleteAllItem(tableName: DBHelper.tempCountBackTable);
    var itemFromTable =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountTable);
    if (itemFromTable.isEmpty) {
      log("no items in temp count");
      Get.dialog(const WrongBarcodeAlert(
        title: "No Count Yet",
        content: "Add items before updating",
      ));
      update();
    } else {
      CustomWidgets.customDialogue(
          title: "Update Count",
          subTitle:
              "Are you sure to update the count of ${countUser.rack}-${countUser.bay}-${countUser.level}? This is not reversible!!",
          onPressed: () async {
            await onUpdateTempCount(itemFromTable);
          });
    }
  }

  Future<void> onUpdateTempCount(
      List<Map<String, dynamic>> itemFromTable) async {
    String formatedDate = getFormattedDate(DateTime.now());
    itemFromTable =
        itemFromTable.map((e) => {...e, "Dt": formatedDate}).toList();
    // log(itemFromTable.toString());
    var result1 = await DBHelper.bulkInsert(
        tableName: DBHelper.tempCountBackTable, items: itemFromTable);
    log(result1.toString());
    var query =
        '''SELECT ${DBHelper.partCodeTempCount}, SUM(${DBHelper.qtyTempCount}) AS Qty
    FROM ${DBHelper.tempCountTable}  
    GROUP BY ${DBHelper.partCodeTempCount};''';
    var toPhyDetail = await DBHelper.getItemsByRawQuery(query);
    log(toPhyDetail.toString());
    // here update/insert phyqty count.
    var result3 =
        await DBHelper.getAllItems(tableName: DBHelper.phyDetailTable);
    log(result3.toString());

    var result2 = await DBHelper.bulkInsertOrUpdate(
        tableName: DBHelper.phyDetailTable,
        conditionColumn: DBHelper.partCodePhyDetail,
        newDataList: toPhyDetail);
    log(result2.toString());
    var phyDetailsTable =
        await DBHelper.getAllItems(tableName: DBHelper.phyDetailTable);
    log(phyDetailsTable.toString());
    if (result1.isNotEmpty && result2.isNotEmpty) {
      await DBHelper.deleteAllItem(tableName: DBHelper.tempCountTable);
      scannedBarcodes.clear();
      lastItem = Item(itemName: "");
      await getSumOfQty();
      await clearUser();
      Get.back();
      Get.back();
      update();
      CustomWidgets.customSnackBar(
        title: "Updated",
        message:
            "Items updated to ${countUser.rack}-${countUser.bay}-${countUser.level}",
        textColor: Colors.green,
      );
    } else {
      Get.back();
      CustomWidgets.customSnackBar(
        title: "Not Updated",
        message:
            "Items are not updated to ${countUser.rack}-${countUser.bay}-${countUser.level}. Try Again",
        textColor: Colors.green,
      );
    }
  }

  String getFormattedDate(DateTime dateTime) {
    try {
      String formattedDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
      return formattedDate;
    } catch (e) {
      //log(e.toString());
      return "";
    }
  }

  Future<void> getSumOfQty() async {
    // Use the rawQuery method to execute a SQL query
    List<Map<String, dynamic>> result = await DBHelper.getItemsByRawQuery(
        'SELECT SUM(${DBHelper.qtyTempCount}) as totalQty FROM ${DBHelper.tempCountTable}');

    // Extract the sum from the result
    int sum = result.isNotEmpty ? result.first['totalQty'] ?? 0 : 0;

    totalQty.value = sum;
  }
}

class WrongBarcodeAlert extends StatelessWidget {
  final String? title;
  final String? content;
  const WrongBarcodeAlert({
    super.key,
    this.content,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Barcode Error!!!"),
      content: Text(content ?? "Wrong Barcode"),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(double.infinity, 40),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text("close"),
              ),
            ),
          ],
        )
      ],
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
