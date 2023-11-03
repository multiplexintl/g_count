import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/items_controller.dart';
import 'package:g_count/models/item.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<ItemsController>();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomWidgets.customAppBar("Items", back: true),
        //  resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
            color: Colors.blue,
            alignment: Alignment.center,
            height: 40,
            child: GetBuilder<ItemsController>(
              builder: (con) {
                return Text(
                  "No. Selected Items: ${con.selectedItems.length}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.merge(const TextStyle(fontWeight: FontWeight.w500)),
                );
              },
            )),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 0),
          child: Column(
            children: [
              //brand row
              Row(
                children: [
                  Text(
                    "Brand:  ",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.merge(const TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: CustomWidgets().dropDownInputDecoration(),
                        value: con.selectedBrand,
                        items: con.brands.map((String? items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          con.getItemsByBrand(value!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CustomWidgets.gap(h: 10),
              // code, barcode
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Code",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.merge(const TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        TextFormField(
                          enabled: false,
                          controller: con.codeController,
                          decoration: CustomWidgets().dropDownInputDecoration(),
                        ),
                      ],
                    ),
                  ),
                  CustomWidgets.gap(
                    w: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Barcode",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.merge(const TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        TextFormField(
                          enabled: false,
                          controller: con.barcodeController,
                          decoration: CustomWidgets().dropDownInputDecoration(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // name and next button
              CustomWidgets.gap(h: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: Theme.of(context).textTheme.titleMedium?.merge(
                                const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                        Scrollbar(
                          controller: con.textFieldScrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          child: TextFormField(
                            enabled: false,
                            scrollController: con.textFieldScrollController,
                            controller: con.nameController,
                            minLines: 3,
                            maxLines: 3,
                            decoration:
                                CustomWidgets().dropDownInputDecoration(),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomWidgets.gap(w: 10),
                  SizedBox(
                    height: 36,
                    width: 80,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          fixedSize: const Size(100, 48)),
                      onPressed: () {
                        CustomWidgets.customDialogue(
                          title: "Are you sure?",
                          subTitle:
                              "You have selected ${con.selectedItem.value.barcode} | ${con.selectedItem.value.itemName} | ${con.selectedItem.value.brand}",
                          onPressed: () {
                            Get.back();
                            con.gotoCount();
                          },
                        );
                      },
                      child: const Icon(
                        Icons.forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              CustomWidgets.gap(h: 10),
              GetBuilder<ItemsController>(
                builder: (con) {
                  return CommonTableWdiget(
                    items: con.viewItems,
                    con: con,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: SizedBox(
                        height: 36,
                        child: GetBuilder<ItemsController>(
                          builder: (con) {
                            return TextFormField(
                              controller: con.searchController.value,
                              enabled: con.selectedItems.isNotEmpty,
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? ""
                                    : null;
                              },
                              onChanged: (value) {
                                if (value.contains('^')) {
                                  con.clear();
                                }
                              },
                              onEditingComplete: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (formKey.currentState!.validate()) {
                                  con.search();
                                }
                              },
                              decoration: CustomWidgets()
                                  .dropDownInputDecoration()
                                  .copyWith(
                                      contentPadding: const EdgeInsets.all(10),
                                      errorStyle: const TextStyle(
                                        height: 0,
                                      )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  CustomWidgets.gap(w: 15),
                  SizedBox(
                      height: 36,
                      width: 80,
                      child: GetBuilder<ItemsController>(
                        builder: (con) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                fixedSize: const Size(100, 36)),
                            onPressed: con.selectedItems.isEmpty
                                ? null
                                : () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (formKey.currentState!.validate()) {
                                      con.search();
                                    }
                                  },
                            child: const Text("Search"),
                          );
                        },
                      )),
                ],
              ),
              CustomWidgets.gap(h: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonTableWdiget extends StatelessWidget {
  const CommonTableWdiget({
    super.key,
    required this.items,
    required this.con,
  });

  final List<Item> items;
  final ItemsController con;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
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
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Barcode | Item Code\nDescription",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: SizedBox(
                    height: 263,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return InkWell(
                          onTap: () {
                            con.selectAnItem(item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: index.isEven
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.blueGrey[100],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: (index == items.length - 1)
                                        ? const Radius.circular(10)
                                        : const Radius.circular(0),
                                    bottomRight: (index == items.length - 1)
                                        ? const Radius.circular(10)
                                        : const Radius.circular(0),
                                  )),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      height: 50,
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
                                      child: Text("${index + 1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                  Expanded(
                                    child: Container(
                                      // height: 60,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                          "${item.barcode!} | ${item.itemCode!}\n${item.itemName}",
                                          overflow: TextOverflow.visible,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomWidgets.gap(h: 10),
        ],
      ),
    );
  }
}
