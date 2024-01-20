class OrderDetailsSchema {
  OrderDetailsSchema({
    required this.items,
    required this.shippingCharge,
  });

  List<OrderItem> items;
  double shippingCharge;
}

class OrderItem {
  OrderItem({
    required this.name,
    required this.price,
    required this.tax,
  });

  String name;
  double price;
  double tax;
}
