class SummeryReport {
  String? rackNo;
  String? userName;
  int? qty;

  SummeryReport({this.rackNo, this.userName, this.qty});

  @override
  String toString() {
    return 'SummeryReport(rackNo: $rackNo, userName: $userName, qty: $qty)';
  }

  factory SummeryReport.fromJson(Map<String, dynamic> json) => SummeryReport(
        rackNo: json['RackNo'] as String?,
        userName: json['UserName'] as String?,
        qty: json['Qty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'RackNo': rackNo,
        'UserName': userName,
        'Qty': qty,
      };
}
