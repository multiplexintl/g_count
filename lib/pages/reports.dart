import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/report_controller.dart';
import 'package:g_count/models/settings/user_master.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<ReportController>();
    con.selectedRadio.value = 0;
    return Scaffold(
      appBar: CustomWidgets.customAppBar(
        "Reports",
        back: true,
      ),
      body: Column(
        children: [
          // summery, detail radio button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PhysicalModel(
              color: Colors.black,
              elevation: 4,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              shape: BoxShape.rectangle,
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: const BoxDecoration(
                    color: Color(0xFFDFCDCC),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Obx(() => RadioListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
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
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
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
                    GetBuilder<ReportController>(
                      builder: (con) {
                        return const DetailView();
                      },
                    ),
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
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (con) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        RowDropWidget(
                          title: "Item",
                          dropdownvalue: con.selectedItem,
                          items: con.items?.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (p0) {
                            con.setItem(itemCode: p0);
                          },
                        ),
                        CustomWidgets.gap(h: 15),
                        RowDropWidget(
                          title: "Rack",
                          dropdownvalue: con.selectedRack,
                          items: con.racks?.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (p0) {
                            con.setRack(rack: p0);
                          },
                        ),
                        CustomWidgets.gap(h: 15),
                        RowDropWidget(
                          title: "User",
                          dropdownvalue: con.selectedUser,
                          items: con.users?.map((UserMaster items) {
                            return DropdownMenuItem(
                              value: items.userCd,
                              child: Text(
                                items.userName!,
                                overflow: TextOverflow.clip,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                            );
                          }).toList(),
                          onChanged: (p0) {
                            log(p0);
                            con.setUser(user: p0);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            con.getDetailReport();
                          },
                          child: const Text("OK"),
                        ),
                        CustomWidgets.gap(h: 20),
                        ElevatedButton(
                          onPressed: () {
                            con.clearAll();
                          },
                          child: const Text("Clear"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: DetailsTableWdiget(
                con: con,
              ),
            )
          ],
        );
      },
    );
  }
}

class RowDropWidget extends StatelessWidget {
  final String title;
  final List<DropdownMenuItem<dynamic>>? items;
  final String? dropdownvalue;
  final void Function(dynamic)? onChanged;

  const RowDropWidget({
    super.key,
    required this.title,
    this.items,
    this.dropdownvalue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        padding: EdgeInsets.zero,
        decoration: CustomWidgets().dropDownInputDecoration(labelText: title),
        value: dropdownvalue,
        items: items,
        onChanged: onChanged,
      ),
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
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
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
                  width: 85,
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
                  width: 160,
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
          if (con.summeryReportItems.isEmpty)
            const Expanded(child: Center(child: Text("No Items"))),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: SizedBox(
              height: 387,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: con.summeryReportItems.length,
                itemBuilder: (context, index) {
                  var report = con.summeryReportItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      // height: 40,
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.blueGrey[100],
                      ),
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
                              child: Text("${index + 1}",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                          Container(
                            height: 40,
                            width: 85,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(report.rackNo!,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          Container(
                              height: 40,
                              width: 160,
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
                                report.userName!,
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                            child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text("${report.qty}")),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Obx(() => Text(
                      "Total Qty: ${con.totalSummeryQty.value}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.yellow.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsTableWdiget extends StatelessWidget {
  const DetailsTableWdiget({
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
                  width: 85,
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
                  width: 160,
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
          if (con.detailsReport.isEmpty)
            const Expanded(child: Center(child: Text("No Items"))),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: SizedBox(
              height: 258,
              child: ListView.builder(
                itemCount: con.detailsReport.length,
                itemBuilder: (context, index) {
                  var report = con.detailsReport[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      // height: 40,
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.blueGrey[100],
                      ),
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
                              child: Text("${index + 1}",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                          Container(
                            height: 40,
                            width: 85,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(report.rackNo!,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          Container(
                              height: 40,
                              width: 160,
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
                                report.barcode!,
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                            child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text("${report.qty}")),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Obx(() => Text(
                    "Total Qty: ${con.totalDetailsQty.value}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.yellow.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
