import 'package:difwa/Become_a_seller/profile/Store_Profile_Screen.dart';
import 'package:difwa/Become_a_seller/profile/store_Owner_Profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanner/screens/store_profile_screen.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import '../controlller/auth_controller.dart';
import '../roots/app_root.dart';
import 'Store_Setting.dart';

class MerchantDrawer extends StatelessWidget {
  final String? imageUrl;
  final String? ownerName;
  final String? shopName;
  final String? email;
  final String? mobile;

  const MerchantDrawer({
    Key? key,
    this.imageUrl,
    this.ownerName,
    this.shopName,
    this.email,
    this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    double imageSize = screenWidth * 0.25;

    double headerHeight = screenHeight * 0.33;
    double verticalSpacing = screenHeight * 0.01;

    double textSizeOwnerName = screenWidth * 0.05;
    double textSizeEmail = screenWidth * 0.04;
    double textSizeInfo = screenWidth * 0.038;
    double iconSize = screenWidth * 0.06;


    double iconTextSpacing = screenWidth * 0;
    double drawerWidth = screenWidth * 0.75;

    return Drawer(
      child: Container(
        color: Colors.white,
        width: drawerWidth,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                height: headerHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.08, // Padding from the top of the container
                      right: screenWidth * 0.3,
                      left: screenWidth * 0.025// Padding for alignment
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(imageSize / 2),
                        child: imageUrl != null
                            ? Image.network(
                          imageUrl!,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                            : Image.asset(
                          'assets/images/default_avatar.png',
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Text(
                        ownerName ?? 'Owner Name',
                        style: AppStyle.whiteText20.copyWith(fontSize: textSizeOwnerName),
                      ),
                      Text(
                        email ?? 'Email',
                        style: AppStyle.whiteText18.copyWith(fontSize: textSizeEmail),
                      ),
                      SizedBox(height: verticalSpacing),
                    ],
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                leading: Icon(Icons.person, color: AppColors.primary, size: iconSize),
                title: Padding(
                  padding: EdgeInsets.only(left: iconTextSpacing),
                  child: Text(
                    'Profile',
                    style: AppStyle.heading24Black.copyWith(fontSize: textSizeInfo),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoreOwnerProfileScreen()),
                  );
                },
              ),

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                leading: Icon(Icons.store, color: AppColors.primary, size: iconSize),
                title: Padding(
                  padding: EdgeInsets.only(left: iconTextSpacing),
                  child: Text(
                    'Store',
                    style: AppStyle.heading24Black.copyWith(fontSize: textSizeInfo),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoreProfileScreen()),  // Replace with your screen
                  );
                },
              ),

              // Settings Option
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                leading: Icon(Icons.settings, color: AppColors.primary, size: iconSize),
                title: Padding(
                  padding: EdgeInsets.only(left: iconTextSpacing),
                  child: Text(
                    'Settings',
                    style: AppStyle.heading24Black.copyWith(fontSize: textSizeInfo),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage(
                      toggleTheme: (bool ) {  },
                    )
                    ),  // Replace with your screen
                  );
                },
              ),

              // Logout Option
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                leading: Icon(Icons.logout, color: Colors.red, size: iconSize),
                title: Padding(
                  padding: EdgeInsets.only(left: iconTextSpacing),  child: Text(
                  'Logout',
                  style: AppStyle.heading24Black.copyWith(fontSize: textSizeInfo),
                ),
                ),
                onTap: () async {
                  try {
                    final AuthController authController = Get.find<AuthController>();
                    await authController.logout();
                    Get.offAllNamed(AppRoutes.loginwithmobilenumber);
                  } catch (e) {
                    Get.snackbar('Logout Failed', 'An error occurred while logging out. Please try again.',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
