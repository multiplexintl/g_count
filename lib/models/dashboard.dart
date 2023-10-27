class DashBoard {
  String? countDate;
  String? locCode;
  String? locName;
  String? machID;
  bool? connection;
  int? countID;
  String? countInCharge;
  int? countedRacks;
  int? countedQty;
  int? updatedQty;
  int? totalQty;

  DashBoard({
    this.countDate,
    this.locCode,
    this.locName,
    this.machID,
    this.connection,
    this.countID,
    this.countInCharge,
    this.countedRacks,
    this.countedQty,
    this.updatedQty,
    this.totalQty,
  });

  @override
  String toString() {
    return 'DashBoard{'
        'countDate: $countDate, '
        'locCode: $locCode, '
        'locName: $locName, '
        'machID: $machID, '
        'connection: $connection, '
        'countID: $countID, '
        'countInCharge: $countInCharge, '
        'countedRacks: $countedRacks, '
        'countedQty: $countedQty, '
        'updatedQty: $updatedQty, '
        'totalQty: $totalQty}';
  }
}
