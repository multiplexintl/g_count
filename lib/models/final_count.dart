class FinalCount {
  int? tempCountQty;
  int? phyDetailQty;

  FinalCount({this.tempCountQty, this.phyDetailQty});

  @override
  String toString() {
    return 'FinalCount(tempCountQty: $tempCountQty, phyDetailQty: $phyDetailQty)';
  }

  factory FinalCount.fromJson(Map<String, dynamic> json) => FinalCount(
        tempCountQty: json['TempCountQty'] as int?,
        phyDetailQty: json['PhyDetailQty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'TempCountQty': tempCountQty,
        'PhyDetailQty': phyDetailQty,
      };
}
