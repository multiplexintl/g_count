class PhyDetail {
  String itemCode;
  int qty;

  PhyDetail({required this.itemCode, required this.qty});

  @override
  String toString() {
    return 'PhyDetail{itemCode: $itemCode, qty: $qty}';
  }

  factory PhyDetail.fromJson(Map<String, dynamic> json) {
    return PhyDetail(
      itemCode: json['PartCode'] as String,
      qty: json['Qty'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'PartCode': itemCode,
        'Qty': qty,
      };
}
