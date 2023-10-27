import 'package:flutter/material.dart';

class Helper {
  InputDecoration inputDecoration(
      {required BuildContext context,
      required String label,
      Widget? suffixIcon}) {
    return InputDecoration(
      suffixIcon: suffixIcon,

      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      isDense: true,
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      hintStyle: Theme.of(context).textTheme.bodyMedium,
      floatingLabelStyle: Theme.of(context).textTheme.bodyMedium,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      errorStyle: Theme.of(context).textTheme.bodySmall?.merge(
            const TextStyle(
              color: Colors.red,
              height: 1,
            ),
          ),
      // constraints: const BoxConstraints(
      //   maxHeight: 40,
      //   minHeight: 40,
      // ),
    );
  }

  InputDecoration inputDecoration2() {
    return const InputDecoration(
      contentPadding: EdgeInsets.only(left: 10, right: 5, top: 15, bottom: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
      ),
    );
  }
}
