import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(color: Colors.blue),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Pending'),
            Tab(icon: Icon(Icons.check_box), text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const OrderListPage(
            status: 'Pending',
          ),
          const OrderListPage(
            status: 'Completed',
          ),
        ],
      ),
    );
  }
}

class OrderListPage extends StatelessWidget {
  final String status;

  const OrderListPage({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // const TabBar(
          //   indicatorColor: Colors.blue,
          //   labelColor: Colors.blue,
          //   unselectedLabelColor: Colors.grey,
          //   tabs: [
          //     Tab(text: 'Today'),
          //     Tab(text: 'Tomorrow'),
          //   ],
          // ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOrderList(status, 'Today'),
                _buildOrderList(status, 'Tomorrow'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status, String day) {
    // Dummy data
    final orders = [
      {
        'id': '#001',
        'quantity': '3 Bottles',
        'date': '11:00 AM',
        'status': status,
      },
      {
        'id': '#002',
        'quantity': '5 Bottles',
        'date': '12:30 PM',
        'status': status,
      },
      {
        'id': '#003',
        'quantity': '1 Bottle',
        'date': '04:00 PM',
        'status': status,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Order ID: ${order['id']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity: ${order['quantity']}'),
                Text('Delivery Time: ${order['date']}'),
              ],
            ),
            trailing: Text(
              order['status']!,
              style: TextStyle(
                color:
                    order['status'] == 'Pending' ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
