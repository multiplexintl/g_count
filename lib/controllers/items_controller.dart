import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/count_controller.dart';
import 'package:g_count/models/item.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

import '../db/db_helper.dart';

class ItemsController extends GetxController {
  CountController countCon = Get.find<CountController>();
  List<Item> totalItems = [];
  var selectedItem = Item().obs;
  List<String?> brands = [];
  String? selectedBrand;
  List<Item> selectedItems = [];
  List<Item> viewItems = [];
  ScrollController textFieldScrollController = ScrollController();
  TextEditingController codeController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var searchController = TextEditingController().obs;

  @override
  void onInit() async {
    getItems();
    super.onInit();
  }

  Future<void> getItems() async {
    var itemsFromDB = await DBHelper.getAllItems(tableName: DBHelper.partTable);
    totalItems = itemsFromDB.map((e) => Item.fromJson(e)).toList();
    brands = totalItems.map((e) => e.brand).toSet().toList();
    brands.sort();
  }

  Future<void> selectAnItem(Item item) async {
    selectedItem.value = item;
    codeController.text = selectedItem.value.itemCode!;
    barcodeController.text = selectedItem.value.barcode!;
    nameController.text = selectedItem.value.itemName!;
  }

  void getItemsByBrand(String brand) async {
    if (selectedBrand != brand) {
      codeController.clear();
      barcodeController.clear();
      nameController.clear();
    }
    selectedBrand = brand;
    selectedItems =
        totalItems.where((element) => element.brand == brand).toList();
    viewItems = selectedItems;
    selectedItem.value = Item();
    update();
  }

  // Search

  Future<void> search() async {
    selectedItem.value = Item();
    codeController.clear();
    barcodeController.clear();
    nameController.clear();
    log(selectedItems.length.toString());
    if (selectedBrand == null || selectedBrand == "") {
      CustomWidgets.customSnackBar(
          title: "No Brand",
          message: "Please select a brand first",
          textColor: Colors.red);
    } else {
      viewItems = searchItems(searchController.value.text.toLowerCase());
      log(viewItems.length.toString());
      update();
    }
  }

  Future<void> clear() async {
    searchController.value.text =
        searchController.value.text.replaceAll('^', '');
  }

  List<Item> searchItems(String searchTerm) {
    List<String> searchTerms = searchTerm.toLowerCase().split(' ');
    return selectedItems.where((item) {
      // Check if all search terms are present in any of the fields
      return searchTerms.every((term) =>
          item.itemCode!.toLowerCase().contains(term) ||
          item.itemName!.toLowerCase().contains(term) ||
          item.barcode!.toLowerCase().contains(term));
    }).toList();
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
