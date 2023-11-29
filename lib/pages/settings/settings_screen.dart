import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/settings_controller.dart';
import 'package:g_count/routes.dart';

import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    return Scaffold(
        appBar: CustomWidgets.customAppBar("Settings", back: true),
        bottomNavigationBar: const BottomBarWidget(),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
            child: Column(
              children: [
                settingsContainer(
                  text: "Backup",
                  onTap: () {
                    Get.toNamed(RouteLinks.backup);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  GestureDetector settingsContainer(
      {required void Function()? onTap, required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.only(left: 25, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.forward_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
