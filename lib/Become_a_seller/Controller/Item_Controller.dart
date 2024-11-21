import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Models/Add_Store_Item.dart';

class ItemController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addItem(Item item) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }
      String currentUserId = currentUser.uid;

      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('userId', isEqualTo: currentUserId)
          .get();

      if (storeSnapshot.docs.isEmpty) {
        throw Exception('No merchant found for the current user');
      }

      var storeData =
      storeSnapshot.docs.first.data() as Map<String, dynamic>?; // Casting
      String? merchantId;

      if (storeData != null) {
        merchantId = storeData['merchantId']; // Accessing the 'merchantId'
        print("Store Data: $storeData");
        print("Merchant ID: $merchantId");
      } else {
        throw Exception('Store data is null');
      }

      // Get the next item ID
      int itemId = await _getNextItemId();

      Item newItem = Item(
        itemId: itemId.toString(),
        name: item.name,
        price: item.price,
        description: item.description,
        imageUrls: item.imageUrls,
        userId: currentUserId,
        storeUserId: currentUserId,
        merchantId: merchantId,
        category: item.category,
        quantity: item.quantity,
        tiffinName: item.tiffinName,
        tiffinContents: item.tiffinContents,
      );

      // Add the item to Firestore
      await FirebaseFirestore.instance.collection('difwaitems').add(newItem.toMap());
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<int> _getNextItemId() async {
    DocumentReference counterDoc =
    FirebaseFirestore.instance.collection('counters').doc('itemCounter');

    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterDoc);

      if (!snapshot.exists) {
        // Initialize the counter if it doesn't exist
        transaction.set(counterDoc, {'count': 0});
        return 1; // Return the first item ID
      }

      int currentCount =
          (snapshot.data() as Map<String, dynamic>)['count'] ?? 0;
      int newCount = currentCount + 1;
      transaction.update(counterDoc, {'count': newCount}); // Update the count

      return newCount; // Return the new count for itemId
    });
  }

  Future<String> uploadImage(File image) async {
    try {
      String fileName = image.path.split('/').last;
      Reference storageRef =
      FirebaseStorage.instance.ref().child('images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
