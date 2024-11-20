import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationId = ''.obs;
  var userRole = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _auth.authStateChanges().listen(_handleAuthStateChanged);
  }

  Future<void> login(String phoneNumber, String name) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _saveUserData(name); // Pass name to _saveUserData
        await _fetchUserRole();
        _navigateToDashboard();
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Verification failed');
      },
      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        Get.toNamed(AppRoutes.otp);
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  Future<void> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      await _saveUserData(""); // Empty name when OTP is verified
      await _fetchUserRole();
      _navigateToDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  Future<void> _saveUserData(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('difwausers').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('difwausers').doc(user.uid).set({
          'mobileNumber': user.phoneNumber,
          'uid': user.uid,
          'role': 'isUser',
          'name': name, // Save the name to Firestore
        }, SetOptions(merge: true));
      } else {
        // Update name if it exists already
        await _firestore.collection('difwausers').doc(user.uid).update({
          'name': name,
        });
      }
    }
  }

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('difwausers').doc(user.uid).get();
      if (userDoc.exists) {
        userRole.value = userDoc['role'] ?? 'isUser';
      } else {
        userRole.value = 'isUser';
      }
    }
  }

  void _handleAuthStateChanged(User? user) {
    if (user != null) {
      _firestore
          .collection('difwausers')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          userRole.value = doc.data()?['role'] ?? 'isUser';
          _navigateToDashboard();
        }
      });
    }
  }

  void _navigateToDashboard() {
    if (userRole.value == 'isUser') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else if (userRole.value == 'isStoreKeeper') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else {
      Get.offAllNamed(AppRoutes.userbottom);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error logging out: $e');
    }
  }
}
