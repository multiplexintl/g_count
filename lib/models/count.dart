class CountItem {
  // final String index;
  String itemCode;
  String barcode;
  int? qty;

  CountItem({required this.itemCode, required this.barcode, this.qty = 1});

  @override
  String toString() {
    return 'CountItem(itemCode: $itemCode, barcode: $barcode, qty: $qty)';
  }
}
