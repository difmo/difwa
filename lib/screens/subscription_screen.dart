import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedFrequencyIndex = 0;
  DateTime? startDate;
  DateTime? endDate;

  // Calculate the total number of days between start and end date
  int getTotalDays() {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays +
          1; // Including both start and end date
    }
    return 0;
  }

  // Function to pick the date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (startDate ?? DateTime.now())
          : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/100', // Replace with product image URL
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Malai Paneer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ingredients: Milk Solid, Common Salt & Food Grade Citric Acid...',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text('200 Gm    ₹98.0'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {},
                            ),
                            Text('1'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Frequency Section
            const Text(
              'Frequency:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text('Every Day'),
                    selected: selectedFrequencyIndex == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('On Interval'),
                    selected: selectedFrequencyIndex == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 1;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Customize'),
                    selected: selectedFrequencyIndex == 2,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 2;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Date Selection
            if (selectedFrequencyIndex == 1 || selectedFrequencyIndex == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date:'),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, true); // True means start date
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: 8),
                            Text(startDate == null
                                ? 'Select date'
                                : DateFormat('dd-MMM-yyyy').format(startDate!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Date (Optional):'),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, false); // False means end date
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: 8),
                            Text(endDate == null
                                ? 'Select date'
                                : DateFormat('dd-MMM-yyyy').format(endDate!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Display Total Days
              if (startDate != null && endDate != null)
                Text('Total Days: ${getTotalDays()} days'),
            ],
            const SizedBox(height: 16),
            // Delivery Info
            const Text(
              'Order By 11:00 PM Today & get delivery by 19-Nov-2024',
              style: TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 16),
            // Wallet Recharge Section
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.blue),
                const SizedBox(width: 8),
                Text('₹ 0.00'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Handle wallet recharge
                  },
                  child: Text('Recharge your wallet'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Offers Button
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle offers navigation
                },
                child: Text('Offers'),
              ),
            ),
            const SizedBox(height: 16),
            // Next Button
            ElevatedButton(
              onPressed: () {
                // Handle next navigation
              },
              child: Text('NEXT'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SubscriptionScreen(),
    Center(child: Text('Second Tab')),
    Center(child: Text('Third Tab')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Second Tab',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
