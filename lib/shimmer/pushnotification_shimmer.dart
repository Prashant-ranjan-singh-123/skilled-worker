import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Skilled_worker/user_pages/createNotification.dart';

class PushNotificationShimmer extends StatelessWidget {
  const PushNotificationShimmer({super.key});

  void executeAfterDelay() {
    Future.delayed(const Duration(seconds: 10), () {
      Get.to(CreateNotification());
    });
  }

  @override
  Widget build(BuildContext context) {
    // executeAfterDelay();
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Notification'),
          titleTextStyle: TextStyle(
            color: Colors.grey.withOpacity(0.2),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Uploading Image',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  )
                , textAlign: TextAlign.center,),
                SizedBox(
                  width: 280,
                    height: 180,
                    child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Lottie.asset('assets/onboarding/waiting.json')))
              ],
            ),
          ),
          Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.6),
              highlightColor: Colors.grey.withOpacity(0.2),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    Center(
                      child: Text(
                        'Title',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    TextField(
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w500),
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.title, color: Theme.of(context).colorScheme.onSecondary),
                        hintText: 'Ex: Freshers Hiring',
                        hintStyle: const TextStyle(color: Colors.black45, fontFamily: 'Roboto'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Blue border when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Blue border when not focused
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Center(
                      child: Text(
                        'Message',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    TextField(
                      maxLines: 5,
                      readOnly: true,
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.messenger, color: Theme.of(context).colorScheme.onSecondary),
                        hintText: 'Write a message you want to Broadcast.',
                        hintStyle: const TextStyle(color: Colors.black45, fontFamily: 'Roboto'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 2), // Blue border when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Blue border when not focused
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Center(
                      child: Text(
                        'Select User Group',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    // Card(
                    //   color: Theme.of(context).colorScheme.background,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    //     child: CustomDropdownMenu(context: context,
                    //       title: 'Select Group',
                    //       items: items,
                    //       selectedValue: dropDownMenuValue,
                    //       onChanged: (String? value) {
                    //         setState(() {
                    //           dropDownMenuValue = value;
                    //         });
                    //         // Do something with the selected value
                    //         print('Selected value: $value');
                    //       }, isBlackSelectGroup: true,),
                    //   ),
                    // ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Center(
                      child: Text(
                        'Upload Image',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 50.0,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 53),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0, // Remove elevation (shadow) effect
                        ),
                        onPressed: () {
                          // sendNotification();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
