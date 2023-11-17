import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:g_count/models/final_count.dart';
import 'package:g_count/models/settings/count_setting.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class DashboardRepo {
  final String _url = GlobalConfiguration().getValue('api_base_url');

  // upload phyDetails

  Future<bool> uploadPhyDetails(Map<String, dynamic> phyDetails) async {
    final Uri url = Uri.parse('${_url}gCount/SyncPhyDetail');
    final client = http.Client();
    // log(json.encode(phyDetails));
    try {
      final response = await client.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(phyDetails),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        log(response.body.toString());
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // upload temp count back

  Future<bool> uploadTempCountBack(Map<String, dynamic> tempCount) async {
    final Uri url = Uri.parse('${_url}gCount/SyncTempCountBack');
    final client = http.Client();
    //  log(json.encode(tempCount));
    try {
      final response = await client.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(tempCount),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        log(response.body.toString());
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // get updated count qty
  Future<Either<String, FinalCount>> getUpdatedQty(
      int countId, String machId) async {
    final Uri url = Uri.parse(
        '${_url}gCount/CheckServerQty?CountID=$countId&MachID=$machId');
    final client = http.Client();
    try {
      final response = await client.get(url);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        List<FinalCount> finalCount =
            List.from(result).map((e) => FinalCount.fromJson(e)).toList();
        log(finalCount.toString());
        return Right(finalCount[0]);
      } else {
        return const Left("Error");
      }
    } catch (e) {
      log(e.toString());
      return const Left("Error");
    }
  }

  Future<bool> finalizeCount(CountSetting countSetting) async {
    final Uri url = Uri.parse('${_url}gCount/SyncFinalize');
    final client = http.Client();
    var body = json.encode({
      "FinalizeData": [
        {
          "CountID": countSetting.countId,
          "MachID": countSetting.machId,
          "Stat": "Completed",
        }
      ]
    });
    try {
      final response = await client.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        log(response.body.toString());
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
