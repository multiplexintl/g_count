import 'package:flutter/material.dart';
import 'package:g_count/controllers/delete_count_controller.dart';
import 'package:g_count/widgets/custom_widgets.dart';
import 'package:get/get.dart';

class DeleteCountPage extends StatelessWidget {
  const DeleteCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var con = Get.find<DeleteCountController>();
    return Scaffold(
      appBar: CustomWidgets.customAppBar("Delete Count", back: true),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  con.clear();
                  con.getRacks();
                },
                child: const Text("Clear"),
              ),
            ),
            CustomWidgets.gap(w: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  con.deleteCount();
                },
                child: const Text("Delete Count"),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Rack",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                CustomWidgets.gap(w: 10),
                Expanded(
                  child: GetBuilder<DeleteCountController>(
                    builder: (con) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: CustomWidgets().dropDownInputDecoration(),
                          value: con.selectedRack,
                          items: con.racks?.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (value) {
                            con.selectRack(rack: value!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            CustomWidgets.gap(h: 20),
            GetBuilder<DeleteCountController>(
              builder: (con) {
                return CommonTableWdiget(con: con);
              },
            ),
            CustomWidgets.gap(h: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Delete OTP : ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomWidgets.gap(w: 10),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    decoration: CustomWidgets().dropDownInputDecoration(),
                  ),
                ),
                CustomWidgets.gap(w: 10),
                Text(
                  "Total Quantity: 1234",
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommonTableWdiget extends StatelessWidget {
  const CommonTableWdiget({
    super.key,
    required this.con,
  });

  final DeleteCountController con;

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
                // if (con.selectedRackItems.isEmpty)
                //   Expanded(child: Text("No Items Yet")),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: SizedBox(
                    height: 342,
                    child: ListView.builder(
                      itemCount: con.selectedRackItems.length,
                      itemBuilder: (context, index) {
                        var barcode = con.selectedRackItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: index.isEven
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.blueGrey[100],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: (index ==
                                          con.selectedRackItems.length - 1)
                                      ? const Radius.circular(10)
                                      : const Radius.circular(0),
                                  bottomRight: (index ==
                                          con.selectedRackItems.length - 1)
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
                                    child: Text("${index + 1}",
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
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
