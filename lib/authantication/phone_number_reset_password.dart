import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:v_bhartiya/authantication/opt_reset_password.dart';

import '../utils/snakbar.dart';

class PhoneNumberAsking extends StatefulWidget {
  const PhoneNumberAsking({super.key});

  @override
  State<PhoneNumberAsking> createState() => _PhoneNumberAskingState();
}

class _PhoneNumberAskingState extends State<PhoneNumberAsking> {
  final TextEditingController _numController = TextEditingController();
  bool _errorNumber=false;
  bool _isloading=false;


  Future<void> sendCodeFun() async {
    var text = _numController.text.toString();
    if(text==''||_numController.text.length!=10){
      setState(() {
        _errorNumber = true;
      });
    }else {
      try {
        // Check if the phone number already exists in Firestore
        setState(() {
          _isloading=true;
        });
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_numController.text)
            .get();

        if (userSnapshot.exists) {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91${_numController.text}',
            verificationCompleted: (PhoneAuthCredential cred) {},
            verificationFailed: (FirebaseAuthException e) {
              setState(() {
                _isloading=false;
              });
              SnakbarCustom().show('Exception Login', e.code);
            },
            codeSent: (String vid, int? token) async {
              Get.off(
                OtpReset(
                  vid: vid,
                  phoneNum: _numController.text,
                ),
                transition: Transition.upToDown,
                duration: const Duration(milliseconds: 500),
              );
            },
            codeAutoRetrievalTimeout: (vid) {},
          );

        }else{
          setState(() {
            _isloading=false;
          });
          SnakbarCustom().show('Error', "Phone number wouldn't exists.");
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isloading=false;
        });
        SnakbarCustom().show('Firebase Auth Error', e.code);
      } catch (e) {
        setState(() {
          _isloading=false;
        });
        SnakbarCustom().show('Firebase Auth Error', e.toString());
      }
      // Get.off(const PasswordReset(),transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: _isloading? const NeverScrollableScrollPhysics(): null,
        child: Stack(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/onboarding/wave.svg',
                  color: Theme.of(context).colorScheme.primary,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Center(child: Image.asset('assets/onboarding/forgot_num.png')),
                      Text(
                        'Verify your phone number',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "To guarantee secure and reliable communication, please verify your phone number so we could proceed further",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Card(
                        color: const Color(0xFFF4F4F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                          height: 70,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 40,
                                // color: Colors.purple,
                                child: Image.asset('assets/onboarding/india_flag.png'),
                                ),
                              const SizedBox(width: 10),
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onPrimary
                                ),
                              ),
                              const SizedBox(width: 5),
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _numController,
                                  onChanged: (val){
                                    setState(() {
                                      _errorNumber = false;
                                      if (!RegExp(r'^[0-9]+$').hasMatch(val) || val.length > 10) {
                                        _numController.text = val.substring(0, val.length - 1);
                                      }
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      _errorNumber
                          ? Text(
                        'Please Enter valid number',
                        style: TextStyle(color: Theme.of(context).colorScheme.onError),
                      )
                          : SizedBox(),

                      const SizedBox(
                        height: 70,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          sendCodeFun();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          fixedSize: const Size(342, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                          ),
                        ),
                        child: const Text(
                          'Send Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80,)
                    ],
                  ),
                ),
              ],
            ),
            if (_isloading)
              Container(
                color: Colors.white.withOpacity(0.6),
                width: Get.width,
                height: Get.height+30,
                child: Center(
                  child: SizedBox(
                      width: 280,
                      height: 280,
                      child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Lottie.asset('assets/onboarding/waiting.json'))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
