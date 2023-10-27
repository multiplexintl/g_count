import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/dashboard_controller.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<DashBoardController>();
    return Scaffold(
      appBar: CustomWidgets.customAppBar("DashBoard", back: true),
      bottomNavigationBar: const BottomBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Column(
          children: [
            DashboardWidget(
              title: "Count Date",
              value: "${con.dashBoard.value.countDate}",
            ),
            DashboardWidget(
              title: "Loc Code",
              value: "${con.dashBoard.value.locCode}",
            ),
            DashboardWidget(
              title: "Location",
              value: "${con.dashBoard.value.locName}",
            ),
            CustomWidgets.gap(
              h: 15,
            ),
            DashboardWidget(
              title: "Machine ID",
              value: "${con.dashBoard.value.machID}",
            ),
            GetBuilder<DashBoardController>(
              builder: (con) {
                return DashboardWidget(
                  title: "Connection",
                  value: con.dashBoard.value.connection! ? "Success" : "Failed",
                  color: con.dashBoard.value.connection!
                      ? Colors.green
                      : Colors.red,
                );
              },
            ),
            CustomWidgets.gap(
              h: 15,
            ),
            DashboardWidget(
              title: "Count ID",
              value: "${con.dashBoard.value.countID}",
            ),
            DashboardWidget(
              title: "Count In-Charge",
              value: "${con.dashBoard.value.countInCharge}",
            ),
            CustomWidgets.gap(
              h: 30,
            ),
            DashboardWidget(
              title: "Counted Racks",
              value: "${con.dashBoard.value.countedRacks}",
            ),
            DashboardWidget(
              title: "Counted Qty",
              value: "${con.dashBoard.value.countedQty}",
              color: Colors.green,
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            GetBuilder<DashBoardController>(
              builder: (con) {
                return DashboardWidget(
                  title: "Updated Qty",
                  value: "${con.dashBoard.value.updatedQty}",
                  color: con.dashBoard.value.updatedQty ==
                          con.dashBoard.value.countedQty
                      ? Colors.green
                      : Colors.red,
                );
              },
            ),
            CustomWidgets.gap(
              h: 15,
            ),
            DashboardWidget(
              title: "Total Items",
              value: "${con.dashBoard.value.totalQty}",
            ),
            CustomWidgets.gap(h: 30),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  con.sync();
                  // con.countQty();
                },
                child: const Text("Sync"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  const DashboardWidget({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 135,
          color: color ?? Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: color != null ? Colors.white : Colors.black,
                    )),
              ),
              Text(
                ":",
                style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: color != null ? Colors.white : Colors.black,
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            color: color ?? Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                CustomWidgets.gap(w: 10),
                Text(
                  value,
                  overflow: TextOverflow.fade,
                  style:
                      Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: color != null ? Colors.white : Colors.black,
                          )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
