import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

import 'package:g_count/controllers/count_controller.dart';
import 'package:g_count/helpers/app_config.dart';
import 'package:g_count/models/item.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import '../widgets/text_with_controller.dart';

class CountingPage extends StatelessWidget {
  const CountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    //  int selectedIndex = -1;
    var countCon = Get.put(CountController());
    InputWithKeyboardControlFocusNode barcodeFocusNode =
        InputWithKeyboardControlFocusNode();
    InputWithKeyboardControlFocusNode continuesBarcodeFocusNode =
        InputWithKeyboardControlFocusNode();
    InputWithKeyboardControlFocusNode byCodeBarcodeFocusNode =
        InputWithKeyboardControlFocusNode();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          return countCon.goBack();
        },
        child: Scaffold(
          appBar: CustomWidgets.customAppBar("Start Counting", back: true),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: ButtonRowWidget(
              onPressedClear: () async {
                await countCon.clearCount();
              },
              onPressedUpdate: () async {
                await countCon.updateTempCount();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 5),
            child: DefaultTabController(
              length: 3,
              initialIndex: Get.arguments != null ? 1 : 0,
              child: Column(
                children: [
                  ButtonsTabBar(
                    onTap: (p0) async {
                      if (p0 == 0) {
                        continuesBarcodeFocusNode.requestFocus();
                      }
                      if (p0 == 1) {
                        barcodeFocusNode.requestFocus();
                      }
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    backgroundColor: Colors.grey.shade400,
                    unselectedBackgroundColor: Colors.white,
                    unselectedLabelStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    height: 60,
                    tabs: const [
                      Tab(
                        child: TabButtonWidget(
                          title: "Continues",
                          color: Colors.green,
                        ),
                      ),
                      Tab(
                        child: TabButtonWidget(
                          title: "Individual",
                          color: Colors.amber,
                        ),
                      ),
                      Tab(
                        child: TabButtonWidget(
                          title: "By Code",
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      ContinuesWidget(
                        con: countCon,
                        continuesBarcodeFocusNode: continuesBarcodeFocusNode,
                      ),
                      IndividualWidget(
                        con: countCon,
                        barcodeFocusNode: barcodeFocusNode,
                      ),
                      ByCodeWidget(
                        con: countCon,
                        barcodeFocusNode: byCodeBarcodeFocusNode,
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ByCodeWidget extends StatelessWidget {
  final CountController con;
  final InputWithKeyboardControlFocusNode barcodeFocusNode;
  const ByCodeWidget({
    super.key,
    required this.con,
    required this.barcodeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhysicalModel(
          color: Colors.black,
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          shape: BoxShape.rectangle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.deepOrange.shade100,
            ),
            height: 170,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DropDownWithTitleWidget(
                          // items: con.brands,
                          items: con.brands.map((String? item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item!),
                            );
                          }).toList(),
                          title: "Brand",
                          dropdownvalue: con.selectedBrand,
                          onChanged: (value) {
                            con.onSelectBrand(brand: value!);
                          },
                        ),
                      ),
                      CustomWidgets.gap(w: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Qty"),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              controller: con.byCodeQtytextEditingController,
                              keyboardType: TextInputType.number,
                              focusNode: barcodeFocusNode,
                              onFieldSubmitted: (value) {
                                con.onByCodeSave();
                              },
                              decoration:
                                  CustomWidgets().dropDownInputDecoration(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GetBuilder<CountController>(
                          builder: (_) {
                            return DropDownWithTitleWidget(
                                // items: con.itemCodes,
                                items: con.itemCodes.map((Item? item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item!.itemCode!),
                                  );
                                }).toList(),
                                title: "Item Code",
                                dropdownvalue: con.selectedItem,
                                onChanged: (value) {
                                  con.onSelectItem(item: value);
                                  barcodeFocusNode.requestFocus();
                                });
                          },
                        ),
                      ),
                      CustomWidgets.gap(w: 10),
                      SizedBox(
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            con.onByCodeSave();
                          },
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 35,
                          width: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: con.adding.value
                                  ? Colors.red
                                  : Colors.transparent,
                              foregroundColor: con.adding.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              con.addingRemoving(true);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Icon(
                            con.adding.value ? Icons.add : Icons.remove,
                            color: Colors.green,
                            size: 15,
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          width: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: con.adding.value == false
                                  ? Colors.red
                                  : Colors.transparent,
                              foregroundColor: con.adding.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              con.addingRemoving(false);
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 20,
                            ),
                          ),
                        ),
                        CustomWidgets.gap(w: 5),
                        Text(
                          "${con.countUser.rack}-${con.countUser.bay}-${con.countUser.level}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.merge(const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        CustomWidgets.gap(w: 5),
                        Text(
                          "${con.totalQty}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.merge(const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        GetBuilder<CountController>(
          builder: (con) {
            return CommonTableWdiget(con: con);
          },
        ),
      ],
    );
  }
}

class DropDownWithTitleWidget extends StatelessWidget {
  const DropDownWithTitleWidget({
    super.key,
    required this.items,
    required this.title,
    required this.dropdownvalue,
    required this.onChanged,
  });

  final String title;
  // final List<String?>? items;
  final List<DropdownMenuItem<dynamic>>? items;
  final dynamic dropdownvalue;
  final void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(
                fontWeight: FontWeight.w500,
              )),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<dynamic>(
            decoration: CustomWidgets().dropDownInputDecoration(),
            value: dropdownvalue,
            items: items,
            // items: items?.map((String? items) {
            //   return DropdownMenuItem(
            //     value: items,
            //     child: Text(items!),
            //   );
            // }).toList(),
            onChanged: onChanged,
          ),
        ),
        // CustomWidgets.gap(h: 5)
      ],
    );
  }
}

