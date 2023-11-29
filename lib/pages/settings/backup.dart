import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';
import '../../widgets/custom_widgets.dart';

class BackupWidget extends StatelessWidget {
  const BackupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<SettingController>();
    return Scaffold(
      appBar: CustomWidgets.customAppBar("Backup", back: true),
      body: Column(
        children: [

          CustomWidgets.gap(h: 10),
          GetBuilder<SettingController>(
            builder: (con) {
              return con.fileNames.isEmpty
                  ? const Expanded(
                      child: Center(child: Text("No Backup Found !!")))
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var fileName = con.fileNames[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("${index + 1}"),
                                  Text(fileName),
                                  IconButton(
                                    onPressed: () {
                                      con.deleteFile(fileName);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: con.fileNames.length,
                      ),
                    );
            },
          ),
          Container(
            height: 60,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    await con.createBackup();
                  },
                  child: const Text("Backup"),
                ),
                GetBuilder<SettingController>(
                  builder: (con) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: con.fileNames.isNotEmpty
                          ? () async {
                              CustomWidgets.customDialogue(
                                  title: "Delete Backup??",
                                  subTitle:
                                      "Are you sure to delete all backups?? This is IRREVESIBLE!!",
                                  onPressed: () async {
                                    Get.back();
                                    await con.deleteAllFiles();
                                  });
                            }
                          : null,
                      child: const Text("Clear All"),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
