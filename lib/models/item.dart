class Item {
  String? itemCode;
  String? itemName;
  String? barcode;
  String? brand;

  Item({this.itemCode, this.itemName, this.barcode, this.brand});

  @override
  String toString() {
    return 'Item(itemCode: $itemCode, itemName: $itemName, barcode: $barcode, brand: $brand)';
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemCode: json['ItCode'] as String?,
        itemName: json['ItName'] as String?,
        barcode: json['Barcode'] as String?,
        brand: json['Brand'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ItCode': itemCode,
        'ItName': itemName,
        'Barcode': barcode,
        'Brand': brand,
      };
}
