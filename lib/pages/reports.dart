import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/report_controller.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

import '../controllers/count_controller.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<ReportController>();

    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    return Scaffold(
      appBar: CustomWidgets.customAppBar("Reports", back: true),
      bottomNavigationBar: const BottomBarWidget(),
      body: Column(
        children: [
          // summery, detail radio button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(
                  color: Color(0xFFDFCDCC),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Obx(() => RadioListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          value: 0,
                          groupValue: con.selectedRadio.value,
                          activeColor: Colors.green,
                          title: Text(
                            "Summery",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          onChanged: (val) {
                            con.setSelectedRadio(val!);
                          },
                        )),
                  ),
                  Expanded(
                    child: Obx(() => RadioListTile(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          value: 1,
                          groupValue: con.selectedRadio.value,
                          activeColor: Colors.green,
                          title: Text(
                            "Detail",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          onChanged: (val) {
                            con.setSelectedRadio(val!);
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ReportController>(
              builder: (con) {
                return PageView(
                  controller: con.pageController,
                  onPageChanged: (value) {
                    con.setSelectedRadio(value);
                  },
                  children: [
                    SizedBox(
                      child: CommonTableWdiget(con: con),
                    ),
                    DetailView(items: items),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Item",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      CustomWidgets.gap(w: 13),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration:
                                CustomWidgets().dropDownInputDecoration(),
                            value: null,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomWidgets.gap(h: 15),
                  Row(
                    children: [
                      Text(
                        "Rack",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      CustomWidgets.gap(w: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration:
                                CustomWidgets().dropDownInputDecoration(),
                            value: null,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomWidgets.gap(h: 15),
                  Row(
                    children: [
                      Text(
                        "User",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      CustomWidgets.gap(w: 13),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration:
                                CustomWidgets().dropDownInputDecoration(),
                            value: null,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              Container(
                height: 150,
                width: 100,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text("OK"),
                      ),
                    ),
                    CustomWidgets.gap(h: 20),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text("Clear")))
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class CommonTableWdiget extends StatelessWidget {
  const CommonTableWdiget({
    super.key,
    required this.con,
  });

  final ReportController con;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    "Rack",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    "User",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (con.scannedBarcodes.isEmpty)
            const Expanded(child: Center(child: Text("No Items Yet"))),
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
                          bottomLeft: (index == con.scannedBarcodes.length - 1)
                              ? const Radius.circular(10)
                              : const Radius.circular(0),
                          bottomRight: (index == con.scannedBarcodes.length - 1)
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
                                style: Theme.of(context).textTheme.bodyMedium)),
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
                              style: Theme.of(context).textTheme.bodyMedium),
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
    );
  }
}
