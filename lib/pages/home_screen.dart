import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/admin_controller.dart';
import 'package:g_count/controllers/count_controller.dart';
import 'package:g_count/controllers/dashboard_controller.dart';
import 'package:g_count/controllers/items_controller.dart';
import 'package:g_count/controllers/report_controller.dart';

import 'package:g_count/routes.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    var dashBoardCon = Get.put(DashBoardController());
    var countCon = Get.put(CountController());
    Get.put(ItemsController());
    var adminCon = Get.find<AdminController>();
    var con = Get.put(ReportController());
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomWidgets.customAppBar("gCount"),
      bottomNavigationBar: const BottomBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Wrap(
            runSpacing: 40,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 30,
            children: [
              HomeWidget(
                asset: "assets/icons/dashboard.png",
                title: "Dashboard",
                onTap: () async {
                  await dashBoardCon
                      .updateDashboard()
                      .then((value) => Get.toNamed(RouteLinks.dashboard));
                },
              ),
              HomeWidget(
                asset: "assets/icons/count.png",
                title: "Count",
                onTap: () async {
                  await countCon.setSettings();
                  // await countCon.getItems();
                },
              ),
              HomeWidget(
                asset: "assets/icons/items.png",
                title: "Items",
                onTap: () {
                  Get.toNamed(RouteLinks.items);
                },
              ),
              HomeWidget(
                asset: "assets/icons/report.png",
                title: "Reports",
                onTap: () {
                  // con
                  //     .initilaPage()
                  //     .then((value) =>
                  Get.toNamed(RouteLinks.reports);
                },
              ),
              HomeWidget(
                asset: "assets/icons/printer.png",
                title: "Print",
                onTap: () async {
                  // await DBHelper.deleteAllItem(
                  //     tableName: DBHelper.countSettingsTable);
                },
              ),
              HomeWidget(
                asset: "assets/icons/settings.png",
                title: "Settings",
                onTap: () async {
                  // countCon.soundAndVibrate(error: true);
                },
              ),
              HomeWidget(
                asset: "assets/icons/utilities.png",
                title: "Utilities",
                onTap: () async {},
              ),
              HomeWidget(
                asset: "assets/icons/admin.png",
                title: "Admin",
                onTap: () {
                  if (dashBoardCon.countSetting.countId != null) {
                    log(dashBoardCon.countSetting.toString());
                    CustomWidgets.displayTextInputDialog(
                        formKey: formKey,
                        otp: dashBoardCon.countSetting.otp!,
                        content: "Enter Initialization OTP.",
                        onPressedOk: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                            adminCon.setSettings().then((value) =>
                                Get.toNamed(RouteLinks.admin, arguments: true));
                          }
                        });
                  } else {
                    Get.toNamed(RouteLinks.admin);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
