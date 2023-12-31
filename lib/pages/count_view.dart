import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_count/controllers/count_controller.dart';
import 'package:g_count/models/settings/user_master.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

import '../widgets/text_with_controller.dart';

class CountPage extends StatelessWidget {
  const CountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<CountController>();
    final InputWithKeyboardControlFocusNode rackFocusNode =
        InputWithKeyboardControlFocusNode();

    return Scaffold(
      appBar: CustomWidgets.customAppBar("Count", back: true),
      bottomNavigationBar: const BottomBarWidget(),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: PhysicalModel(
          color: Colors.black,
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          shape: BoxShape.rectangle,
          child: Container(
            width: double.infinity,
            height: 450,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            decoration: BoxDecoration(
                color: const Color(0xFFE4DBD5),
                borderRadius: BorderRadius.circular(
                  13,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameDropDownWidget(
                  title: "Name",
                  items: con.users.map((UserMaster items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.userName!),
                    );
                  }).toList(),
                  dropdownvalue: null,
                  onChanged: (value) {
                    con.createRack(value: value);
                  },
                ),
                GetBuilder<CountController>(
                  builder: (con) {
                    return NameDropDownWidget(
                      title: "Rack",
                      items: con.rack.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      dropdownvalue: con.countUser.rack,
                      onChanged: (value) {
                        con.createBay(rack: value);
                      },
                    );
                  },
                ),
                GetBuilder<CountController>(
                  builder: (con) {
                    return NameDropDownWidget(
                      title: "Bay",
                      items: con.bayNo.map((String? items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items!),
                        );
                      }).toList(),
                      dropdownvalue: con.countUser.bay,
                      onChanged: (value) {
                        con.createlevel(bay: value);
                      },
                    );
                  },
                ),
                GetBuilder<CountController>(
                  builder: (con) {
                    return NameDropDownWidget(
                      title: "Level",
                      items: con.levelNo.map((String? items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items!),
                        );
                      }).toList(),
                      dropdownvalue: con.countUser.level,
                      onChanged: (value) {
                        con.createRackNumber(value: value);
                      },
                    );
                  },
                ),
                Text(
                  "Rack Number",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.merge(const TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                ),
                // Obx(
                //   () => TextFormField(
                //     controller: con.rackNumberController.value,
                //     onChanged: (value) {
                //       log(value);
                //     },
                //     decoration: CustomWidgets().dropDownInputDecoration(),
                //   ),
                // ),
                Obx(() => InputWithKeyboardControl(
                      controller: con.rackNumberController.value,
                      focusNode: rackFocusNode,
                      width: 300,
                      showButton: false,
                      startShowKeyboard: false,
                      style: Theme.of(context).textTheme.bodyMedium!,
                      autofocus: true,
                      onChanged: (p0) {
                        con.onRackScanned(rackNumber: p0);
                      },
                    )),
                CustomWidgets.gap(h: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Back"),
                      ),
                    ),
                    CustomWidgets.gap(w: 16),
                    Expanded(child: GetBuilder<CountController>(
                      builder: (con) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed:
                              con.rackNumberController.value.text.isEmpty ||
                                      con.countUser.user == null
                                  ? null
                                  : () {
                                      con.createCountUser();
                                    },
                          child: const Text("Start"),
                        );
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NameDropDownWidget extends StatelessWidget {
  const NameDropDownWidget({
    super.key,
    required this.items,
    required this.title,
    required this.dropdownvalue,
    required this.onChanged,
  });

  final String title;
  // final List<String> items;
  final List<DropdownMenuItem<dynamic>>? items;
  final String? dropdownvalue;
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
          child: DropdownButtonFormField(
            decoration: CustomWidgets().dropDownInputDecoration(),
            value: dropdownvalue,
            // items: items.map((String items) {
            //   return DropdownMenuItem(
            //     value: items,
            //     child: Text(items),
            //   );
            // }).toList(),
            items: items,
            onChanged: onChanged,
          ),
        ),
        CustomWidgets.gap(h: 15)
      ],
    );
  }
}
