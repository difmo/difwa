import 'package:difwa/config/app_color.dart';
import 'package:difwa/config/app_styles.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MobileNumberPage extends StatefulWidget {
  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController =
      TextEditingController(); // Add this line
  final AuthController authController = Get.put(AuthController());
  bool isLoading = false;

  void _handleLogin() async {
    final phoneNumber = phoneController.text.trim();
    final name = nameController.text.trim(); // Get the name from the controller

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final fullPhoneNumber = '+91$phoneNumber';

    await authController.login(fullPhoneNumber, name);

    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600; // Adjust threshold as needed

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenSize.height * 0.3, // Adjust based on screen height
                child: SvgPicture.asset(
                  'assets/images/login.svg',
                  semanticsLabel: 'Illustration',
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Enter your details",
                style: AppStyle.headingBlack.copyWith(
                  fontSize: isSmallScreen ? 20 : 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Please enter your name and 10-digit mobile number without country code",
                style: AppStyle.greyText18.copyWith(
                  fontSize: isSmallScreen ? 14 : 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
          
              // Name TextField
              TextField(
                controller: nameController,
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: AppStyle.normal.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 20),
          
              // Phone Number TextField
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
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10, // Limit to 10 digits
              ),
              SizedBox(height: 20),
          
              // Continue Button
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
      ),
    );
  }
}
