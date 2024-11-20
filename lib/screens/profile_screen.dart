import 'package:flutter/material.dart';

import '../Become_a_seller/Store_on_boarding.dart';
import '../config/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mywhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pritam',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+91 7800730968',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const MenuOption(
              icon: Icons.home,
              title: 'Addresses',
            ),
            const MenuOption(
              icon: Icons.group_add,
              title: 'Invite Friends',
            ),
            const MenuOption(
              icon: Icons.help,
              title: 'Help Center',
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreOnboardingScreen(),
                  ),
                );
              },
              child: const MenuOption(
                icon: Icons.store,
                title: 'Become A Seller',
              ),
            ),
            const MenuOption(
              icon: Icons.info_outline,
              title: 'About Us',
            ),
            const MenuOption(
              icon: Icons.info_outline,
              title: 'About Us',
            ),
            const MenuOption(
              icon: Icons.contact_mail,
              title: 'Contact Us',
            ),
            const MenuOption(
              icon: Icons.contact_mail,
              title: 'Log Out',
            ),
            const MenuOption(
              icon: Icons.contact_mail,
              title: 'Become a dealer',
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuOption({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[700]),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward, size: 24, color: Colors.grey),
        ],
      ),
    );
  }
}
