import '../helpers/app_config.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final double? opacity;
  final double? height;

  const LoaderWidget({this.opacity, Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? App().appHeight(100),
      width: App().appWidth(100),
      color: Colors.black54.withOpacity(opacity ?? 0.3),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
