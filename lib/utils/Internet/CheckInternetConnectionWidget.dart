import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetConnection{
    Future<bool> checkInternetConnection() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }

    void showAlertDialog(BuildContext context) {
      Get.dialog(
          AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
            shadowColor: Colors.black,
            title: Text(
              "Internet Not Available",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
            ),
            content: Text(
              "Sorry, it seems that you're currently offline. Please check your internet connection and try again.",
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
    }
}