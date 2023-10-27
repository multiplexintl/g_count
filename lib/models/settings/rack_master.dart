class RackMaster {
  String? rackNo;
  String? bayNo;
  String? levelNo;

  RackMaster({this.rackNo, this.bayNo, this.levelNo});

  @override
  String toString() {
    return 'RackMaster(rackNo: $rackNo, bayNo: $bayNo, levelNo: $levelNo)';
  }

  factory RackMaster.fromJson(Map<String, dynamic> json) => RackMaster(
        rackNo: json['RackNo'] as String?,
        bayNo: json['BayNo'] as String?,
        levelNo: json['LevelNo'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'RackNo': rackNo,
        'BayNo': bayNo,
        'LevelNo': levelNo,
      };
}
