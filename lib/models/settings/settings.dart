import 'count_setting.dart';
import 'rack_master.dart';
import 'user_master.dart';

class Settings {
  List<CountSetting>? countSettings;
  List<UserMaster>? userMaster;
  List<RackMaster>? rackMaster;

  Settings({this.countSettings, this.userMaster, this.rackMaster});

  @override
  String toString() {
    return 'Settings(countSettings: $countSettings, userMaster: $userMaster, rackMaster: $rackMaster)';
  }

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        countSettings: (json['CountSettings'] as List<dynamic>?)
            ?.map((e) => CountSetting.fromJson(e as Map<String, dynamic>))
            .toList(),
        userMaster: (json['UserMaster'] as List<dynamic>?)
            ?.map((e) => UserMaster.fromJson(e as Map<String, dynamic>))
            .toList(),
        rackMaster: (json['RackMaster'] as List<dynamic>?)
            ?.map((e) => RackMaster.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'CountSettings': countSettings?.map((e) => e.toJson()).toList(),
        'UserMaster': userMaster?.map((e) => e.toJson()).toList(),
        'RackMaster': rackMaster?.map((e) => e.toJson()).toList(),
      };
}
