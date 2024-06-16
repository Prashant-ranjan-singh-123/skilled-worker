// import 'package:flutter/material.dart';
//
// class PasswordReset extends StatefulWidget {
//   const PasswordReset({super.key});
//
//   @override
//   State<PasswordReset> createState() => _PasswordResetState();
// }
//
// class _PasswordResetState extends State<PasswordReset> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCFCFC),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 40),
//                 // SvgPicture.asset(Assets.svg.m14.mastercard.path),
//                 SizedBox(height: 62),
//                 Text(
//                   'Hi there, welcome!',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF262626),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 37, top: 8, bottom: 23),
//                   child: Text(
//                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Convallis vestibulum augue massa sed aenean.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF262626),
//                       height: 1.28,
//                     ),
//                   ),
//                 ),
//                 _textField(
//                   hintText: 'Your full name',
//                   prefixIcon: const Icon(Icons.person, color: Color(0xFFA8A8A8)),
//                 ),
//                 SizedBox(height: 14),
//                 _textField(
//                   hintText: 'Your email address',
//                   prefixIcon: const Icon(Icons.email, color: Color(0xFFA8A8A8)),
//                 ),
//                 SizedBox(height: 14),
//
//                 _textField(
//                   hintText: '*******',
//                   prefixIcon: const Icon(Icons.vpn_key, color: Color(0xFFA8A8A8)),
//                 )
//                   ],
//                 ),
//                 SizedBox(height: 95),
//                 _button(text: 'Create new account'),
//                 _button(text: 'Forgot password', isTransparent: true),
//             )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _button({required String text, bool isTransparent = false}) => ElevatedButton(
//     onPressed: () {
//       // context.pop();
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: isTransparent ? Colors.transparent : const Color(0xFF0043CE),
//       elevation: 0,
//       shadowColor: Colors.transparent,
//       fixedSize: Size(342, 64),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: isTransparent ? const Color(0xFF0043CE) : const Color(0xFFF4F4F4),
//       ),
//     ),
//   );
//
//   Widget _textField({required String hintText, required Widget prefixIcon}) => TextField(
//     decoration: InputDecoration(
//       hintText: hintText,
//       hintStyle: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w400,
//         color: const Color(0xFFA8A8A8),
//       ),
//       prefixIcon: prefixIcon,
//       contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 22),
//       border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD0D0D0))),
//       focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD0D0D0))),
//       enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD0D0D0))),
//     ),
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:v_bhartiya/shimmer/reset_done.dart';

class PasswordReset extends StatefulWidget {
  final String phoneNum;
  const PasswordReset({
    Key? key,
    required this.phoneNum}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confPass = TextEditingController();
  String toDisplay = '';
  bool isShowError = false;
  bool _isloading = false;

  Future<void> buttonAction() async {
    String name = _name.text;
    String pass = _pass.text;
    String confirmPass = _confPass.text;
    _isloading=true;
    setState(() {});

    if (pass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        toDisplay = 'Password or Confirm Password is empty';
        _isloading=false;
        isShowError = true;
      });
    } else if (pass != confirmPass) {
      setState(() {
        toDisplay = 'Password Mismatched';
        _isloading=false;
        isShowError = true;
      });
    }else if (pass.length<8 || confirmPass.length<8) {
      setState(() {
        toDisplay = 'Password must be at least 8';
        _isloading=false;
        isShowError = true;
      });
    } else {
      setState(() {
        isShowError = false;
      });
      if (name.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.phoneNum)
            .update({
          'fullName': name,
          'pass1': pass
        });
      }else{
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.phoneNum)
            .update({
          'pass1': pass
        });
      }
      setState(() {
        _isloading=false;
      });
      Get.offAll(const ResetDone(),transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_){
        Get.dialog(
            AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
              shadowColor: Colors.black,
              title: Text(
                "Action not allowed",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
              ),
              content: Text(
                "Sorry, you can't leave this sensitive page. Please complete the password reset process before navigating away.",
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
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFFCFCFC),
          body: Stack(
            children: [
              SafeArea(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Image.asset('assets/onboarding/reset_pass_screen.png',height: 250, width: 250,)),
                            // SvgPicture.asset(Assets.svg.m14.mastercard.path),
                            const SizedBox(height: 22),
                            const Text(
                              'Reset Password!',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF262626),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 37, top: 8, bottom: 23),
                                child: Center(
                                  child: Text(
                                    "For secure account creation, enter your full name, choose a strong and unique password (mix letters, numbers, and symbols!), and keep it confidential - we'll never ask for it.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF262626),
                                      height: 1.28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            _textField(
                              controller: _name,
                              hintText: 'Your full name',
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFFA8A8A8)),
                            ),
                            const SizedBox(height: 14),
                            _textField(
                              controller: _pass,
                              hintText: '*******',
                              prefixIcon: const Icon(Icons.vpn_key,
                                  color: Color(0xFFA8A8A8)),
                            ),
                            const SizedBox(height: 14),
                            _textField(
                              controller: _confPass,
                              hintText: '*******',
                              prefixIcon: const Icon(Icons.vpn_key,
                                  color: Color(0xFFA8A8A8)),
                            ),
                            isShowError ?
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(toDisplay, style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),),
                            ):const SizedBox(),
                            const SizedBox(height: 35),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.85,
                                  53,
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0, // Remove elevation (shadow) effect
                              ),
                              onPressed: () {
                                buttonAction();
                              },
                              child: const Center(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isloading)
                Container(
                  color: Colors.white.withOpacity(0.6),
                  width: Get.width,
                  height: Get.height,
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
          )),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required Widget prefixIcon,
  }) {
    return TextField(
      controller: controller,
      onChanged: (val){
        setState(() {
          isShowError = false;
        });
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary), // Change the text color here
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFA8A8A8), // Hint text color
        ),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0D0D0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0D0D0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0D0D0)),
        ),
      ),
    );
  }

}
