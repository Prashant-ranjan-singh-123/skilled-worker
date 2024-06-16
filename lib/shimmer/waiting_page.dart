import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:v_bhartiya/user_pages/landingPage.dart';

import '../user_pages/user_bottom_navigation_screen.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 3), () {
    //   print('Called Delayed');
    // });
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    return PopScope(
      canPop: false,
      onPopInvoked: (_){
        Get.dialog(
            AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
              shadowColor: Colors.black,
              title: Text(
                "Action not allowed",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
              ),
              content: Text(
                "Sorry, you can't leave this sensitive page. Please complete this process before navigating away.",
                style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
              ),
              actions: [
                MaterialButton(
                  color: Theme.of(context).colorScheme.background,
                  onPressed: (){
                    Get.back();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.9), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 104),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Sending Notification',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Due to a high volume of users, there may be a slight delay in sending your push notification. We appreciate your patience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 72),
              Container(
                height: 257,
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Lottie.asset('assets/onboarding/waiting.json'),
              ),
              const SizedBox(height: 72),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Fun Fact',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'The humble pigeon was once used to deliver notifications! In the 19th century, trained pigeons carried messages strapped to their legs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 88),
            ],
          ),
        ),
      ),
    );
  }
}
