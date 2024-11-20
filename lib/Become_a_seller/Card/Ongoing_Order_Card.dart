import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../config/app_styles.dart';
import '../Controller/Order_Controller.dart';
import '../Models/Order_Model.dart';

class OngoingOrderCardData extends StatefulWidget {
  final ongoingOrderCardData data;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDelivered;

  OngoingOrderCardData({
    required this.data,
    required this.onStatusChanged,
    required this.onDelivered,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OngoingOrderCardData> {
  late String selectedStatus;
  final Map<String, bool> _buttonDisabled = {
    'Order Preparing': false,
    'Order Dispatched': false,
    'On the way': false,
    'Mark as Delivered': false,
  };

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.data.status;
  }

  void _showConfirmationDialog(String newStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Status Change'),
          content: Text(
              'Are you sure you want to change the status to "$newStatus"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedStatus = newStatus;
                  _buttonDisabled[newStatus] = true; // Disable button
                });
                _updateOrderStatus(newStatus);
                widget.onStatusChanged(newStatus);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _updateOrderStatus(String newStatus) async {
    String orderId = widget.data.orderId;
    Map<String, dynamic> updates = {};
    bool foundMatch = false;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot orderSnapshot =
    await _firestore.collection('orders').doc(orderId).get();
    List<dynamic> durations = orderSnapshot['durations'];

    switch (newStatus) {
      case 'Order Preparing':
        updates['orderpreparing'] = true;
        updates['preparingTime'] = FieldValue.serverTimestamp();
        foundMatch = true;
        break;
      case 'On the way':
        updates['outfordelivery'] = true;
        updates['onTheWayTime'] = FieldValue.serverTimestamp();
        foundMatch = true;
        break;
      case 'Order Dispatched':
        updates['readytoship'] = true;
        updates['dispatchedTime'] = FieldValue.serverTimestamp();
        foundMatch = true;
        break;
      case 'Mark as Delivered':
        updates['orderdelivered'] = true;
        updates['deliveredTime'] = FieldValue.serverTimestamp();
        foundMatch = true;
        break;
    }

    if (foundMatch) {
      try {
        if (durations.isNotEmpty) {
          await ongoingOrderController(FirebaseFirestore.instance)
              .updateDurationsStatus(orderId, newStatus);
        } else {
          await ongoingOrderController(FirebaseFirestore.instance)
              .updateOrderStatus(orderId, updates);
        }
      } catch (e) {
        print('Error updating order status: $e');
      }
    }
  }

  Color _getButtonColor(String status) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // String currentDate = "2024-10-25";

    var durationEntry = widget.data.durations.firstWhere(
          (duration) => duration.date == currentDate,
      orElse: () => ongoingOrderDuration(
        date: currentDate,
        orderpreparing: false,
        readytoship: false,
        outfordelivery: false,
        orderdelivered: false,
        status: false,
      ),
    );

    switch (status) {
      case 'Order Preparing':
        return durationEntry.orderpreparing ? Colors.green : Colors.red;
      case 'On the way':
        return durationEntry.outfordelivery ? Colors.green : Colors.red;
      case 'Order Dispatched':
        return durationEntry.readytoship ? Colors.green : Colors.red;
      case 'Mark as Delivered':
        return durationEntry.orderdelivered ? Colors.green : Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAlreadyDoneMessage(String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Status Already Done'),
          content: Text('The status "$status" is already marked as done.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.data.name, style: AppStyle.heading1Black,),
              subtitle: Text(
                'Order ID: ${widget.data.orderId} \nTotal: ${widget.data.total} \nTime: ${widget.data.time}',
                style: AppStyle.heading1Black,),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '${item.name} (Qty: ${item.qty}) - \$${item.price.toStringAsFixed(2)}',
                    style: AppStyle.heading1Black,),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('Durations:', style: AppStyle.heading1Black),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.durations.map((duration) {
                return Text(
                  '${duration.date}: ${duration.status}',
                  style: AppStyle.greyText16,
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _buttonDisabled['Order Confirmed'] == true
                        ? null
                        : () => {},
                    child: Text('Order Confirmed', style: AppStyle.whiteText18,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _buttonDisabled['Order Confirmed'] == true
                          ? Colors.grey
                          : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _buttonDisabled['Order Preparing'] == true
                        ? null
                        : () {
                      if (_getButtonColor('Order Preparing') ==
                          Colors.green) {
                        _showAlreadyDoneMessage('Order Preparing');
                      } else {
                        _showConfirmationDialog('Order Preparing');
                      }
                    },
                    child: Text('Order Preparing', style: AppStyle.whiteText18,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('Order Preparing'),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _buttonDisabled['Order Dispatched'] == true
                        ? null
                        : () {
                      if (_getButtonColor('Order Dispatched') ==
                          Colors.green) {
                        _showAlreadyDoneMessage('Order Dispatched');
                      } else {
                        _showConfirmationDialog('Order Dispatched');
                      }
                    },
                    child: Text('Order Dispatched',style: AppStyle.whiteText18,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('Order Dispatched'),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _buttonDisabled['On the way'] == true
                        ? null
                        : () {
                      if (_getButtonColor('On the way') == Colors.green) {
                        _showAlreadyDoneMessage('On the way');
                      } else {
                        _showConfirmationDialog('On the way');
                      }
                    },
                    child: Text('On the way',style: AppStyle.whiteText18,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('On the way'),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _buttonDisabled['Mark as Delivered'] == true
                        ? null
                        : () {
                      if (_getButtonColor('Mark as Delivered') ==
                          Colors.green) {
                        _showAlreadyDoneMessage('Mark as Delivered');
                      } else {
                        _showConfirmationDialog('Mark as Delivered');
                      }
                    },
                    child: Text('Mark as Delivered',style: AppStyle.whiteText18,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor('Mark as Delivered'),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
