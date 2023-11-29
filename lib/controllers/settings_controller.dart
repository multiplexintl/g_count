import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../db/db_helper.dart';

class SettingController extends GetxController {
  @override
  void onInit() {
    listFiles();
    super.onInit();
  }

  String identifier = 'Unknown';
  List<String> fileNames = [];
  var isLoading = false.obs;

  Future<void> createBackup() async {
    isLoading.value = true;
    try {
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat("dd_MM_yy HH_mm_ss").format(now);
      // var date = formattedDateTime.replaceAll(RegExp(r'[ ,:]'), '');
      // log(date);
      String dbName = "gCount - $formattedDateTime.db";
      final databasePath = await getDatabasesPath();
      final dbPath = path.join(databasePath, DBHelper.dbName);
      var file = File(dbPath);
      Directory documentsDirectory =
          Directory("storage/emulated/0/g_count/Database/Backup/");
      final exPath = documentsDirectory.path;
      await Directory(exPath).create(recursive: true);
      String newPath = path.join('$exPath$dbName');
      await file.copy(newPath);
      listFiles();
    } catch (e) {
      log(e.toString());
    }
    isLoading.value = false;
  }

  Future<void> deleteFile(String fileName) async {
    isLoading.value = true;
    try {
      Directory folder =
          Directory("storage/emulated/0/g_count/Database/Backup/");
      File file = File('${folder.path}/$fileName');
      await file.delete();
      listFiles(); // Refresh the file list after deletion
    } catch (e) {
      log('Error deleting file: $e');
    }
    isLoading.value = false;
  }

  Future<void> deleteAllFiles() async {
    isLoading.value = true;
    try {
      Directory folder =
          Directory("storage/emulated/0/g_count/Database/Backup/");
      if (await folder.exists()) {
        await folder.delete(recursive: true);
        fileNames.clear();
        listFiles(); // Refresh the file list after deletion
      } else {
        log('Folder does not exist');
      }
    } catch (e) {
      log('Error deleting files: $e');
    }
    isLoading.value = false;
  }

  Future<void> listFiles() async {
    try {
      Directory folder =
          Directory("storage/emulated/0/g_count/Database/Backup/");
      if (await folder.exists()) {
        List<FileSystemEntity> fileList = folder.listSync();
        fileNames = fileList.map((file) => file.uri.pathSegments.last).toList();
        fileNames = List.from(fileNames.reversed);
      } else {
        log('Folder does not exist');
      }
      update();
    } catch (e) {
      log('Error: $e');
    }
  }
}
