import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../routes/app_routes.dart';
import '../Models/Store_Model.dart';

class SignupController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final upiIdController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final ownernameController = TextEditingController();
  final shopnameController = TextEditingController();
  final storeaddressController = TextEditingController();
  File? imageFile;

  // Dispose controllers to prevent memory leaks
  @override
  void onClose() {
    upiIdController.dispose();
    emailController.dispose();
    mobileController.dispose();
    ownernameController.dispose();
    shopnameController.dispose();
    storeaddressController.dispose();
    super.onClose();
  }

  Future<void> submitForm(File? image) async {
    if (_formKey.currentState!.validate()) {
      try {
        String userId = await _getCurrentUserId();
        String merchantId = await _generateMerchantId();

        String? imageUrl;
        if (imageFile != null) {
          imageUrl = await _uploadImage(imageFile!, userId);
        }

        UserModel newUser = _createUserModel(userId, merchantId, imageUrl);

        await _updateUserRole(userId);
        await _saveUserStore(newUser);

        _showSuccessSnackbar(merchantId);
        Get.offNamed(AppRoutes.storebottombar);
      } catch (e) {
        _handleError(e);
      }
    }
  }

  Future<String> _getCurrentUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return currentUser.uid;
  }

  Future<String> _generateMerchantId() async {
    String year = DateTime.now()
        .year
        .toString()
        .substring(2); // Get last two digits of the year
    QuerySnapshot userCountSnapshot =
    await FirebaseFirestore.instance.collection('difwastores').get();
    int userCount =
        userCountSnapshot.docs.length + 1;
    return 'GS$year${userCount.toString().padLeft(7, '0')}';
  }

  Future<String> _uploadImage(File imageFile, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/$userId/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  UserModel _createUserModel(
      String userId, String merchantId, String? imageUrl) {
    return UserModel(
      userId: userId,
      upiId: upiIdController.text,
      mobile: mobileController.text,
      email: emailController.text,
      shopName: shopnameController.text,
      ownerName: ownernameController.text,
      merchantId: merchantId,
      uid: userId,
      storeaddress: storeaddressController.text,
      imageUrl: imageUrl,
    );
  }

  void setImage(File image) {
    imageFile = image;
  }

  Future<void> _updateUserRole(String userId) async {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'role': 'isStoreKeeper'});
    } else {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'role': 'isStoreKeeper',
        'userId': userId,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _saveUserStore(UserModel newUser) async {
    await FirebaseFirestore.instance
        .collection('stores')
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  void _showSuccessSnackbar(String merchantId) {
    Get.snackbar(
      'Success',
      'Signup Successful with Merchant ID: $merchantId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _handleError(dynamic e) {
    String errorMessage = e is FirebaseAuthException
        ? e.message ?? 'An unknown error occurred'
        : 'An unknown error occurred';
    Get.snackbar('Error', errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  GlobalKey<FormState> get formKey => _formKey;
}
