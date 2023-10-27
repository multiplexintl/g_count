class TempCount {
  String? sno;
  String partCode;
  String barcode;
  int qty;
  String rackNo;
  String userCode;

  TempCount({
    this.sno,
    required this.partCode,
    required this.barcode,
    required this.qty,
    required this.rackNo,
    required this.userCode,
  });

  // Factory method to create a TempCount instance from a map (usually from JSON).
  factory TempCount.fromJson(Map<String, dynamic> json) {
    return TempCount(
      sno: (json['SNo']).toString(),
      partCode: json['PartCode'] as String,
      barcode: json['Barcode'] as String,
      qty: int.tryParse(json['Qty']) as int,
      rackNo: json['RackNo'] as String,
      userCode: json['UserCode'] as String,
    );
  }

  // Method to convert TempCount instance to a map (usually for JSON).
  Map<String, dynamic> toJson() {
    return {
      'SNo': sno,
      'PartCode': partCode,
      'Barcode': barcode,
      'Qty': qty,
      'RackNo': rackNo,
      'UserCode': userCode,
    };
  }

  // Override toString() for easy debugging.
  @override
  String toString() {
    return 'TempCount{sno: $sno, partCode: $partCode, barcode: $barcode, qty: $qty, rackNo: $rackNo, userCode: $userCode}';
  }
}
