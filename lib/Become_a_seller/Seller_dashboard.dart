import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import 'Marchante_Detail_screen.dart';
import 'Store_live_order.dart';
import 'Store_product_Screen.dart';

class AdminStatsDashboard extends StatefulWidget {
  const AdminStatsDashboard({Key? key}) : super(key: key);

  @override
  _AdminStatsDashboardState createState() => _AdminStatsDashboardState();
}

class _AdminStatsDashboardState extends State<AdminStatsDashboard> {
  int itemCount = 0;
  int orderCount = 0;
  int activeOrderCount = 0;
  String? merchantId;
  String? ownerName;
  String? shopName;
  String? email;
  String? mobile;
  String? imageUrl;
  late String currentUserId;

  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUserId = user.uid;
          isLoading = true;
        });
        await _fetchMerchantId();
        await _fetchItemCount();
        await _fetchOrderCount();
        await _fetchActiveOrderCount();
        await _fetchMerchantDetails();
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMerchantId() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('storeUserId', isEqualTo: currentUserId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        merchantId = snapshot.docs.first.get('merchantId');
        print('Merchant ID: $merchantId');
      } else {
        print('No items found for this user.');
      }
    } catch (e) {
      print('Error fetching merchant ID: $e');
    }
  }

  Future<void> _fetchItemCount() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('storeUserId', isEqualTo: currentUserId)
          .get();

      setState(() {
        itemCount = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching item count: $e');
    }
  }

  Future<void> _fetchOrderCount() async {
    if (merchantId != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('merchantId', isEqualTo: merchantId)
            .get();

        setState(() {
          orderCount = snapshot.docs.length;
        });
      } catch (e) {
        print('Error fetching order count: $e');
      }
    } else {
      print('Merchant ID is null, cannot fetch order count.');
    }
  }

  Future<void> _fetchActiveOrderCount() async {
    if (merchantId != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('merchantId', isEqualTo: merchantId)
            .where('orderdelivered', isEqualTo: false)
            .get();

        setState(() {
          activeOrderCount = snapshot.docs.length;
        });
      } catch (e) {
        print('Error fetching active order count: $e');
      }
    } else {
      print('Merchant ID is null, cannot fetch active order count.');
    }
  }

  Future<void> _fetchMerchantDetails() async {
    if (merchantId != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('stores')
            .where('userId', isEqualTo: currentUserId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          var merchantData = snapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            ownerName = merchantData['ownerName'];
            shopName = merchantData['shopName'];
            email = merchantData['email'];
            mobile = merchantData['mobile'];
            imageUrl = merchantData['imageUrl'];
          });
        } else {
          print('No store found for this merchant ID.');
        }
      } catch (e) {
        print('Error fetching merchant details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double baseFontSize = screenWidth * 0.05; // Responsive font size

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Admin Dashboard', style: AppStyle.headingWhite.copyWith(fontSize: baseFontSize)),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Container(
        decoration: BoxDecoration(
          color: AppColors.mywhite,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
        ),
        width: screenWidth * 0.7,
        child: MerchantDrawer(
          imageUrl: imageUrl,
          ownerName: ownerName,
          shopName: shopName,
          email: email,
          mobile: mobile,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            // 'product' pageType passed for ProductScreen
            _buildDashboardCard(
              'Available Products',
              itemCount.toString(),
              Colors.blue,
              'Items currently listed',
              baseFontSize,
              'product',
            ),
            _buildDashboardCard(
              'New Orders',
              activeOrderCount.toString(),
              Colors.red,
              'Orders still pending',
              baseFontSize,
              'NewOrders',
            ),
            _buildDashboardCard(
              'Ongoing Orders',
              activeOrderCount.toString(),
              Colors.green,
              'Orders still pending',
              baseFontSize,
              'ongoingOrders',
            ),
            _buildDashboardCard(
              'Past Orders',
              orderCount.toString(),
              Colors.orange,
              'All time orders',
              baseFontSize,
              'pastOrders',
            ),
            _buildDashboardCard(
              'Total Orders',
              activeOrderCount.toString(),
              Colors.indigoAccent,
              'Orders still pending',
              baseFontSize,
              'totalOrders',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      String title,
      String count,
      Color color,
      String description,
      double baseFontSize,
      String pageType,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.05),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.whiteText20.copyWith(fontSize: baseFontSize),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  count,
                  style: AppStyle.whiteText20.copyWith(fontSize: baseFontSize),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  description,
                  style: AppStyle.whiteText16NOrmal.copyWith(fontSize: baseFontSize * 0.8),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              if (pageType == 'product') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()), // Navigate to ProductScreen
                );
              } else if (pageType == 'ongoingOrders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLiveOrderScreen(ongoingOrdersTab: true)),
                );
              }
              else if (pageType == 'NewOrders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLiveOrderScreen()), // Navigate to OngoingOrdersScreen
                );
              }
              else if (pageType == 'pastOrders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLiveOrderScreen(pastOrdersTab: true)),
                );
              }
            },
            child: Text(
              "View",
              style: TextStyle(
                color: color,
                fontSize: baseFontSize * 0.6,
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
