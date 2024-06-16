// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class OfflineBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//           () => !Get.find<ConnectivityService>().isOnline.value
//           ? Container(
//         color: Colors.red,
//         padding: EdgeInsets.symmetric(vertical: 8),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.warning, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               'Offline',
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       )
//           : SizedBox(),
//     );
//   }
// }
