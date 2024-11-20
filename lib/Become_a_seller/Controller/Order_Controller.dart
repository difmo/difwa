import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AdminOrderController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Stream<QuerySnapshot> getStores(String userId) {
    return _firestore
        .collection('stores')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getOrders(String merchantId) {
    return _firestore
        .collection('orders')
        .where('merchantId', isEqualTo: merchantId)
        .snapshots();
  }

  Future<void> acceptOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'orderconfirmed': true,
      'orderconfirmedtimeanddate': FieldValue.serverTimestamp(),
    });
  }
}

class ongoingOrderController {
  final FirebaseFirestore _firestore;

  ongoingOrderController(this._firestore);

  Stream<QuerySnapshot> getOngoingOrders() {
    return _firestore
        .collection('orders')
        .where('orderconfirmed', isEqualTo: true)
        .where('orderdelivered', isEqualTo: false)
        .snapshots();
  }

  Future<void> updateOrderStatus(
      String orderId, Map<String, dynamic> updates) async {
    await _firestore.collection('orders').doc(orderId).update(updates);
  }

  Future<void> updateDurationsStatus(String orderId, String newStatus) async {
    DocumentSnapshot orderSnapshot =
    await _firestore.collection('orders').doc(orderId).get();

    if (orderSnapshot.exists) {
      List<dynamic> durations = orderSnapshot['durations'];
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // String currentDate = "2024-10-25";

      DateTime now = DateTime.now();

      bool foundMatch = false;

      for (int i = 0; i < durations.length; i++) {
        if (durations[i]['date'] == currentDate) {
          switch (newStatus) {
            case 'Order Preparing':
              durations[i]['orderpreparing'] = true;
              durations[i]['preparingTime'] = now;
              break;
            case 'On the way':
              durations[i]['outfordelivery'] = true;
              durations[i]['deliveryTime'] = now;
              break;
            case 'Order Dispatched':
              durations[i]['readytoship'] = true;
              durations[i]['dispatchedTime'] = now;
              break;
            case 'Mark as Delivered':
              durations[i]['orderdelivered'] = true;
              durations[i]['deliveredTime'] = now;
              break;
          }
          foundMatch = true;
          break;
        }
      }

      if (foundMatch) {
        await _firestore.collection('orders').doc(orderId).update({
          'durations': durations,
        });

        bool allDurationsTrue = true;

        for (var duration in durations) {
          bool allFieldsTrue = duration['orderpreparing'] &&
              duration['outfordelivery'] &&
              duration['readytoship'] &&
              duration['orderdelivered'];

          duration['status'] = allFieldsTrue;

          if (!allFieldsTrue) {
            allDurationsTrue = false;
          }
        }

        await _firestore.collection('orders').doc(orderId).update({
          'orderdelivered': allDurationsTrue,
        });

        await _firestore.collection('orders').doc(orderId).update({
          'durations': durations,
        });
      } else {
        await _firestore.collection('orders').doc(orderId).update({
          'orderdelivered': false,
          'orderpreparing': false,
          'outfordelivery': false,
          'readytoship': false,
        });
      }
    }
  }
}
