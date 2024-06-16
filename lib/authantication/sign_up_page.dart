import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:v_bhartiya/authantication/login_page.dart';
import 'package:get/get.dart';
import 'package:v_bhartiya/authantication/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:v_bhartiya/user_pages/utils/dropdown_menu.dart';

import '../utils/snakbar.dart';
import 'login_or_signup_page.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText1st = true;
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNum = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  String StateIs = 'State';
  String CityIs = 'City';
  String PincodeIs = 'Pin Code';
  String? state;
  String? city;
  String? pinCode;

  bool dontMatch=false;
  String toDisplay = '';
  final List<String> items = [
    'Doctor',
    'Photographer',
    'Programmer',
    'Recruiter',
    'Student',
    'Writer'
  ];
  String? dropDownMenuValue;

  void sign_up_fun() async {
    print('DropDown Value: $dropDownMenuValue');
    if (!(_pass1.text == _pass2.text)) {
      dontMatch = true;
      toDisplay = 'Password mismatched. Retry';
      setState(() {});
    } else if (_pass1.text.length < 8 && dropDownMenuValue==null) {
      dontMatch = true;
      toDisplay = 'Password should be at least 8 characters';
      setState(() {});
    } else {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent users from dismissing the dialog
      );
      try {
        // Check if the phone number already exists in Firestore
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_phoneNum.text)
            .get();

        if (userSnapshot.exists) {
          // Phone number already exists, show error message
          Get.back(); // Dismiss loading dialog
          SnakbarCustom().show('Error', 'Phone number already exists.');
          return; // Exit the function
        }else{
          // Proceed with phone number verification
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91${_phoneNum.text}',
            verificationCompleted: (PhoneAuthCredential cred) {},
            verificationFailed: (FirebaseAuthException e) {
              Get.back(); // Dismiss loading dialog
              SnakbarCustom().show('Exception Login', e.code);
            },
            codeSent: (String vid, int? token) async {
              Get.back();
              Get.to(
                Otp(
                  vid: vid,
                  phoneNum: _phoneNum.text,
                  city: CityIs,
                  fullName: _fullName.text,
                  pass1: _pass1.text,
                  pincode: PincodeIs,
                  state: StateIs,
                  selectGroup: dropDownMenuValue,
                ),
                transition: Transition.upToDown,
                duration: const Duration(milliseconds: 500),
              );
            },
            codeAutoRetrievalTimeout: (vid) {},
          );
        }
      } on FirebaseAuthException catch (e) {
        Get.back(); // Dismiss loading dialog
        SnakbarCustom().show('Firebase Auth Error', e.code);
      } catch (e) {
        Get.back(); // Dismiss loading dialog
        SnakbarCustom().show('Firebase Auth Error', e.toString());
      }
    }
  }

  Future<void> getLocation() async {
    setState(() {
      StateIs = 'Loading...';
      CityIs = 'Loading...';
      PincodeIs = 'Loading...';
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        state = "Location services are disabled.";
        city = "Location services are disabled.";
        pinCode = "Enable Location Services";
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            title: Text(
              "Location is Off",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "To utilize all features, please enable location services.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            title: Text(
              "Location Permission Denied",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "Our app requires access to location services to provide you with the best experience. Unfortunately, you have chosen to deny this permission permanently. As a result, certain features may be limited or unavailable. To enable location services and unlock the full functionality of the app, please navigate to your device settings and adjust the permissions accordingly.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        setState(() {
          state = "Enable Location permission.";
          city = 'Enable Location permission.';
          pinCode = 'Enable Location permission.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          title: Text(
            "Location Permission Denied Permanently",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "Our app requires access to location services to provide you with the best experience. Unfortunately, you have chosen to deny this permission permanently. As a result, certain features may be limited or unavailable. To enable location services and unlock the full functionality of the app, please navigate to your device settings and adjust the permissions accordingly\n\nOR REINSTALL THE APP AND GRANT PERMISSION WHEN ASKED.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        state = "Permissions Permanently denied.";
        city = "Permissions Permanently denied.";
        pinCode = "Permissions Permanently denied.";
      });
      return;
    }


    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      for (Placemark placemark in placemarks) {
        setState(() {
          state = placemark.administrativeArea;
          city = placemark.locality;
          pinCode = placemark.postalCode;
        });
      }
    } catch (e) {
      setState(() {
        state = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        StateIs='State';
        CityIs='City';
        PincodeIs='Pin Code';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primary,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return PopScope(
      onPopInvoked: (bool didPop) {
        Get.off(const LoginOrSignUpAsking(),transition: Transition.upToDown, duration: const Duration(milliseconds: 500));
      },
      canPop: false,
      child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 22),
                  child: Text(
                    'Create Your\nAccount',
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18, top: 33),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _fullName,
                              style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500
                            ),
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.location_history_rounded,color: Theme.of(context).colorScheme.onSecondary,),
                                hintText: 'ex: Rohan Singh',
                                hintStyle: const TextStyle(
                                    color:Colors.black45,
                                    fontFamily: 'Roboto'
                                ),
                                label: Text('Full Name',
                                  style: LoginPageTheme().phoneNumPass(context),)
                            ),
                          ),
                          TextField(
                            controller: _phoneNum,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.phone_android,color: Colors.grey,),
                                hintText: 'ex: 7967482039',
                                hintStyle: const TextStyle(
                                    color:Colors.black45,
                                    fontFamily: 'Roboto'
                                ),
                                label: Text('Phone Number',style: LoginPageTheme().phoneNumPass(context),)
                            ),
                          ),
                      if (dontMatch) TextField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500
                        ),
                        obscureText: _obscureText1st,
                        controller: _pass1,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _obscureText1st
                                ? const Icon(Icons.visibility_off, color: Colors.grey)
                                : const Icon(Icons.visibility, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _obscureText1st = !_obscureText1st;
                              });
                            },
                          ),
                          labelText: 'Password',
                          labelStyle:LoginPageTheme().phoneNumPass(context),
                        ),
                        onChanged: (value) {
                          dontMatch=false;
                          setState(() {});
                        },
                      ) else TextField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w500
                        ),
                        obscureText: _obscureText1st,
                        controller: _pass1,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _obscureText1st
                                ? const Icon(Icons.visibility_off, color: Colors.grey)
                                : const Icon(Icons.visibility, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _obscureText1st = !_obscureText1st;
                              });
                            },
                          ),
                          labelText: 'Password',
                            labelStyle:LoginPageTheme().phoneNumPass(context)
                        ),
                        onChanged: (value) {
                        },
                      ),
                          if (dontMatch) TextField(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500
                            ),
                            obscureText: _obscureText1st,
                            controller: _pass2,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _obscureText1st
                                    ? const Icon(Icons.visibility_off, color: Colors.grey)
                                    : const Icon(Icons.visibility, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _obscureText1st = !_obscureText1st;
                                  });
                                },
                              ),
                              labelText: toDisplay,
                                labelStyle:LoginPageTheme().phoneNumPass(context)
                            ),
                            onChanged: (value) {
                              dontMatch=false;
                              setState(() {});
                            },
                          ) else TextField(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500
                            ),
                            obscureText: _obscureText1st,
                            controller: _pass2,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _obscureText1st
                                    ? const Icon(Icons.visibility_off, color: Colors.grey)
                                    : const Icon(Icons.visibility, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _obscureText1st = !_obscureText1st;
                                  });
                                },
                              ),
                              labelText: 'Confirm Password',
                                labelStyle:LoginPageTheme().phoneNumPass(context)
                            ),
                            onChanged: (value) {
                            },
                          ),
                          const SizedBox(height: 8,),
                          GestureDetector(
                            onTap: () {
                              getLocation().then((_) {
                                setState(() {
                                  StateIs=state!;
                                  CityIs=city!;
                                  PincodeIs=pinCode!;
                                });
                              });
                            },
                            child: getLocationDetailWidget(
                              label: StateIs,
                              trailingIcon: Icons.location_searching,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getLocation().then((_) {
                                setState(() {
                                  StateIs=state!;
                                  CityIs=city!;
                                  PincodeIs=pinCode!;
                                });
                              });
                            },
                            child: getLocationDetailWidget(
                              label: CityIs,
                              trailingIcon: Icons.location_city_rounded,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getLocation().then((_) {
                                setState(() {
                                  StateIs=state!;
                                  CityIs=city!;
                                  PincodeIs=pinCode!;
                                });
                              });
                            },
                            child: getLocationDetailWidget(
                              label: PincodeIs,
                              trailingIcon: Icons.pin,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.08, // Adjust the width as neededss
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomDropdownMenu(context: context,
                                title: 'Select Group',
                                items: items,
                                selectedValue: dropDownMenuValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropDownMenuValue = value;
                                  });
                                  // Do something with the selected value
                                  print('Selected value: $value');
                                }, isBlackSelectGroup: true,),
                            ),


                          ),

                          const SizedBox(height: 10,),
                          const SizedBox(height: 70,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                53,
                              ), backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0, // Remove elevation (shadow) effect
                            ),
                            onPressed: () {
                              sign_up_fun();
                            },
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          const SizedBox(height: 80,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Have an account?",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),),
                                InkWell(
                                  onTap: (){
                                    Get.off(const Login(),transition: Transition.fade, duration: const Duration(seconds: 1));
                                  },
                                  child: const Text("Sign In",style: TextStyle(///done login page
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget getLocationDetailWidget({
    required final String label,
    required IconData trailingIcon,
  }){
    return Padding(
        padding: const EdgeInsets.only(right: 12, top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(height: 48,),
                Text(label, style: LoginPageTheme().phoneNumPass(context)),
              ],
            ),
            Icon(
              trailingIcon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ],
        )
    );
  }
}