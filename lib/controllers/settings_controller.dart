import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<String> getExternalDocumentPath() async {
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/g_count/database/");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final exPath = directory.path;
    log("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<void> createBackup() async {
    isLoading.value = true;
    try {
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat("dd_MM_yy HH_mm_ss").format(now);
      // var date = formattedDateTime.replaceAll(RegExp(r'[ ,:]'), '');
      // log(date);
      String dbName = "gCount - $formattedDateTime.db";

      // final databasePath = await getDatabasesPath();
      final databasePath = await _localPath;

      final dbPath = path.join(databasePath, DBHelper.dbName);
      var file = File(dbPath);
      Directory documentsDirectory =
          Directory("storage/emulated/0/g_count/database/backup/");
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
