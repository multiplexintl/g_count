import 'package:flutter/material.dart';
import 'package:g_count/pages/settings/backup.dart';
import '/pages/admin_screen.dart';
import '/pages/count_view.dart';
import '/pages/dashboard_view.dart';
import '/pages/delete_count.dart';
import '/pages/home_screen.dart';
import '/pages/items_view.dart';
import '/pages/reports.dart';
import 'package:get/get.dart';

import 'pages/counting_page_view.dart';
import 'pages/settings/settings_screen.dart';
import 'pages/splash_screen.dart';

class RouteGenerator {
  static var list = [
    GetPage(
      name: RouteLinks.splash,
      page: () => const SplashScreen(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.home,
      page: () => const HomePage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.admin,
      page: () => const AdminPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.dashboard,
      page: () => const DashBoardPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.items,
      page: () => const ItemsView(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.reports,
      page: () => const ReportsPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.count,
      page: () => const CountPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.counting,
      page: () => const CountingPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.deleteCount,
      page: () => const DeleteCountPage(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.settings,
      page: () => const SettingsScreen(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: RouteLinks.backup,
      page: () => const BackupWidget(),
      transition: Transition.cupertino,
      curve: Curves.easeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
  ];
}

class RouteLinks {
  static const String splash = "/Splash";
  static const String home = "/HomeScreen";
  static const String admin = "/AdminPage";
  static const String dashboard = "/DashBoardPage";
  static const String items = "/ItemsPage";
  static const String reports = "/ReportsPage";
  static const String count = "/CountPage";
  static const String counting = "/CountingPage";
  static const String deleteCount = "/DeleteCount";
  static const String settings = "/SettingsScreen";
  static const String backup = "/BackupScreen";
}
