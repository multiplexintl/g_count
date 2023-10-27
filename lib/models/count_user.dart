import 'package:g_count/models/settings/user_master.dart';

class CountUser {
  UserMaster? user;
  String? rack;
  String? bay;
  String? level;

  CountUser({this.user, this.rack, this.bay, this.level});

  @override
  String toString() {
    return 'CountUser{user: $user, rack: $rack, bay: $bay, level: $level}';
  }

  factory CountUser.fromJson(Map<String, dynamic> json) {
    return CountUser(
      user: UserMaster.fromJson(
          {'UserCd': json['UserCd'], 'UserName': json['UserName']}),
      rack: json['RackNo'] as String?,
      bay: json['BayNo'] as String?,
      level: json['LevelNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'UserCd': user?.userCd,
        'UserName': user?.userName,
        'RackNo': rack,
        'BayNo': bay,
        'LevelNo': level,
      };
}
