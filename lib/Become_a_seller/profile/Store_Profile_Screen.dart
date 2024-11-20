import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_color.dart';
import '../../config/app_styles.dart';
import '../Component/Custom_Dialog.dart';

class StoreProfileScreen extends StatefulWidget {
  @override
  _StoreProfileScreenState createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    print('User UID on profile page: ${user?.uid}');
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    try {
      final file = File(image.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('store_images')
          .child('${user?.uid}.jpg');
      await storageRef.putFile(file);
      String imageUrl = await storageRef.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
      await FirebaseFirestore.instance
          .collection('stores')
          .where('userId', isEqualTo: user?.uid)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference.update({'imageUrl': imageUrl});
        }
      });

      print("Image uploaded successfully: $imageUrl");
    } catch (e) {
      print("Failed to upload image: $e");
    }
  }
  void _showEditDialog(String title, String currentValue,
      TextEditingController controller, String field) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomEditDialog(
          title: title,
          currentValue: currentValue,
          controller: controller,
          field: field,
          onSave: (updatedValue) async {
            print('Updated $field: $updatedValue'); // Save action

            // Save to Firestore (or any other logic)
            await FirebaseFirestore.instance
                .collection('stores')
                .where('userId', isEqualTo: user?.uid)
                .get()
                .then((snapshot) {
              if (snapshot.docs.isNotEmpty) {
                snapshot.docs.first.reference.update({field: updatedValue});
              }
            });

            setState(() {}); // Trigger UI update after saving
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Store Profile', style: AppStyle.headingBlack),
        backgroundColor: Colors.white,
        titleSpacing: 10,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stores')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Store data not found.'));
          }
          final storeData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final imageUrl = _imageUrl ?? storeData['imageUrl'] ?? 'https://via.placeholder.com/150';

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(imageUrl, storeData, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.02),
                  _buildStoreInfoSection(storeData, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(String imageUrl, Map<String, dynamic> storeData, double screenWidth, double screenHeight) {
    double imageSize = screenWidth * 0.3;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                ),
                child: ClipOval(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/default_avatar.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/images/default_avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -3.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.grey,  // Grey border color
                        width: 0.5,          // Border width
                      ),
                    ),
                  ),
                  onPressed: _pickImage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: AppColors.primary),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: screenWidth * 0.04,
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: screenWidth * 0.05),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop: ${storeData['shopName'] ?? 'N/A'}',
              style: AppStyle.heading24Black,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Store ID: ${storeData['merchantId'] ?? 'N/A'}',
              style: AppStyle.greyText16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreInfoSection(Map<String, dynamic> storeData, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        _buildInfoContainer('Business License', storeData['businessLicense'] ?? 'N/A',
            screenWidth, 'businessLicense'),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildInfoContainer('Account Holder Name', storeData['accountHolderName'] ?? 'N/A',
            screenWidth, 'accountHolderName'),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildInfoContainer('Account Number', storeData['accountNumber'] ?? 'N/A',
            screenWidth, 'accountNumber'),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildInfoContainer('IFSC Code', storeData['ifscCode'] ?? 'N/A', screenWidth, 'ifscCode'),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildInfoContainer('Bank Name', storeData['bankName'] ?? 'N/A', screenWidth, 'bankName'),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildInfoContainer('Store Address', storeData['storeaddress'] ?? 'Address not available',
            screenWidth, 'storeaddress'),
        Divider(color: Colors.grey[300], thickness: 1),
      ],
    );
  }

  Widget _buildInfoContainer(String title, String value, double screenWidth, String fieldName) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title:',
                style: AppStyle.heading24Black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () => _showEditDialog(title, value, controller, fieldName),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: AppColors.mywhite,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nexa',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            value,
            style: AppStyle.heading1Black,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
