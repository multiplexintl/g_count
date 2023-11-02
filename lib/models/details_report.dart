class DetailsReport {
  String? rackNo;
  String? barcode;
  int? qty;

  DetailsReport({this.rackNo, this.barcode, this.qty});

  @override
  String toString() {
    return 'DetailsReport(rackNo: $rackNo, barcode: $barcode, qty: $qty)';
  }

  factory DetailsReport.fromJson(Map<String, dynamic> json) => DetailsReport(
        rackNo: json['RackNo'] as String?,
        barcode: json['Barcode'] as String?,
        qty: json['Qty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'RackNo': rackNo,
        'Barcode': barcode,
        'Qty': qty,
      };
}
