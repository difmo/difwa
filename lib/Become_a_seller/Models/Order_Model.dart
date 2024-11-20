// order_model.dart

class AdminLiveOrderItem {
  final String name;
  final String qty;
  final String price;

  AdminLiveOrderItem({
    required this.name,
    required this.qty,
    required this.price,
  });
}

class OrderDuration {
  final String date;
  final bool status;

  OrderDuration({
    required this.date,
    required this.status,
  });
}

class AdminLiveOrder {
  final String customerName;
  final String orderId;
  final String total;
  final List<AdminLiveOrderItem> items;
  final List<OrderDuration> durations;
  final String message;
  final String orderTime;
  final String mobileNumber;

  AdminLiveOrder({
    required this.customerName,
    required this.orderId,
    required this.total,
    required this.items,
    required this.durations,
    required this.message,
    required this.orderTime,
    required this.mobileNumber,
  });
}

class ongoingOrderCardData {
  final String name;
  final String orderId;
  final String total;
  final String time;
  final String imageUrl;
  final List<ongoingOrderItem> items;
  final List<ongoingOrderDuration> durations;
  final bool orderpreparing;
  final bool outfordelivery;
  final bool readytoship;
  final bool orderdelivered;

  final String status;

  ongoingOrderCardData({
    required this.name,
    required this.orderId,
    required this.total,
    required this.time,
    required this.imageUrl,
    required this.items,
    required this.status,
    List<ongoingOrderDuration>? durations,
    required this.orderpreparing,
    required this.outfordelivery,
    required this.readytoship,
    required this.orderdelivered,
  }) : durations = durations ?? [];
}

class ongoingOrderItem {
  final String name;
  final int qty;
  final double price;

  ongoingOrderItem({
    required this.name,
    required this.qty,
    required this.price,
  });
}

class ongoingOrderDuration {
  String date;
  bool orderpreparing;
  bool readytoship;
  bool outfordelivery;
  bool orderdelivered;
  bool status;

  ongoingOrderDuration({
    required this.date,
    required this.orderpreparing,
    required this.readytoship,
    required this.outfordelivery,
    required this.orderdelivered,
    required this.status,
  });
}
