class CountSetting {
  int? countId;
  String? countDate;
  String? locCd;
  String? machId;
  String? stat;
  String? inCharge;
  String? compCd;
  int? otp;
  int? finalOtp;
  int? deleteOtp;
  String? locationName;

  CountSetting({
    this.countId,
    this.countDate,
    this.locCd,
    this.machId,
    this.stat,
    this.inCharge,
    this.compCd,
    this.otp,
    this.finalOtp,
    this.deleteOtp,
    this.locationName,
  });

  @override
  String toString() {
    return 'CountSetting(countId: $countId, countDate: $countDate, locCd: $locCd, machId: $machId, stat: $stat, inCharge: $inCharge, compCd: $compCd, otp: $otp, finalOtp: $finalOtp, deleteOtp: $deleteOtp, locationName: $locationName)';
  }

  factory CountSetting.fromJson(Map<String, dynamic> json) => CountSetting(
        countId: json['CountID'] as int?,
        countDate: json['CountDate'] as String?,
        locCd: json['LocCd'] as String?,
        machId: json['MachID'] as String?,
        stat: json['Stat'] as String?,
        inCharge: json['InCharge'] as String?,
        compCd: json['CompCd'] as String?,
        otp: json['OTP'] as int?,
        finalOtp: json['FinalOTP'] as int?,
        deleteOtp: json['DeleteOTP'] as int?,
        locationName: json['LocName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'CountID': countId,
        'CountDate': countDate,
        'LocCd': locCd,
        'MachID': machId,
        'Stat': stat,
        'InCharge': inCharge,
        'CompCd': compCd,
        'OTP': otp,
        'FinalOTP': finalOtp,
        'DeleteOTP': deleteOtp,
        'LocName': locationName,
      };
}
