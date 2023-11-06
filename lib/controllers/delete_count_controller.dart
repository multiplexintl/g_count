import 'dart:developer';

import 'package:g_count/db/db_helper.dart';
import 'package:g_count/models/temp_count.dart';
import 'package:get/get.dart';

class DeleteCountController extends GetxController {
  @override
  void onInit() {
    getRacks();
    super.onInit();
  }

  var selectedRackItems = [];
  String? selectedRack;
  List<String>? racks = [];
  List<TempCount>? tempCountItems = [];

  void getRacks() async {
    var result2 =
        await DBHelper.getAllItems(tableName: DBHelper.tempCountBackTable);
    tempCountItems = result2.map((e) => TempCount.fromJson(e)).toList();
    racks = tempCountItems?.map((e) => e.rackNo).toSet().toList();
    racks?.sort();
    update();
    // log(racks.toString());
  }

  void selectRack({required String rack}) async {
    selectedRack = rack;
    selectedRackItems = tempCountItems!
        .where((element) => element.rackNo == selectedRack)
        .toList();
    update();
  }

  void clear() async {
    selectedRackItems.clear();
    selectedRack = null;
    update();
  }

  void deleteCount() async {
    var result = await DBHelper.getAllItems(tableName: DBHelper.phyDetailTable);
    log(result.toString());
    log(selectedRackItems.toString());
  }
}
