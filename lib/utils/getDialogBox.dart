// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class DialogBox{
//   void twoActionButtonDialog(BuildContext context){ // Pass BuildContext as a parameter
//     Get.defaultDialog(
//       backgroundColor: Colors.white, // Set the background color to white
//       title: 'Confirm Logout',
//       content: Text(
//         "Are you sure you want to log out?",
//         style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w500),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Get.back(result: false);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.background,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: const EdgeInsets.all(12.0),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () async {
//             try {
//               await FirebaseAuth.instance.signOut();
//               print('Del Token called');
//               Tokens().delToken(_number); // Assuming _number is accessible here
//               print('Del Token Finished');
//               Get.offAll(const LoginOrSignUpAsking(), transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.setBool('isLoggedIn', false);
//             } catch (e) {
//               Get.back();
//               SnackBarCustom().show('Error', e.toString()); // Corrected SnackBarCustom() to SnackBarCustom
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.background,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: const EdgeInsets.all(12.0),
//             child: Text(
//               "OK",
//               style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
