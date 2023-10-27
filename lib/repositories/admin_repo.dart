import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:g_count/models/item.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../models/settings/settings.dart';

class AdminRepo {
  final String _url = GlobalConfiguration().getValue('api_base_url');

  // get count settings

  Future<Either<String, Settings>> getCountSettings(String uniqueId) async {
    final Uri url = Uri.parse('${_url}gCount/GetMasters?UnitID=$uniqueId');
    final client = http.Client();
    try {
      final response = await client.get(url);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        Settings settings = Settings.fromJson(result);
        // log(settings.toString());
        // var result2 = {"CountSettings": [], "UserMaster": [], "RackMaster": []};
        // Settings settings2 = Settings.fromJson(result2);
        return Right(settings);
      } else {
        var result = json.decode(response.body)['Message'];
        return Left("${response.statusCode} : $result");
      }
    } catch (e) {
      // log(e.toString());
      return Left(e.toString());
    }
  }

  // get items
  Future<Either<String, List<Item>>> getitems(int countID) async {
    final Uri url = Uri.parse('${_url}gCount/GetItems?CountID=$countID');
    final client = http.Client();
    try {
      final response = await client.get(url);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        List<Item> items = List.from(jsonDecode(response.body))
            .map((itemData) => Item.fromJson(itemData))
            .toList();
        log(items.length.toString());
        return Right(items);
      } else {
        return Left(jsonDecode(response.body)['Message']);
      }
    } catch (e) {
      // log(e.toString());
      return Left(e.toString());
    }
  }
}
