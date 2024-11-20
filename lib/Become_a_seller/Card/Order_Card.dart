import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_styles.dart';
import '../Models/Order_Model.dart';

class AdminLiveOrderCard extends StatefulWidget {
  final AdminLiveOrder order;
  final Function onAccept;

  AdminLiveOrderCard({
    required this.order,
    required this.onAccept,
  });

  @override
  _AdminLiveOrderCardState createState() => _AdminLiveOrderCardState();
}

class _AdminLiveOrderCardState extends State<AdminLiveOrderCard> {
  bool _showDurations = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Acceptance'),
          content: Text('Are you sure you want to accept this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onAccept();
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var cardPadding = screenWidth * 0.01;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                child: Image.network(
                  'https://coenterprises.com.au/wp-content/uploads/2018/02/male-placeholder-image.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.order.customerName, style: AppStyle.heading1Black,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Order ID: ${widget.order.orderId}', style: AppStyle.heading1Black,),
                      Text('Total: ${widget.order.total}', style: AppStyle.heading1Black,),
                    ],
                  ),
                ],
              ),
              subtitle: Text(widget.order.orderTime, style: AppStyle.heading1Black,),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.order.items
                  .map((item) => Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 1, horizontal: 2),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FixedColumnWidth(100),
                    2: FixedColumnWidth(60),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.name,style: AppStyle.heading1Black,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text('Qty: ${item.qty}',style: AppStyle.heading1Black,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(item.price, style: AppStyle.heading1Black,),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
                  .toList(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Message: ${widget.order.message}', style: AppStyle.heading1Black,),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showDurations = !_showDurations;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Show Durations', style: AppStyle.heading1Black,),
                    Icon(_showDurations
                        ? Icons.expand_less
                        : Icons.calendar_today),
                  ],
                ),
              ),
            ),
            if (_showDurations && widget.order.durations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.order.durations.map((duration) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ${duration.date}',
                                  style: AppStyle.heading1Black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            else if (_showDurations)
              Center(child: Text('No premium order details available')),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _makePhoneCall(widget.order.mobileNumber),
              child: Text(
                'Call Customer: ${widget.order.mobileNumber}',
                style:
                AppStyle.priceheading,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 8),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Accept',
                      style: AppStyle.whiteText18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyle.whiteText18,
                        textAlign: TextAlign.center,
                      ),
                    )

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
