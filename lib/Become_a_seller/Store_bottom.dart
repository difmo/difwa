import 'package:flutter/material.dart';
import 'Seller_dashboard.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import 'Store_live_order.dart';
import 'Store_product_Screen.dart';

class BottomStoreHomePage extends StatefulWidget {
  const BottomStoreHomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomStoreHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminStatsDashboard(),
    ProductScreen(),
    AdminLiveOrderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar:
      Container(
        margin: const EdgeInsets.only(
          bottom: 0,
        ),
        padding: const EdgeInsets.only(top: 5.0),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Home ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store, size: 30),
                label: 'Product',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag, size: 30),
                label: 'Order',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.darkGrey,
            selectedLabelStyle: AppStyle.selectedTabStyle,
            unselectedLabelStyle: AppStyle.unSelectedTabStyle,
          ),
        ),
      ),
    );
  }
}
