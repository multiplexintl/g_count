import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  // Database instance
  static Database? _db;

  //database name
  static const String dbName = "gCount.db";

  // tables
  static const String countSettingsTable = "CountSettings";
  static const String partTable = "Part";
  static const String phyDetailTable = "PhyDetail";
  static const String rackTable = "Rack";
  static const String tempCountTable = "TempCount";
  static const String tempCountBackTable = "TempCountBack";
  static const String tempCountDeleteTable = "TempCountDeleted";
  static const String usersTable = "Users";
  //
  static const String countUserTable = "CountUsers";

  // columns in tables
  //Users
  static const String userCodeUser = "UserCd";
  static const String userNameUser = "UserName";

  //CountSetting
  static const String countIDCountSettings = "CountID";
  static const String countDateCountSettings = "CountDate";
  static const String locCodeCountSettings = "LocCd";
  static const String statCountSettings = "Stat";
  static const String inChargeCountSettings = "InCharge";
  static const String otpCountSettings = "OTP";
  static const String compCdCountSettings = "CompCd";
  static const String machIDCountSettings = "MachID";
  static const String finalOtpCountSettings = "FinalOTP";
  static const String deleteOtpCountSettings = "DeleteOTP";
  static const String locNameCountSettings = "LocName";

  // Part
  static const String partCodePart = "ItCode";
  static const String partNamePart = "ItName";
  static const String barcodePart = "Barcode";
  static const String brandPart = "Brand";

  //PhyDetail
  static const String partCodePhyDetail = "PartCode";
  static const String qtyPhyDetail = "Qty";

  // Rack
  static const String rackNoRack = "RackNo";
  static const String bayNoRack = "BayNo";
  static const String levelNoRack = "LevelNo";

// Temp Count
  static const String slNoTempCount = "SNo";
  static const String partCodeTempCount = "PartCode";
  static const String barcodeTempCount = "Barcode";
  static const String qtyTempCount = "Qty";
  static const String rackNoTempCount = "RackNo";
  static const String userCodeTempCount = "UserCode";

// Temp Count Back
  static const String sNoTempCountBack = "SNo";
  static const String partCodeTempCountBack = "PartCode";
  static const String barcodeTempCountBack = "Barcode";
  static const String qtyTempCountBack = "Qty";
  static const String rackNoTempCountBack = "RackNo";
  static const String userCodeTempCountBack = "UserCode";
  static const String dtTempCountBack = "Dt";

// Temp Count Delete
  static const String sNoTempCountDelete = "SNo";
  static const String partCodeTempCountDelete = "PartCode";
  static const String barcodeTempCountDelete = "Barcode";
  static const String qtyTempCountDelete = "Qty";
  static const String rackNoTempCountDelete = "RackNo";
  static const String userCodeTempCountDelete = "UserCode";

