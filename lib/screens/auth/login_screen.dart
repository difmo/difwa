import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNumberPage extends StatefulWidget {
  const MobileNumberPage({super.key});

  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  // Updated _handleLogin without any validation
  void _handleLogin() {
    // final phoneNumber = phoneController.text.trim();

    // Set loading state to true to show progress indicator
    setState(() {
      isLoading = true;
    });

    // Simulate a delay (e.g., API call or processing)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

      // Navigate to OTP screen without validation (pass phone number if needed)
      Get.toNamed(AppRoutes.otp); // Pass the phone number to OTP screen
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG image for illustration
            // SizedBox(
            //   height: screenSize.height * 0.3, // Adjust based on screen height
            //   child: SvgPicture.asset(
            //     'assets/images/login.svg',
            //     semanticsLabel: 'Illustration',
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              "Enter your mobile number",
              style: AppStyle.headingBlack.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Please enter your 10-digit mobile number without country code",
              style: AppStyle.greyText18.copyWith(
                fontSize: isSmallScreen ? 14 : 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // TextField to enter the mobile number
            TextField(
              cursorColor: AppColors.primary,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: AppStyle.normal.copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              cursorColor: AppColors.primary,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Mobile number",
                labelStyle: AppStyle.normal.copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10, // Limit to 10 digits (if needed)
            ),
            const SizedBox(height: 20),
            // Continue button
            SizedBox(
              width: double.infinity,
              height: isSmallScreen
                  ? 50
                  : 50, // Adjust button height for small screens
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.mywhite),
                      )
                    : const Text(
                        "CONTINUE",
                        style: AppStyle.headingWhite,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
