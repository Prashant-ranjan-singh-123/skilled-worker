// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:Skilled_worker/authantication/login_or_signup_page.dart';
// import 'package:Skilled_worker/user_pages/createNotification.dart';
// import 'package:Skilled_worker/user_pages/user_bottom_navigation_screen.dart';
//
// class IsUserLogIn extends StatefulWidget {
//   const IsUserLogIn({super.key});
//   @override
//   State<IsUserLogIn> createState() => _IsUserLogInState();
// }
//
// class _IsUserLogInState extends State<IsUserLogIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context1, snapshot){
//           if(snapshot.hasData){
//             return MainScreenUser();
//           }else{
//             return const LoginOrSignUpAsking();
//           }
//         },
//       ),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Skilled_worker/authantication/login_or_signup_page.dart';
// import 'package:Skilled_worker/user_pages/user_bottom_navigation_screen.dart';
//
// class IsUserLogIn extends StatefulWidget {
//   const IsUserLogIn({Key? key}) : super(key: key);
//
//   @override
//   State<IsUserLogIn> createState() => _IsUserLogInState();
// }
//
// class _IsUserLogInState extends State<IsUserLogIn> {
//   bool _isLoggedIn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     setState(() {
//       _isLoggedIn = isLoggedIn;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoggedIn
//           ? MainScreenUser()
//           : StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context1, snapshot) {
//           if (snapshot.hasData) {
//             return MainScreenUser();
//           } else {
//             return const LoginOrSignUpAsking();
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Skilled_worker/authantication/login_or_signup_page.dart';
import 'package:Skilled_worker/user_pages/user_bottom_navigation_screen.dart';

class IsUserLogIn extends StatefulWidget {
  const IsUserLogIn({Key? key}) : super(key: key);

  @override
  State<IsUserLogIn> createState() => _IsUserLogInState();
}

class _IsUserLogInState extends State<IsUserLogIn> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false; // Set loading to false after retrieving status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _isLoggedIn
          ? MainScreenUser(pageNumber: 0,)
          : StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context1, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return MainScreenUser(pageNumber: 0,);
          } else {
            return const LoginOrSignUpAsking();
          }
        },
      ),
    );
  }
}