// Count User Temp Count
  static const String userCodeCountUser = "UserCd";
  static const String userNameCountUser = "UserName";
  static const String rackCountUser = "RackNo";
  static const String bayCountUser = "BayNo";
  static const String levelCountUser = "LevelNo";

  // get db
  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await openDb();
    return _db!;
  }

  //open database
  static Future<Database> openDb() async {
    final databasePath = await getDatabasesPath();
    final dbPath = path.join(databasePath, dbName);
    log(dbPath);
    return openDatabase(
      dbPath,
      //if app is building from scratch in dev, change the version to 1, then increment the number while uncommenting respective code in onUpgrade
      // make sure all tables have altered table code before production.
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        log("Upgrade old Version $oldVersion");
        log("Upgrade new Version $newVersion");
        if (oldVersion < newVersion) {
          // use this to create new tables, alter table in dev only upgrade the version to run this
          // make sure all altered table codes are integreted to create table code before production.
        }
      },
    );
  }

  // on create
  // if app is creating from scratch make sure to update this function to add altered table code
  static Future<void> createTables(Database database) async {
    // CountSetting
    await database.execute("""CREATE TABLE $countSettingsTable(
      $countIDCountSettings INTEGER NOT NULL,
      $countDateCountSettings TEXT NOT NULL,
      $locCodeCountSettings TEXT NOT NULL,
      $statCountSettings TEXT NOT NULL,
      $inChargeCountSettings TEXT NOT NULL,
      $otpCountSettings INTEGER NOT NULL,
      $compCdCountSettings TEXT NOT NULL,
      $machIDCountSettings TEXT NOT NULL,
      $finalOtpCountSettings INTEGER NOT NULL,
      $deleteOtpCountSettings INTEGER NOT NULL,
      $locNameCountSettings TEXT NOT NULL, PRIMARY KEY ($countIDCountSettings))""");

    // Users table
    await database.execute("""CREATE TABLE $usersTable(
      $userCodeUser TEXT NOT NULL,
      $userNameUser TEXT NOT NULL, PRIMARY KEY ($userCodeUser))""");

    // Part table
    await database.execute("""CREATE TABLE $partTable(
      $partCodePart TEXT NOT NULL,
      $partNamePart TEXT NOT NULL,
      $barcodePart TEXT NOT NULL,
      $brandPart TEXT NOT NULL, PRIMARY KEY ($partCodePart))""");

    // PhyDetail table
    await database.execute("""CREATE TABLE $phyDetailTable(
      $partCodePhyDetail TEXT NOT NULL,
      $qtyPhyDetail INTEGER NOT NULL)""");

    // Rack table
    await database.execute("""CREATE TABLE $rackTable(
      $rackNoRack TEXT NOT NULL,
      $bayNoRack TEXT NOT NULL,
      $levelNoRack TEXT NOT NULL, PRIMARY KEY ($rackNoRack, $bayNoRack, $levelNoRack))""");

    // Temp Count Table
    await database.execute("""CREATE TABLE $tempCountTable(
      $slNoTempCount INTEGER PRIMARY KEY AUTOINCREMENT,
      $partCodeTempCount TEXT NOT NULL,
      $barcodeTempCount TEXT NOT NULL,
      $qtyTempCount TEXT NOT NULL,
      $rackNoTempCount TEXT NOT NULL,
      $userCodeTempCount TEXT NOT NULL)""");

    // Temp Count Table Back
    await database.execute("""CREATE TABLE $tempCountBackTable(
      $sNoTempCountBack INTEGER PRIMARY KEY,
      $partCodeTempCountBack TEXT NOT NULL,
      $barcodeTempCountBack TEXT NOT NULL,
      $qtyTempCountBack TEXT NOT NULL,
      $rackNoTempCountBack TEXT NOT NULL,
      $userCodeTempCountBack TEXT NOT NULL,
      $dtTempCountBack TEXT NOT NULL)""");

    // Temp Count Table Delete
    await database.execute("""CREATE TABLE $tempCountDeleteTable(
      $sNoTempCountDelete INTEGER PRIMARY KEY,
      $partCodeTempCountDelete TEXT NOT NULL,
      $barcodeTempCountDelete TEXT NOT NULL,
      $qtyTempCountDelete TEXT NOT NULL,
      $rackNoTempCountDelete TEXT NOT NULL,
      $userCodeTempCountDelete TEXT NOT NULL)""");

    // count user temp db //custom table by me
    await database.execute("""CREATE TABLE $countUserTable(
      $userCodeCountUser TEXT PRIMARY KEY,
      $userNameCountUser TEXT NOT NULL,
      $rackCountUser TEXT NOT NULL,
      $bayCountUser TEXT NOT NULL,
      $levelCountUser TEXT NOT NULL)""");
  }

  // insert into table single function, takes table name and list of map data
  static Future<void> addItemsToTable({
    required String tableName,
    required List<dynamic> item,
  }) async {
    final database = await db;
    for (int i = 0; i < item.length; i++) {
      await database.insert(tableName, item[i],
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("added to $tableName ${item[i]}");
    }
  }

  static Future<List<Object?>> bulkInsert({
    required String tableName,
    required List<Map<String, dynamic>> items,
  }) async {
    Database database = await db;
    var result = [];
    // Use a transaction for bulk insert
    await database.transaction((txn) async {
      Batch batch = txn.batch();
      try {
        for (var record in items) {
          batch.insert(
            tableName,
            record,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        result = await batch.commit(
          noResult: false,
        );
      } catch (e) {
        // Handle different error scenarios
        log("Error during bulk insert: $e");
        if (e is DatabaseException) {
          // Handle database-specific exceptions
          if (e.isUniqueConstraintError()) {
            log("Unique constraint violation. Duplicate entry found.");
            result = [];
          } else if (e.isSyntaxError()) {
            log("SQL syntax error.");
            result = [];
          }
          // Add more specific error handling as needed
        } else {
          // Handle other types of exceptions
          log("Unexpected error: $e");
          result = [];
        }
      }
    });
    return result;
  }

  // get items form a table and returns a list of map
  static Future<List<Map<String, dynamic>>> getAllItems(
      {required String tableName}) async {
    final database = await db;
    var result = await database.query(tableName);
    // log("$tableName:$result");
    return result;
  }

  static Future<int> getTableLength({required String tableName}) async {
    final database = await db;
    final List<Map<String, dynamic>> result =
        await database.rawQuery('SELECT COUNT(*) as count FROM $tableName');

    if (result.isNotEmpty) {
      log("$tableName length is ${result.first['count']}");
      return result.first['count'] as int;
    } else {
      log("0");
      return 0;
    }
  }

  static Future<int> getSumofColumn(
      {required String tableName, required String columnName}) async {
    final database = await db;
    final List<Map<String, dynamic>> result = await database
        .rawQuery('SELECT SUM($columnName) as count FROM $tableName');
    // log(result.toString());

    if (result.isNotEmpty && result.first['count'] != null) {
      log("$tableName $columnName sum is ${result.first['count']}");
      return result.first['count'] as int;
    } else {
      // log("0");
      return 0;
    }
  }

  // get a single item from a table based on condition, returns a list of map
  static Future<List<Map<String, dynamic>>> getItems(
      {required String tableName,
      required String columnName,
      required String condition}) async {
    final database = await db;
    return database.query(
      tableName,
      where: "$columnName = ?",
      whereArgs: [condition],
    );
  }

  // sqflite query
  static Future<List<Map<String, dynamic>>> getItemsByQuery(String tableName,
      {String? where, List<Object?>? whereArgs}) async {
    final database = await db;
    return database.query(
      tableName,
      where: where, // should be like string1 = ? and string2 = ?
      whereArgs: whereArgs, // should be like [condition1,condition2]
    );
  }

  // sqflite get by raw query
  static Future<List<Map<String, dynamic>>> getItemsByRawQuery(
      String query) async {
    final database = await db;
    return database.rawQuery(query);
  }

  // update a single item in a table
  static Future<int> updateItem({
    required String tableName,
    required Map<String, dynamic> data,
    required String keyColumn,
    required dynamic condition,
  }) async {
    // log("Table to be updated: $tableName");
    // log("Data to be updated: $data");
    final database = await db;
    final result = await database.update(
      tableName,
      data,
      where: "$keyColumn = ?",
      whereArgs: [condition],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // log(result.toString());
    //  var updatedTable = await database.query(tableName);
    // log("Updated $tableName = $updatedTable");
    return result;
  }

  // update a single item in a table
  static Future<int> updateItem2(
    String tableName,
    Map<String, dynamic> data,
    String keyColumn1,
    String keyColumn2,
    String condition1,
    String condition2,
  ) async {
    // log("Table to be updated: $tableName");
    // log("Data to be updated: $data");
    final database = await db;
    final result = await database.update(
      tableName,
      data,
      where: "$keyColumn1 = ? and $keyColumn2 = ?",
      whereArgs: [condition1, condition2],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    log(result.toString());
    // var updatedTable = await database.query(tableName);
    //  log("Updated $tableName = $updatedTable");
    return result;
  }

  // insert new item to table
  static Future<int> insertItem({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    // log("Table to be inserted: $tableName");
    // log("Data to be inserted: $data");
    final database = await db;
    final result = await database.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // log(result.toString());
    //var updatedTable = await database.query(tableName);
    // log("inserted into $tableName = $updatedTable");
    return result;
  }

  // db raw insert

  static Future<int> updateItemTest({
    required String tableName,
    required Map<String, dynamic> data,
    required String keyColumn1,
    required String keyColumn2,
    required String keyColumn3,
    required String keyColumn4,
    required String condition1,
    required String condition2,
    required String condition3,
    required String condition4,
  }) async {
    final database = await db;
    final result = await database.update(
      tableName,
      data,
      where:
          "$keyColumn1 = ? and $keyColumn2 = ? and $keyColumn3 = ? and $keyColumn4 = ?",
      whereArgs: [condition1, condition2, condition3, condition4],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //await database.query(tableName);
    return result;
  }

  // delete a single item from a table based on a condition
  static Future<void> deleteItem(
      String tableName, String columnName, String condition) async {
    final database = await db;
    try {
      await database
          .delete(tableName, where: "$columnName = ?", whereArgs: [condition]);
    } catch (e) {
      log("Something went wrong with error: $e");
    }
  }

  // delete all items from a table
  static Future<int> deleteAllItem({required String tableName}) async {
    final database = await db;
    try {
      var rows = await database.delete(tableName);
      //   log(rows.toString());
      return rows;
    } catch (e) {
      log("Something went wrong with error: $e");
      return -1;
    }
  }

  // get the path of the database, takes the database name
  static Future<String> getPath(String databaseName) async {
    final databasePath = await getDatabasesPath();
    final dbPath = path.join(databasePath, databaseName);
    return dbPath;
  }

  // list all the table in sqlite master
  static Future<List<String>> listTables() async {
    final database = await db;
    var tableNames = (await database
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);
    log(tableNames.toString());
    final dbVersion = await database.getVersion();
    log("$dbVersion");
    return tableNames;
  }

  // list all columns in a given table
  static Future<List<String>> listColumnsInTable(String tableName) async {
    final database = await db;
    final columnsQuery =
        await database.rawQuery('PRAGMA table_info($tableName)');
    final columnNames =
        columnsQuery.map((column) => column['name'] as String).toList();
    log(columnNames.toString());
    return columnNames;
  }

  // execute raw query

  static Future<void> executeRawQuery(String query) async {
    final database = await db;
    await database.execute(query);
  }

  // close database
  static Future<void> closeDb() async {
    final database = await db;
    await database.close();
  }
}
