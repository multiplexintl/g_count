import 'package:flutter/material.dart';
import 'package:g_count/widgets/custom_widgets.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar("", back: true),
      bottomNavigationBar: const BottomBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
