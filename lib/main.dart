import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_count/controllers/admin_controller.dart';
import 'package:g_count/routes.dart';
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("config");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        Get.put(AdminController());
        // Get.put(HomeController());
        // Get.put(DashBoardController());
        // Get.put(CountController());
        return child!;
      },
      title: 'G Count',
      initialRoute: RouteLinks.splash,
      getPages: RouteGenerator.list,
      debugShowCheckedModeBanner: false,
    );
  }
}
