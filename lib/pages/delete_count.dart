import 'package:flutter/material.dart';
import 'package:g_count/widgets/custom_widgets.dart';

class DeleteCountPage extends StatelessWidget {
  const DeleteCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
    return Scaffold(
      appBar: CustomWidgets.customAppBar("Delete Count", back: true),
      bottomNavigationBar: const BottomBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Column(
          children: [
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
                      decoration: CustomWidgets().dropDownInputDecoration(),
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
            Container(
              height: 300,
              color: const Color(0xFFA4BAC7),
            ),
            CustomWidgets.gap(h: 10),
            Text(
              "Total Quantity: 1234",
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CustomWidgets.gap(h: 10),
            Row(
              children: [
                Text(
                  "OTP",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                CustomWidgets.gap(w: 10),
                Expanded(
                  child: TextFormField(
                    decoration: CustomWidgets().dropDownInputDecoration(),
                  ),
                ),
              ],
            ),
            CustomWidgets.gap(h: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    child: const Text("Clear"),
                  ),
                ),
                CustomWidgets.gap(w: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: const Text("Delete Count"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
