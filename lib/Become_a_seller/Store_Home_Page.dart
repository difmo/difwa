import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../config/app_color.dart';
import '../routes/app_routes.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<StoreHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _generateStaticTokens();
  }

  void _generateStaticTokens() async {
    final user = _auth.currentUser;

    print({"user": user.toString()});
    try {
      final tokensSnapshot = await FirebaseFirestore.instance
          .collection('tokens')
          .where('userId', isEqualTo: user?.uid)
          .limit(1)
          .get();
      print(user);

      if (tokensSnapshot.docs.isEmpty) {
        for (int i = 1; i <= 50; i++) {
          await FirebaseFirestore.instance.collection('tokens').add({
            'token': i.toString(),
            'userId': user?.uid,
            'status': 'Inactive',
            'tokenNumber': i,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('50 inactive tokens generated.')),
        );
      }
    } catch (e) {
      print('Error generating tokens: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate tokens: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print({"usdfg fghdf fg fger": userId});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.mywhite,
        elevation: 8,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primary,
              ),
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.store_profile);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tokens')
            .where('userId', isEqualTo: userId) // Fetch tokens based on userId
            .orderBy('tokenNumber')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child:
              Text('No tokens available.', style: TextStyle(fontSize: 18)),
            );
          }

          final tokens = snapshot.data!.docs;

          final activeTokens = tokens.where((token) {
            var tokenData = token.data() as Map<String, dynamic>;
            return tokenData['status'] == 'Active';
          }).toList();

          final inactiveTokens = tokens.where((token) {
            var tokenData = token.data() as Map<String, dynamic>;
            return tokenData['status'] == 'Inactive';
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildTokenContainer('Active Tokens', activeTokens),
                const SizedBox(height: 20),
                _buildTokenContainer('Inactive Tokens', inactiveTokens),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTokenContainer(
      String title, List<QueryDocumentSnapshot> tokens) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mywhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.center,
              children: tokens.map((token) {
                var tokenData = token.data() as Map<String, dynamic>;
                return _buildTokenWidget(token, tokenData);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenWidget(
      QueryDocumentSnapshot token, Map<String, dynamic> tokenData) {
    return GestureDetector(
      onTap: () async {
        final newStatus =
        tokenData['status'] == 'Active' ? 'Inactive' : 'Active';
        try {
          await FirebaseFirestore.instance
              .collection('tokens')
              .doc(token.id)
              .update({'status': newStatus});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update status: $e')),
          );
        }
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Token Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Token: ${tokenData['token']}'),
                  Text('Status: ${tokenData['status']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 156, 171, 255).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          color: tokenData['status'] == 'Active'
              ? const Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(159, 244, 244, 244),
          shape: BoxShape.circle,
          border: Border.all(
            color: tokenData['status'] == 'Active'
                ? Colors.green
                : const Color.fromARGB(159, 230, 230, 230),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            tokenData['token'],
            style: TextStyle(
              color: tokenData['status'] == 'Active'
                  ? Colors.green
                  : AppColors.inactive,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
