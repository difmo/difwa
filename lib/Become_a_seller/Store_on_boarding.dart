import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:scanner/configs/app_colors.dart';
// import 'package:scanner/roots/app_root.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
// import '../configs/app_styles.dart';
import '../routes/app_routes.dart';

class StoreOnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<StoreOnboardingScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Widget> _buildPageIndicator() {
    return List.generate(
      3, // Number of pages
          (index) => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: 10.0,
        width: _currentIndex == index ? 20.0 : 10.0,
        decoration: BoxDecoration(
          color: _currentIndex == index ? AppColors.primary : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _onSkip() {
    _pageController.jumpToPage(2);
  }

  void _onNext() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Directly navigate to the create store page
      Get.toNamed(AppRoutes.CreateStore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildOnboardingPage(
                topImage: 'assets/images/stonb1.svg',
                middleImage: 'assets/images/stonb11.svg',
                title: 'Fresh Water',
                topImageHeight: 400,
                newHeading: 'Healthy Choices!',
                newDescription:
                'Choose from a variety of nutritious options every day.',
                titleColor: Colors.white,
                showButton: false,
              ),
              _buildOnboardingPage(
                topImage: 'assets/images/stonb2.svg',
                middleImage: 'assets/images/stonb22.svg',
                title: 'Quality Ingredients',
                topImageHeight: 230,
                newHeading: 'Farm to Table!',
                newDescription: 'Experience the freshness of local produce.',
                titleColor: Colors.black,
                showButton: false,
              ),
              _buildOnboardingPage(
                topImage: 'assets/images/stonb3.svg',
                middleImage: 'assets/images/stonb33.svg',
                title: 'Start Today!',
                topImageHeight: 440,
                newHeading: 'Join Our Community!',
                newDescription:
                'Connect with fellow food lovers and share recipes.',
                titleColor: Colors.white,
                showButton: true, // Show button on the last page
                onNextPressed: _onNext, // Pass the callback
              ),
            ],
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String topImage,
    required String middleImage,
    required String title,
    required double topImageHeight,
    required String newHeading,
    required String newDescription,
    required Color titleColor,
    required bool showButton, // New parameter for showing button
    VoidCallback? onNextPressed, // Callback for button press
  }) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              topImage,
              fit: BoxFit.fill,
              height: topImageHeight,
            ),
          ),
          // Center the content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: AppStyle.heading1.copyWith(color: titleColor),
                  ),
                ),
                SizedBox(height: 130), // Space before the middle image
                // Middle image centered in the remaining space
                SvgPicture.asset(
                  middleImage,
                  height: 250,
                ),
                SizedBox(height: 30), // Space after the middle image
                // New Heading below the middle image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    newHeading,
                    style: AppStyle.heading1
                        .copyWith(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                // New Description below the new heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    newDescription,
                    textAlign: TextAlign.center,
                    style: AppStyle.greyText18
                        .copyWith(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(height: 30),
                // Button on the last page
                if (showButton)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.red), // Set text color
                    ),
                    onPressed: onNextPressed, // Call the passed function
                    child: Text(
                      "Create My Store",
                      style: TextStyle(
                          color: Colors.red), // Ensure text color is red
                    ),
                  ),

                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
