import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/admin_controller.dart';
import 'package:g_count/controllers/count_controller.dart';
import 'package:g_count/models/count_user.dart';
import 'package:g_count/models/item.dart';
import 'package:g_count/routes.dart';
import 'package:get/get.dart';

import '../db/db_helper.dart';

class ItemsController extends GetxController {
  CountController countCon = Get.find<CountController>();
  List<Item> totalItems = [];
  var selectedItem = Item().obs;
  List<String?> brands = [];
  String? selectedBrand;
  List<Item> selectedItems = [];
  ScrollController textFieldScrollController = ScrollController();
  TextEditingController codeController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void onInit() async {
    getItems();
    super.onInit();
  }

  Future<void> getItems() async {
    var itemsFromDB = await DBHelper.getAllItems(tableName: DBHelper.partTable);
    totalItems = itemsFromDB.map((e) => Item.fromJson(e)).toList();
    brands = totalItems.map((e) => e.brand).toSet().toList();
  }

  Future<void> selectAnItem(Item item) async {
    selectedItem.value = item;
    codeController.text = selectedItem.value.itemCode!;
    barcodeController.text = selectedItem.value.barcode!;
    nameController.text = selectedItem.value.itemName!;
  }

  void getItemsByBrand(String brand) async {
    selectedBrand = brand;
    selectedItems =
        totalItems.where((element) => element.brand == brand).toList();
    update();
  }

  void gotoCount() async {
    log(selectedItem.value.toString());
    countCon.setSettings(item: selectedItem.value);
    // var countUser =
    //     await DBHelper.getAllItems(tableName: DBHelper.countUserTable);
    // log(countUser.toString());
    // if (countUser.isEmpty) {
    //   // got to counting view
    //   Get.toNamed(RouteLinks.count, arguments: selectedItem.value);
    // } else {
    //   Get.toNamed(RouteLinks.counting, arguments: selectedItem.value);
    // }
  }
}
