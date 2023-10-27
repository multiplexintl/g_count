import 'package:flutter/material.dart';
import 'package:g_count/widgets/custom_widgets.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedRadio = 0;
    setSelectedRadio(int val) {
      selectedRadio = val;
    }

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
          Container(
            width: double.infinity,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFDFCDCC),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    title: Text(
                      "Summery",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onChanged: (val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    title: Text(
                      "Detail",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onChanged: (val) {
                      setSelectedRadio(val!);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Detail view
          Column(
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
          )
        ],
      ),
    );
  }
}
