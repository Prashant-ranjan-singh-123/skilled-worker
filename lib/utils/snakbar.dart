import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class SnakbarCustom{
  void show(String title, String message){
    Get.snackbar(title, message,
      backgroundColor: HexColor('#1F41BB').withOpacity(0.6),
      colorText: Colors.white,
      icon: const Icon(Icons.notifications, color: Colors.white,),
      boxShadows: [const BoxShadow(color: Colors.white)],);
  }
}
