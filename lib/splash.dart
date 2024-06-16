import 'package:flutter/material.dart';
import 'package:v_bhartiya/authantication/opt_reset_password.dart';
import 'package:v_bhartiya/checkFirstTime.dart';
import 'package:get/get.dart';
import 'package:v_bhartiya/shimmer/waiting_page.dart';
import 'package:v_bhartiya/user_pages/landingPage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), (){
      Get.off(const CheckFirstTime(),transition: Transition.fade, duration: const Duration(milliseconds: 500));
      // Get.off(InternetConnectivityScreen());
      // Get.off(const WaitingPage(),transition: Transition.fade, duration: const Duration(milliseconds: 500));
      // Get.off(const OtpReset(vid: 'vid', phoneNum: '7067597028'),transition: Transition.fade, duration: const Duration(milliseconds: 500));
      // Get.off(const PasswordReset(phoneNum: '+917067597028',),transition: Transition.fade, duration: const Duration(milliseconds: 500));
      // Get.off(const ResetDone(),transition: Transition.fade, duration: const Duration(milliseconds: 500));
    });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(64,123,255,1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     decoration: const BoxDecoration(
          //       // border: Border.all(color: Colors.black, width: 3),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.white,
          //           blurStyle: BlurStyle.normal,
          //           spreadRadius: 20,
          //           blurRadius: 100,
          //         )
          //       ],
          //       borderRadius: BorderRadius.all(Radius.circular(50.0)),
          //       // color: HexColor(cardColor),
          //     ),
          //     child: Image.asset('assets/onboarding/Icon.png'),
          //   ),
          // ),


          Center(
            child: SizedBox(
                width: 200, height: 200, child: Image.asset('assets/onboarding/Icon.png')),
          ),
          const SizedBox(height: 10,),
          const Text('Skilled Worker', style: TextStyle(
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w800,
              fontSize: 35,
              color: Colors.white),
          ),
        ],
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return AnimatedSplashScreen(
  //     backgroundColor: Theme.of(context).colorScheme.primary,
  //     splash: 'assets/onboarding/icon.png',
  //     splashIconSize: 330,
  //     animationDuration: const Duration(seconds: 1),
  //     duration: 2,
  //     nextScreen: const CheckFirstTime(),
  //     splashTransition: SplashTransition.fadeTransition,
  //     disableNavigation: false,
  //     // pageTransitionType: PageTransitionType.scale,
  //   );
  // }
}
