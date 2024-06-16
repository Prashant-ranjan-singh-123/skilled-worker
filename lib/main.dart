import 'package:Skilled_worker/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Skilled_worker/checkFirstTime.dart';
import 'package:Skilled_worker/shimmer/profile_shimmer.dart';
import 'package:Skilled_worker/shimmer/pushnotification_shimmer.dart';
import 'package:Skilled_worker/splash.dart';
import 'package:Skilled_worker/theme/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Skilled_worker/utils/Internet/CheckInternetConnectionWidget.dart';
import 'notifications_things_plus_num_fetch/save_notification_shared_pref.dart';

late String? _number;

Future<String?> getLogInNum() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? num = pref.getString('logedInNum');
  _number = num;
  print('Number is: $_number');
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('handling Background Message: ${message.messageId}');
  // await getLogInNum()
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAqFBiuJOtDmt4BjyqgxH4MXJVidBJafGM",
        authDomain: "skilled-worker-123.firebaseapp.com",
        projectId: "skilled-worker-123",
        storageBucket: "skilled-worker-123.appspot.com",
        messagingSenderId: "607762715095",
        appId: "1:607762715095:android:4d7a2575be2c642a857b92",
      )
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessagingBackgroundHandler(message));
  runApp(GetMaterialApp(
    home: const SplashScreen(),
    // home: const NotificationExpand(),
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    darkTheme: darkTheme,
  ));
}



// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:Skilled_worker/checkFirstTime.dart';
// import 'package:Skilled_worker/theme/themes.dart';
// import 'package:firebase_core/firebase_core.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//
//   // await Firebase.initializeApp();
//   // await Firebase.initializeApp(
//   //     options: const FirebaseOptions(
//   //         apiKey: "AIzaSyBE8kbMTZYLAkTg0OXsKqDUshULyfCvNeE",
//   //         authDomain: "skilled-worker-b4ccc.firebaseapp.com",
//   //         projectId: "skilled-worker-b4ccc",
//   //         storageBucket:  "skilled-worker-b4ccc.appspot.com",
//   //         messagingSenderId:  "1026766899024",
//   //         appId: "1:1026766899024:android:c5ac4aa94114500db7ce55",
//   //         measurementId: ""
//   //     )
//   // );
//
//   await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyAqFBiuJOtDmt4BjyqgxH4MXJVidBJafGM",
//         authDomain: "skilled-worker-123.firebaseapp.com",
//         projectId: "skilled-worker-123",
//         storageBucket: "skilled-worker-123.appspot.com",
//         messagingSenderId: "607762715095",
//         appId: "1:607762715095:android:4d7a2575be2c642a857b92",
//       )
//   );
//
//   await FirebaseMessaging.instance.getInitialMessage();
//
//   runApp(GetMaterialApp(
//     home: const CheckFirstTime(),
//     debugShowCheckedModeBanner: false,
//     theme: lightTheme,
//     darkTheme: darkTheme,
//   ));
// }