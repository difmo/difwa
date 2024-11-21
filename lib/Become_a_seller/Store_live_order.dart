import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'Card/Order_Card.dart';
import 'Controller/Order_Controller.dart';
import 'Models/Order_Model.dart';
import 'Orders/Ongoing_Order.dart';
import 'Orders/Order_History.dart';

class AdminLiveOrderScreen extends StatefulWidget {
  final bool ongoingOrdersTab;
  final bool pastOrdersTab;
  AdminLiveOrderScreen({
    this.ongoingOrdersTab = false,
    this.pastOrdersTab = false,
  });

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<AdminLiveOrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminOrderController _controller = AdminOrderController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.ongoingOrdersTab) {
      _tabController.index = 1;
    } else if (widget.pastOrdersTab) {
      _tabController.index = 2;
    } else {
      _tabController.index = 0;
    }
  }
  void _playNotification() async {
    await _audioPlayer.play(AssetSource("audio/order.mp3"));
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Our Orders', style: AppStyle.headingBlack),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'New Orders'),
            Tab(text: 'Ongoing Orders'),
            Tab(text: 'Past Orders'),
          ],
          labelStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Nexa',
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nexa',
          ),
          indicatorColor: AppColors.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderListView(
            controller: _controller,
            playNotification: _playNotification,
          ),
          OngoingOrdersScreen(),
          OrdersHistoryScreen(),
        ],
      ),
    );
  }
}


class OrderListView extends StatefulWidget {
  final AdminOrderController controller;
  final Function playNotification;

  OrderListView({required this.controller, required this.playNotification});

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  String merchantId = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: widget.controller.getCurrentUser(),
      builder: (context, difwauserSnapshot) {
        if (difwauserSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!difwauserSnapshot.hasData || difwauserSnapshot.data == null) {
          return Center(child: Text('User not logged in'));
        }

        final user = difwauserSnapshot.data!;
        return StreamBuilder<QuerySnapshot>(
          stream: widget.controller.getStores(user.uid),
          builder: (context, storesSnapshot) {
            if (storesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (storesSnapshot.hasError) {
              return Center(child: Text('Error: ${storesSnapshot.error}'));
            }

            final stores = storesSnapshot.data?.docs ?? [];
            if (stores.isEmpty) {
              return Center(child: Text('No stores found for this user.'));
            }

            final storeData = stores.first.data() as Map<String, dynamic>?;
            merchantId = storeData?['merchantId'] ?? '';

            return StreamBuilder<QuerySnapshot>(
              stream: widget.controller.getOrders(merchantId),
              builder: (context, ordersSnapshot) {
                if (ordersSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (ordersSnapshot.hasError) {
                  return Center(child: Text('Error: ${ordersSnapshot.error}'));
                }

                final orders = ordersSnapshot.data?.docs ?? [];
                if (orders.isEmpty) {
                  return Center(
                      child: Text('No orders available at this time.'));
                }

                bool newOrderFound = false;
                for (var order in orders) {
                  final orderData = order.data() as Map<String, dynamic>?;
                  if (orderData != null &&
                      !orderData['orderconfirmed'] &&
                      !newOrderFound) {
                    widget.playNotification(); // Call the notification function
                    newOrderFound = true;
                  }
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData =
                    orders[index].data() as Map<String, dynamic>?;

                    if (orderData == null ||
                        orderData['orderconfirmed'] == true) {
                      return SizedBox();
                    }

                    AdminLiveOrder order = AdminLiveOrder(
                      customerName: orderData['address']['name'] ?? 'Unknown',
                      orderId: orderData['orderId'] ?? 'N/A',
                      total:
                      '\$${orderData['totalCost']?.toStringAsFixed(2) ?? '0.00'}',
                      orderTime: orderData['orderDate']?.toDate().toString() ??
                          'Unknown time',
                      items: (orderData['items'] as List<dynamic>? ?? [])
                          .map((item) {
                        return AdminLiveOrderItem(
                          name: item['name'] ?? 'Unknown item',
                          qty: item['quantity']?.toString() ?? '0',
                          price: '\$${item['price'] ?? '0.00'}',
                        );
                      }).toList(),
                      durations:
                      (orderData['durations'] as List<dynamic>? ?? [])
                          .map((item) {
                        return OrderDuration(
                          date: item['date'] ?? 'Unknown item',
                          status: item['status'] ?? 'Unknown item',
                        );
                      }).toList(),
                      message: orderData['address']['fullAddress'] ??
                          'No message provided.',
                      mobileNumber: orderData['address']['mobile'] ?? 'N/A',
                    );

                    return AdminLiveOrderCard(
                      order: order,
                      onAccept: () async {
                        await widget.controller.acceptOrder(orders[index].id);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
