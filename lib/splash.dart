import 'package:flutter/material.dart';
import 'package:Skilled_worker/authantication/opt_reset_password.dart';
import 'package:Skilled_worker/checkFirstTime.dart';
import 'package:get/get.dart';
import 'package:Skilled_worker/shimmer/waiting_page.dart';
import 'package:Skilled_worker/user_pages/landingPage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), (){
      Get.off(const CheckFirstTime(),transition: Transition.fade, duration: const Duration(milliseconds: 500));
    });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(64,123,255,1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

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
}
