class UserMaster {
  String? userCd;
  String? userName;

  UserMaster({this.userCd, this.userName});

  @override
  String toString() => 'UserMaster(userCd: $userCd, userName: $userName)';

  factory UserMaster.fromJson(Map<String, dynamic> json) => UserMaster(
        userCd: json['UserCd'] as String?,
        userName: json['UserName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'UserCd': userCd,
        'UserName': userName,
      };
}
