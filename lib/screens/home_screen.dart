import 'package:difwa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:difwa/config/app_color.dart';
import 'package:get/get.dart';

class BookNowScreen extends StatefulWidget {
  const BookNowScreen({super.key});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  int bottleCount = 1;
  bool noEmptyBottles = false;

  double waterPrice = 30.0;
  double bottlePrice = 150.0;
  double walletBalance = 30.0;

  double get totalPrice {
    double totalWaterPrice = bottleCount * waterPrice;
    double totalBottlePrice = noEmptyBottles ? bottleCount * bottlePrice : 0.0;
    return totalWaterPrice + totalBottlePrice - walletBalance;
  }

  int selectedBottleSize = 20;

  final List<Map<String, dynamic>> bottleSizes = [
    {'size': 20, 'price': 300.0, 'image': 'assets/images/water.jpg'},
    {'size': 20, 'price': 400.0, 'image': 'assets/images/water.jpg'},
    {'size': 50, 'price': 600.0, 'image': 'assets/images/water.jpg'},
    {'size': 100, 'price': 1000.0, 'image': 'assets/images/water.jpg'},
    {'size': 200, 'price': 1800.0, 'image': 'assets/images/water.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mywhite,
      appBar: AppBar(
        title: const Text(
          'Book Now',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Horizontal scrollable cards
            SizedBox(
              height: 200, // Card height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bottleSizes.length,
                itemBuilder: (context, index) {
                  final bottle = bottleSizes[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBottleSize = bottle['size'];
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4,
                      color: selectedBottleSize == bottle['size']
                          ? Colors.blue.shade100
                          : AppColors.mywhite,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              bottle['image'],
                              width: 80, // Set image width
                              height: 80, // Set image height
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${bottle['size']}L',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹ ${bottle['price']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Select number of bottles and total price section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              color: AppColors.mywhite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Choose the number of bottles you would like to buy.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (bottleCount > 1) {
                              setState(() {
                                bottleCount--;
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_drop_down, size: 32),
                        ),
                        Text(
                          '$bottleCount',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              bottleCount++;
                            });
                          },
                          icon: const Icon(Icons.arrow_drop_up, size: 32),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: noEmptyBottles,
                          onChanged: (value) {
                            setState(() {
                              noEmptyBottles = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "I don't have empty bottles to return",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Water Price:'),
                        Text(
                          '₹ ${bottleCount * waterPrice}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bottle Price:'),
                        Text(
                          noEmptyBottles
                              ? '₹ ${bottleCount * bottlePrice}'
                              : '₹ 0.0',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Wallet Balance:'),
                        Text(
                          '- ₹ $walletBalance',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Text(
                          '₹ ${totalPrice.toStringAsFixed(1)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // One-Time Order Button
                ElevatedButton(
                  onPressed: () {
                    // Handle one-time order action
                    print("One-time order placed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                  child: const Text(
                    "Order Now",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.subscription);
                    print("Subscription placed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Subscribe",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
