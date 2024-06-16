import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Skilled_worker/authantication/is_user_login.dart';
import 'on_boarding/config_on_boarding_page.dart';


class CheckFirstTime extends StatefulWidget {
  const CheckFirstTime({Key? key});

  @override
  State<CheckFirstTime> createState() => _CheckFirstTimeState();
}

class _CheckFirstTimeState extends State<CheckFirstTime> {
  late Future<bool> isFirstRun;
  @override
  void initState() {
    super.initState();
    isFirstRun = ifFirstRun();
    // requestPermission();
  }

  Future<bool> ifFirstRun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirst') ?? true;
    if (isFirstRun) {
      await prefs.setBool('isFirst', false);
      return true;
    } else {
      // return true;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ifFirstRun(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if(isFirstRun==true){
            print('\n\n'+'1'+'\n\n');
            return const OnBoardingScreen();
          }else if (snapshot.data == true) {
            print('\n\n'+'2'+'\n\n');
            return const OnBoardingScreen();
          }else {
            print('\n\n'+'3'+'\n\n');
            return const IsUserLogIn();
          }
        }
      },
    );
  }
}

