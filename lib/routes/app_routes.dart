import 'package:difwa/routes/user_bottom_bar.dart';
import 'package:difwa/screens/auth/login_screen.dart';
import 'package:difwa/screens/auth/otp_screnn.dart';
import 'package:difwa/screens/available_service_select.dart';
import 'package:difwa/screens/home_screen.dart';
import 'package:difwa/screens/profile_screen.dart';
import 'package:difwa/screens/splash_screen.dart';
import 'package:difwa/screens/subscription_screen.dart';
import 'package:get/get.dart';

import '../Become_a_seller/Add_Stroe_Item.dart';
import '../Become_a_seller/Create_store.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String splash = '/splash';
  static const String availableservices = '/availableservices';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String userbottom = '/userbottom';
  static const String subscription = '/subscription';


  //////// Admin stuff////////
  static const additem = '/additem';
  static const String CreateStore = '/createstore';


  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const BookNowScreen(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: availableservices,
      page: () => const AvailableServiceSelect(),
    ),
    GetPage(
      name: login,
      page: () => MobileNumberPage(),
    ),
    GetPage(
      name: otp,
      page: () => OTPVerificationPage(),
    ),
    GetPage(
      name: userbottom,
      page: () => const BottomStoreHomePage(),
    ),
    GetPage(
      name: subscription,
      page: () => const SubscriptionScreen(),
    ),


/////////////////////////Admin Routes/////////////////
    GetPage(
      name: additem,
      page: () =>  AddItemPage(),
    ),

    GetPage(
      name: CreateStore,
      page: () => const CreateStorePage(),
    ),

  ];
}
