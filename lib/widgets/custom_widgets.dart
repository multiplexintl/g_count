import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../controllers/home_controller.dart';
import '../helpers/app_config.dart';
import 'loader_widget.dart';
import 'dart:math' as math;

class CustomWidgets {
  // custom snack bar
  static Future<SnackbarController> customSnackBar(
      {required String title,
      required String message,
      required Color textColor,
      int? duration}) async {
    Get.closeAllSnackbars();
    return Get.snackbar(title, message,
        backgroundColor:
            // textColor == Colors.red
            //     ? Colors.black.withOpacity(0.8)
            //     :
            Colors.white.withOpacity(0.5),
        colorText: textColor,
        borderRadius: 12,
        isDismissible: true,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(seconds: 1),
        duration: Duration(seconds: duration ?? 3),
        margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: textColor == Colors.red
                ? Colors.red.withOpacity(0.3)
                : Colors.green.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        titleText: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 16,
          ),
        ));
  }

  static Widget gap({double? h, double? w}) => SizedBox(
        height: h ?? 0,
        width: w ?? 0,
      );
  static startLoading(BuildContext context) async {
    OverlayLoadingProgress.start(
      context,
      //gifOrImagePath: 'assets/images/Loading.gif',
      barrierDismissible: false,

      widget: const Center(
        child: LoaderWidget(),
      ),
    );
  }

  static Future<void> stopLoader() async {
    await OverlayLoadingProgress.stop();
  }

  static AppBar customAppBar(String title, {bool? back}) {
    return AppBar(
      automaticallyImplyLeading: back ?? false,
      title: Text(title),
      backgroundColor: Colors.blue,
      centerTitle: true,
    );
  }

  static Future<dynamic> customDialogue({
    String? okText,
    required String title,
    required String subTitle,
    required void Function()? onPressed,
    void Function()? onPressedBack,
  }) {
    return Get.dialog(AlertDialog(
      title: Center(child: Text(title)),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subTitle),
            // CustomWidgets.gap(h: 10),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(double.infinity, 40),
                ),
                onPressed: onPressedBack ??
                    () {
                      Get.back();
                    },
                child: const Text("Back"),
              ),
            ),
            CustomWidgets.gap(w: 15),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: const Size(double.infinity, 40),
                ),
                onPressed: onPressed,
                child: Text(okText ?? "Confirm"),
              ),
            ),
          ],
        ),
      ],
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ));
  }

  static Future<void> displayTextInputDialog({
    required int otp,
    required String content,
    required void Function()? onPressedOk,
    required GlobalKey<FormState> formKey,
  }) async {
    return Get.dialog(AlertDialog(
      title: const Center(child: Text('Enter OTP')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          CustomWidgets.gap(h: 15),
          Form(
            key: formKey,
            child: TextFormField(
              // controller: _textFieldController,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.disabled,
              validator: (value) {
                if (value == null) {
                  return "Enter OTP";
                } else if (value != otp.toString()) {
                  return "Enter Valid OTP";
                }
                // validated
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "OTP",
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      actions: [
        CustomWidgets.customButtonRow(
          backText: "Cancel",
          okText: "Enter",
          onPressedOk: onPressedOk,
        ),
      ],
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actionsAlignment: MainAxisAlignment.center,
    ));
  }

  static Row customButtonRow({
    String? backText,
    String? okText,
    void Function()? onPressedBack,
    required void Function()? onPressedOk,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: const Size(double.infinity, 40),
            ),
            onPressed: onPressedBack ??
                () {
                  Get.back();
                },
            child: Text(backText ?? "Back"),
          ),
        ),
        CustomWidgets.gap(w: 15),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: const Size(double.infinity, 40),
            ),
            onPressed: onPressedOk,
            child: Text(okText ?? "Confirm"),
          ),
        ),
      ],
    );
  }

  static Future<bool?> exitAppDialogue(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Center(child: Text('Exit Multiroute?')),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          content: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Do you want to logout and exit Multiroute?"),
                CustomWidgets.gap(h: 10),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  InputDecoration dropDownInputDecoration({String? labelText}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      // labelStyle: ,
      contentPadding: const EdgeInsets.only(left: 5),
      constraints: const BoxConstraints(
        maxHeight: 35,
      ),
      filled: true,
      fillColor: const Color(0xFFC4D8DC),
    );
  }
}

class HomeContainer extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function() onTap;
  final Color iconColor;
  final Color? bgColor;

  const HomeContainer({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
    required this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //    height: 100,
        width: App().appWidth(45) - 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ?? Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: bgColor != null
                      ? bgColor!.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 5)),
            ],
            border: Border.all(
              color: Colors.lightBlue,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidgets.gap(h: 10),
            Icon(
              iconData,
              color: iconColor,
              size: 70,
            ),
            CustomWidgets.gap(h: 10),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CustomWidgets.gap(h: 10),
          ],
        ),
      ),
    );
  }
}

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<HomeController>(
            builder: (con) {
              return Text(
                "${con.date}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.merge(const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              );
            },
          ),
          // DigitalClock(
          //   showSeconds: true,
          //   isLive: true,
          //   textScaleFactor: 1.2,
          //   digitalClockTextColor: Colors.white,
          //   datetime: DateTime.now(),
          // ),
        ],
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final String asset;
  final String title;
  final void Function() onTap;
  const HomeWidget({
    super.key,
    required this.asset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          PhysicalModel(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            elevation: 8,
            shadowColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.square(
              dimension: 90,
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset(
                      asset,
                      scale: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomWidgets.gap(h: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.titleMedium?.merge(const TextStyle(
                      fontWeight: FontWeight.w500,
                    )),
          ),
        ],
      ),
    );
  }
}
