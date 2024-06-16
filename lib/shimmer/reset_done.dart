import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authantication/login_or_signup_page.dart';

class ResetDone extends StatefulWidget {
  const ResetDone({Key? key}) : super(key: key);

  @override
  State<ResetDone>  createState() => _ResetDoneState();
}

class _ResetDoneState extends State<ResetDone> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_){
        Get.offAll(const LoginOrSignUpAsking(), transition: Transition.fade, duration: const Duration(milliseconds: 500));
      },
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 104),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Password reset complete!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'You can now log in securely with your new password. Remember, for optimal account protection, choose a strong password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 72),
              Container(
                height: 257,
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Image.asset('assets/onboarding/Profile.png'),
              ),
              const SizedBox(height: 88),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(const LoginOrSignUpAsking(), transition: Transition.fade, duration: const Duration(milliseconds: 500));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    fixedSize: Size(Get.width, 54),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 88),
            ],
          ),
        ),
      ),
    );
  }
}
