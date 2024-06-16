import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Skilled_worker/authantication/login_or_signup_page.dart';
import 'package:Skilled_worker/shimmer/profile_shimmer.dart';
import 'package:Skilled_worker/user_pages/user_profile_edit.dart';
import 'package:Skilled_worker/user_pages/utils/userDeviceTokensWork.dart';

import '../utils/snakbar.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _number;
  String? networkImage;
  bool isImage=false;
  bool isImageLoading=true;
  var userData;


  void signOut(){
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
        shadowColor: Colors.black,
        title: Text(
          "Confirm Logout",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  print('Del Token called');
                  Tokens().delToken(_number);
                  print('Del Token Finished');
                  Get.offAll(const LoginOrSignUpAsking(), transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                } catch (e) {
                  Get.back();
                  SnakbarCustom().show('Error', e.toString());
                }
            },
            child: Text(
              "OK",
              style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getNum() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? num = pref.getString('logedInNum');
    _number = num;
    setState(() {});
  }

  Future<void> getImage() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_number).get();

      String? temp = documentSnapshot.data()!['profilePhoto'] as String?;

      if (temp != null && temp.isNotEmpty) {
        // Make a HEAD request to check if the URL exists
        var request = await HttpClient().headUrl(Uri.parse(temp));
        var response = await request.close();

        if (response.statusCode == HttpStatus.ok) {
          // URL exists, set isImage to true
          networkImage = temp;
          isImage = true;
          setState(() {});
        } else {
          // URL does not exist, set isImage to false
          isImage = false;
          setState(() {});
        }
      } else {
        // URL is null or empty, set isImage to false
        isImage = false;
        setState(() {});
      }
    } catch (e) {
      // Error occurred while fetching image
      print('Error fetching image: $e');
      isImage = false;
      setState(() {});
    }
  }


  @override
  void initState() {
    getNum().then((value) async {
      print('Get Image is being called');
      getImage();
      await getData();
      print('Get Image is being called finish');
      isImageLoading=false;
      setState(() {});
    });

    setState((){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Profile")),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: isImageLoading ? ProfileShimmer() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 154, // Width + 2 * border width
                    height: 154, // Height + 2 * border width
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4), // Adjust opacity if needed
                          blurRadius: 30, // Increase blurRadius for a softer shadow
                          spreadRadius: 10, // Increase spreadRadius for a wider shadow
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    clipBehavior: Clip.antiAlias, // Ensure the border is rendered outside the circle
                    child: isImage
                        ? profilePhoto(isNetwork: true, net: networkImage!, isLoading: false)
                        : profilePhoto(isNetwork: false, isLoading: true),
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "General Information",
                      style: TextStyle(
                          fontSize: 19,
                          height: 1.38,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_note,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 32,),
                      onPressed: () {
                        Get.to(UserProfileEdit(),transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));
                        // Get.to(LandingPage(),transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));
                      },
                    )
                  ],
                ),
                WidgetCards(context, 10, 10, 0, 0, 'Name', '${userData['fullName']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Current Plan', '${userData['plan']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'User Group', '${userData['selectGroup']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Date of Birth', '${userData['dateOfBirth']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Age', '${userData['age']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Martial Status', '${userData['martialStatus']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Height', '${userData['height']}'),
                // SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'Weight', '${userData['weight']}'),
                WidgetCards(context, 0, 0, 10, 10, 'Blood Group', '${userData['bloodGroup']}'),
                // SizedBox(height: 30,),
                // SizedBox(height: 30,),
                // Add more WidgetCards as needed for other user data
                const SizedBox(height: 30,),

                Text(
                  "Contact Detail",
                  style: TextStyle(
                      fontSize: 19,
                      height: 1.38,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
                const SizedBox(height: 10,),
                WidgetCards(context, 10, 10, 0, 0, 'Mobile Number', '${userData['phoneNum']}'),
                const SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'State', '${userData['state']}'),
                const SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 0, 0, 'City', '${userData['city']}'),
                const SizedBox(height: 0.5,),
                WidgetCards(context, 0, 0, 10, 10, 'Pin code', '${userData['pincode']}'),
                const SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 19,
                          height: 1.38,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                          color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),

                settingsCardWidget(context,title: 'Report',trailing: const Icon(Icons.report_gmailerrorred),),
                settingsCardWidget(context,title: 'Terms and Condition', trailing: const Icon(Icons.notes_outlined),),
                settingsCardWidget(context,title: 'Share App', trailing: const Icon(Icons.share),),
                settingsCardWidget(context,title: 'Rate App', trailing: const Icon(Icons.star_rate_rounded),),
                settingsCardWidget(
                    context,
                    title: 'Sign Out',
                    trailing: const Icon(Icons.logout_outlined),
                    onTap: signOut),
                const SizedBox(height: 110,)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget WidgetCards(BuildContext context, int topLeft, int topRight,
      int bottomLeft, int bottomRight, String firstItem, String secondItem) {
    return Card(
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // height: 35,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight.toDouble()),
            topLeft: Radius.circular(topLeft.toDouble()),
            bottomRight: Radius.circular(bottomRight.toDouble()),
            bottomLeft: Radius.circular(bottomLeft.toDouble()),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                firstItem,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                secondItem,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            // Add more child widgets as needed
          ],
        ),
      ),
    );
  }

  Widget profilePhoto({required bool isNetwork, required bool isLoading, String? net}) {
    return Stack(
      children: [
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          ),
        Container(
          width: 154, // Width + 2 * border width
          height: 154, // Height + 2 * border width
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), // Adjust opacity if needed
                blurRadius: 30, // Increase blurRadius for a softer shadow
                spreadRadius: 10, // Increase spreadRadius for a wider shadow
                offset: const Offset(0, 10),
              )
            ],
            color: Colors.black, // Change to the desired background color
          ),
          clipBehavior: Clip.antiAlias, // Ensure the border is rendered outside the circle
          child: isNetwork
              ? Image.network(
            net!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
              : Image.asset(
            'assets/onboarding/profilePhoto.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          ),
      ],
    );
  }


  Widget settingsCardWidget(BuildContext context,
      {Widget? leading,
        required String title,
        String? trailingText,
        Widget? trailing,
        BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(10)),
        Color? backgroundColor,
        VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: backgroundColor ?? Theme.of(context).colorScheme.onBackground,
                borderRadius: borderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: leading ?? const SizedBox.shrink(),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailingText != null)
                    Text(
                      trailingText,
                      style: const TextStyle(
                        color: Color(0xFF0F62FE),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox.square(
                        dimension: 24,
                        child: trailing!,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(_number).get();
      if (documentSnapshot.exists) {
        userData = documentSnapshot.data()!;
        setState(() {});
      } else {
        signOut();
        SnakbarCustom().show('Some Error Occur', 'While Fetching Data Some Error occur');
      }
    } catch (error) {
      signOut();
      SnakbarCustom().show('Some Error Occur', 'While Fetching Data Some Error occur');
    }
  }
}