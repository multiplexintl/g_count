import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/admin_controller.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<AdminController>();
    bool? isBack = Get.arguments;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomWidgets.customAppBar("Admin", back: isBack),
      //  bottomNavigationBar: const BottomBarWidget(),
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
                asset: "assets/icons/check_link.png",
                title: "Check\nConnection",
                onTap: () {},
              ),
              HomeWidget(
                asset: "assets/icons/remove-database.png",
                title: "Delete\nDatabase",
                onTap: () {
                  CustomWidgets.customDialogue(
                    title: "Delete Database??",
                    subTitle:
                        "Are you sure you want to delete all databases? This is NOT REVERSIBLE!!!",
                    onPressed: () {
                      Get.back();
                      CustomWidgets.startLoading(context);
                      con.deleteDatabase();
                    },
                  );
                },
              ),
              HomeWidget(
                asset: "assets/icons/import_settings.png",
                title: "Import\nSettings",
                onTap: () async {
                  CustomWidgets.startLoading(context);
                  await con.importSettings();
                },
              ),
              HomeWidget(
                asset: "assets/icons/import_items.png",
                title: "Import\nItems",
                onTap: () async {
                  CustomWidgets.startLoading(context);
                  await con.importItems();
                },
              ),
              HomeWidget(
                asset: "assets/icons/export_count.png",
                title: "Export\nCount",
                onTap: () {
                  CustomWidgets.startLoading(context);
                  con.exportCount();
                },
              ),
              HomeWidget(
                asset: "assets/icons/finalize_count.png",
                title: "Finalize\nCount",
                onTap: () {
                  if (con.countSetting.countId != null) {
                    log(con.countSetting.toString());
                    CustomWidgets.displayTextInputDialog(
                        formKey: formKey,
                        otp: con.countSetting.finalOtp!,
                        content:
                            "Are you sure you want to finalize count?\nThis is NOT REVERSIBLE!!!",
                        onPressedOk: () async {
                          if (formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                            CustomWidgets.startLoading(context);
                            con.finalizeCount();
                          }
                        });
                  } else {}
                },
              ),
              // Obx(() => Center(child: Text("${con.addingItem}")))
              Obx(() => Column(
                    children: [
                      Text(
                        "Status",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CustomWidgets.gap(h: 20),
                      statusWidget(
                        context: context,
                        value: con.settingsImport.value,
                        title: "Settings imported : ",
                      ),
                      statusWidget(
                        context: context,
                        value: con.itemsImport.value,
                        title: "Items imported : ",
                      ),
                      // statusWidget(
                      //   context: context,
                      //   value: con.countExport.value,
                      //   title: "Export Count : ",
                      // ),
                      // statusWidget(
                      //   context: context,
                      //   value: con.countFinalize.value,
                      //   title: "Count Finalized : ",
                      // ),
                      // statusWidget(
                      //   context: context,
                      //   value: con.databaseCleared.value,
                      //   title: "Database Cleared : ",
                      // ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Padding statusWidget(
      {required BuildContext context,
      required bool value,
      required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          value
              ? const Icon(
                  OctIcons.verified_24,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
        ],
      ),
    );
  }
}