class IndividualWidget extends StatelessWidget {
  final CountController con;
  final InputWithKeyboardControlFocusNode barcodeFocusNode;
  const IndividualWidget({
    super.key,
    required this.con,
    required this.barcodeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    FocusNode qtyFocusNode = FocusNode();
    Item? itemFromSearch = Get.arguments;
    log(itemFromSearch.toString());
    if (itemFromSearch != null) {
      con.individualtextEditingController.clear();
      con.individualtextEditingController.text = "${itemFromSearch.barcode!}^";
      qtyFocusNode.requestFocus();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhysicalModel(
          color: Colors.black,
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          shape: BoxShape.rectangle,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.amber.shade100,
            ),
            padding: const EdgeInsets.all(8),
            height: 125,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Barcode"),
                              InputWithKeyboardControl(
                                controller: con.individualtextEditingController,
                                focusNode: barcodeFocusNode,
                                width: 300,
                                showButton: true,
                                startShowKeyboard: false,
                                style: Theme.of(context).textTheme.bodyMedium!,
                                autofocus: true,
                                onChanged: (p0) {
                                  if (p0.contains("^")) {
                                    con
                                        .onIndividualBarcodeRead(p0)
                                        .then((value) {
                                      if (value) {
                                        qtyFocusNode.requestFocus();
                                      } else {
                                        con.individualtextEditingController
                                            .clear();
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        CustomWidgets.gap(w: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Qty"),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                controller:
                                    con.individualQtytextEditingController,
                                focusNode: qtyFocusNode,
                                keyboardType: TextInputType.number,
                                decoration:
                                    CustomWidgets().dropDownInputDecoration(),
                                onFieldSubmitted: (p0) {
                                  con.onIndividualBarcodeSave().then((value) =>
                                      barcodeFocusNode.requestFocus());
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomWidgets.gap(w: 10),
                        SizedBox(
                          height: 40,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              con.onIndividualBarcodeSave().then(
                                  (value) => barcodeFocusNode.requestFocus());
                            },
                            child: Text(
                              "Save",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomWidgets.gap(h: 10),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: con.adding.value
                                    ? Colors.red
                                    : Colors.transparent,
                                foregroundColor: con.adding.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                con.addingRemoving(true);
                              },
                              child: const Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Icon(
                              con.adding.value ? Icons.add : Icons.remove,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: con.adding.value == false
                                    ? Colors.red
                                    : Colors.transparent,
                                foregroundColor: con.adding.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                con.addingRemoving(false);
                              },
                              child: const Icon(
                                Icons.remove,
                                size: 20,
                              ),
                            ),
                          ),
                          CustomWidgets.gap(w: 5),
                          Text(
                            "${con.countUser.rack}-${con.countUser.bay}-${con.countUser.level}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.merge(const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                          CustomWidgets.gap(w: 5),
                          Text(
                            "${con.totalQty.value}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.merge(const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        GetBuilder<CountController>(
          builder: (con) {
            return CommonTableWdiget(con: con);
          },
        ),
      ],
    );
  }
}

class LastItemWidget extends StatelessWidget {
  final Item? countItem;
  const LastItemWidget({
    super.key,
    this.countItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      // height: 40,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Wrap(
        children: [
          Text(
            "Last Item :",
            style:
                Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          if (countItem != null)
            Text(
              " ${countItem?.itemName}",
              // "kabvkljansvkjnkjvnkjdfnvkjsdfkjvjksdbfvkjsdfjkvkdsfbvjkdbfvhjbsdhfbvjhsdbfvhjbdfhvjhdsbfvhjbsdfhvbjhdsfbvjhsdbfvjhbsdjfhvbjhdsbfvjsdbfvjb",
              overflow: TextOverflow.clip,
            )
        ],
      ),
    );
  }
}

class ContinuesWidget extends StatelessWidget {
  final CountController con;
  final InputWithKeyboardControlFocusNode continuesBarcodeFocusNode;
  const ContinuesWidget({
    super.key,
    required this.con,
    required this.continuesBarcodeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhysicalModel(
          color: Colors.black,
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          shape: BoxShape.rectangle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.green.shade100,
            ),
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Barcode"),
                      InputWithKeyboardControl(
                        controller: con.textEditingController,
                        focusNode: continuesBarcodeFocusNode,
                        width: 300,
                        showButton: false,
                        startShowKeyboard: false,
                        style: Theme.of(context).textTheme.bodyMedium!,
                        autofocus: true,
                        onChanged: (p0) {
                          con.onBarcodeReadContinues(p0);
                        },
                      ),
                      Obx(
                        () => Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: con.adding.value
                                    ? Colors.red
                                    : Colors.transparent,
                                foregroundColor: con.adding.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                con.addingRemoving(true);
                              },
                              child: const Icon(Icons.add),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Icon(
                                con.adding.value ? Icons.add : Icons.remove,
                                color: Colors.green,
                                size: 25,
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: con.adding.value == false
                                    ? Colors.red
                                    : Colors.transparent,
                                foregroundColor: con.adding.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                con.addingRemoving(false);
                              },
                              child: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${con.countUser.rack}-${con.countUser.bay}-${con.countUser.level}",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.merge(const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                      CustomWidgets.gap(h: 20),
                      Obx(() => Text(
                            "${con.totalQty.value}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.merge(const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                )),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        GetBuilder<CountController>(
          builder: (con) {
            return CommonTableWdiget(con: con);
          },
        )
      ],
    );
  }
}

class CommonTableWdiget extends StatelessWidget {
  const CommonTableWdiget({
    super.key,
    required this.con,
  });

  final CountController con;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          LastItemWidget(
            countItem: con.lastItem,
          ),
          // table
          Expanded(
            child: Column(
              children: [
                // Heading Container
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "SNo",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "Item Code",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "Barcode",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "Qty",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: con.scannedBarcodes.length,
                    itemBuilder: (context, index) {
                      var barcode = con.scannedBarcodes[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: index.isEven
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.blueGrey[100],
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    (index == con.scannedBarcodes.length - 1)
                                        ? const Radius.circular(10)
                                        : const Radius.circular(0),
                                bottomRight:
                                    (index == con.scannedBarcodes.length - 1)
                                        ? const Radius.circular(10)
                                        : const Radius.circular(0),
                              )),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text("${barcode.sno}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)),
                              Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(barcode.partCode,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                              Container(
                                  height: 40,
                                  width: 120,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(barcode.barcode)),
                              Expanded(
                                child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Text("${barcode.qty}")),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          )
        ],
      ),
    );
  }
}

class ButtonRowWidget extends StatelessWidget {
  final void Function() onPressedClear;
  final void Function() onPressedUpdate;
  const ButtonRowWidget({
    super.key,
    required this.onPressedClear,
    required this.onPressedUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: onPressedClear,
            child: const Text("Clear Count"),
          ),
        ),
        CustomWidgets.gap(w: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: onPressedUpdate,
            child: const Text("Update Count"),
          ),
        ),
      ],
    );
  }
}

// class TableWidget extends StatelessWidget {
//   final List<TempCount> count;

//   const TableWidget({
//     super.key,
//     required this.count,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       //  onSelectAll: (value) {},
//       columnSpacing: App().appWidth(5.8),
//       border: TableBorder.all(
//         color: Colors.black,
//       ),
//       checkboxHorizontalMargin: 5,
//       showCheckboxColumn: false,
//       dataRowMinHeight: 25,
//       dataRowMaxHeight: 25,
//       dataTextStyle: Theme.of(context).textTheme.labelSmall,
//       headingTextStyle: Theme.of(context)
//           .textTheme
//           .labelSmall
//           ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
//       dividerThickness: 2,
//       headingRowHeight: 30,
//       columns: const [
//         DataColumn(numeric: true, label: Text('SNO')),
//         DataColumn(label: Text('ItemCode')),
//         DataColumn(label: Text('Barcode')),
//         DataColumn(label: Text('Qty')),
//       ],
//       rows: [
//         ...List.generate(
//           count.length,
//           (index) => DataRow(cells: [
//             DataCell(
//               Text(
//                 "${count[index].sno}",
//               ),
//             ),
//             DataCell(
//               Text(
//                 count[index].partCode,
//               ),
//             ),
//             DataCell(Text(
//               count[index].barcode,
//             )),
//             DataCell(
//               Text(
//                 count[index].qty.toString(),
//               ),
//             ),
//           ]),
//         ),
//       ],
//     );
//   }
// }

class TabButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  const TabButtonWidget({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: App().appWidth(100 / 3.8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            )),
      ),
    );
  }
}
