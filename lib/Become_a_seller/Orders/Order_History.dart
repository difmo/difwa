import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/app_styles.dart';
class OrdersHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OrderList(),
    );
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('orderdelivered', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(child: Text('No orders delivered.'));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = orders[index].data() as Map<String, dynamic>;

            return OrderCard(
              data: OrderCardData(
                name: orderData['address']?['name'] ?? 'Unknown',
                orderId: orderData['orderId'] ?? 'N/A',
                total: '\₹${(orderData['totalCost'] ?? 0).toStringAsFixed(2)}',
                time: orderData['orderDate']?.toDate().toString() ??
                    'Unknown time',
                imageUrl:
                'https://coenterprises.com.au/wp-content/uploads/2018/02/male-placeholder-image.jpeg',
                items: (orderData['items'] as List<dynamic>? ?? []).map((item) {
                  return OrderItem(
                    name: item['name'] ?? 'Unknown item',
                    qty: item['quantity'] ?? 0,
                    price: (item['price'] ?? 0).toDouble(),
                  );
                }).toList(),
                status: orderData['orderstatus'] ?? 'Unknown status',
              ),
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  final OrderCardData data;

  OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.name, style: AppStyle.heading1Black,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Order ID: ${data.orderId}', style: AppStyle.heading1Black,),
                      Text('Total: \$${data.total}', style: AppStyle.heading1Black,),
                    ],
                  ),
                ],
              ),
              subtitle: Text(data.time, style: AppStyle.heading1Black,),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '${item.name} (Qty: ${item.qty}) - \$${item.price.toStringAsFixed(2)}',
                    style: AppStyle.heading1Black,),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStatusMessage(data.status),
                  style: AppStyle.heading1Black,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text('View Details', style: AppStyle.priceheading,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'Order Delivered':
        return 'Order is successfully delivered';
      case 'Order Cancelled':
        return 'Order is cancelled';
      default:
        return 'Status: $status';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Delivered':
        return Colors.green;
      case 'Order Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

class OrderCardData {
  final String name;
  final String orderId;
  final String total;
  final String time;
  final String imageUrl;
  final List<OrderItem> items;
  final String status;

  OrderCardData({
    required this.name,
    required this.orderId,
    required this.total,
    required this.time,
    required this.imageUrl,
    required this.items,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final int qty;
  final double price;

  OrderItem({
    required this.name,
    required this.qty,
    required this.price,
  });
}
