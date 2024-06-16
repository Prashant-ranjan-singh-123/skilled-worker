import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:Skilled_worker/authantication/login_page.dart';
import 'package:Skilled_worker/authantication/sign_up_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginOrSignUpAsking extends StatefulWidget {
  const LoginOrSignUpAsking({super.key});

  @override
  State<LoginOrSignUpAsking> createState() => _LoginOrSignUpAskingState();
}

void logInfun(){
  Get.off(const Login(),transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
}

void signUpfun(){
  Get.off(const SignUpScreen(),transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
}

class _LoginOrSignUpAskingState extends State<LoginOrSignUpAsking> {
  ThemeMode _themeMode = ThemeMode.system;

  double getSmaller() {
    if (Get.width > Get.height) {
      return Get.height;
    }
    return Get.width;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    var brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    return Scaffold(
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top,),
                  Center(
                    child: SizedBox(
                        width: getSmaller() * 0.6,
                        height: getSmaller() * 0.6,
                        // color: Colors.black,
                        child: Image.asset('assets/onboarding/signInOrSignUp.png')),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Let's Get Started",
                    style: TextStyle(
                        color: HexColor('#1F41BB'),
                        fontFamily: 'Poppins',
                        fontSize: 35,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Simplify Your Life',
                    style: TextStyle(
                        color: HexColor('#1F41BB'),
                        fontWeight: FontWeight.w900,
                        fontSize: 35,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 40, left: 40),
                    child: Text(
                      'This Skilled Worker app lets you take control!  Sign up for free and start creating custom categories for the news and updates that matter most to you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 17,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor('#1F41BB'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0, // Remove elevation (shadow) effect
                            ),
                            onPressed: () {
                              logInfun();
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.75,
                                53,
                              ),
                              side: BorderSide(color: Theme.of(context).colorScheme.background), // Border color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              signUpfun();
                            },
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 60,)
                ],
              ),
            ),
          ),
        ));
  }
}
