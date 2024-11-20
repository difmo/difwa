import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Card/Ongoing_Order_Card.dart';
import '../Controller/Order_Controller.dart';
import '../Models/Order_Model.dart';

class OngoingOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OrderList(
          controller: ongoingOrderController(FirebaseFirestore.instance)),
    );
  }
}

class OrderList extends StatelessWidget {
  final ongoingOrderController controller;

  OrderList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getOngoingOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(child: Text('No ongoing orders.'));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = orders[index].data() as Map<String, dynamic>;

            return OngoingOrderCardData(
              data: ongoingOrderCardData(
                name: orderData['address']?['name'] ?? 'Unknown',
                orderId: orderData['orderId'] ?? 'N/A',
                total: '\$${(orderData['totalCost'] ?? 0).toStringAsFixed(2)}',
                time: orderData['orderDate']?.toDate().toString() ??
                    'Unknown time',
                imageUrl:
                'https://coenterprises.com.au/wp-content/uploads/2018/02/male-placeholder-image.jpeg',
                items: (orderData['items'] as List<dynamic>? ?? []).map((item) {
                  return ongoingOrderItem(
                    name: item['name'] ?? 'Unknown item',
                    qty: item['quantity'] ?? 0,
                    price: (item['price'] ?? 0).toDouble(),
                  );
                }).toList(),
                status: orderData['orderstatus'] ?? 'Unknown status',
                durations: (orderData['durations'] as List<dynamic>? ?? [])
                    .map((duration) {
                  return ongoingOrderDuration(
                    date: duration['date'],
                    orderpreparing: duration['orderpreparing'] ?? false,
                    readytoship: duration['readytoship'] ?? false,
                    outfordelivery: duration['outfordelivery'] ?? false,
                    orderdelivered: duration['orderdelivered'] ?? false,
                    status: duration['status'] ?? false,
                  );
                }).toList(),
                orderpreparing: orderData['durations']
                    .any((duration) => duration['orderpreparing'] == true),
                outfordelivery: orderData['durations']
                    .any((duration) => duration['outfordelivery'] == true),
                readytoship: orderData['durations']
                    .any((duration) => duration['readytoship'] == true),
                orderdelivered: orderData['durations']
                    .any((duration) => duration['orderdelivered'] == true),
              ),
              onStatusChanged: (newStatus) {
                print(newStatus);
              },
              onDelivered: () async {
                try {
                  await controller.updateOrderStatus(
                      orderData['orderId'], {'orderdelivered': true});
                } catch (e) {
                  print('Error updating order: $e');
                }
              },
            );
          },
        );
      },
    );
  }
}
