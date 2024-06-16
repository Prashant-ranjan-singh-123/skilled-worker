import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_bhartiya/authantication/phone_number_reset_password.dart';
import 'package:v_bhartiya/authantication/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_bhartiya/shimmer/profile_shimmer.dart';
import 'package:v_bhartiya/user_pages/utils/userDeviceTokensWork.dart';
import '../user_pages/user_bottom_navigation_screen.dart';
import '../utils/snakbar.dart';
import 'login_or_signup_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isButtonEnabled=true;
  bool dontMatch=false;
  bool _obscureText1st = true;


  signInFun(BuildContext context) async {
    if (!isButtonEnabled) {
      return; // Do nothing if the button is already disabled
    }
    setState(() {
      isButtonEnabled = false;
    });
    if(_phoneNumController.text.isNotEmpty && _pass.text.isNotEmpty) {
      try {
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_phoneNumController.text)
            .get();
        var userSnapshot2 = await FirebaseFirestore.instance
            .collection('users')
            .doc(_phoneNumController.text)
            .get();
        var pass1Value = userSnapshot2.data()?['pass1'];
        if (userSnapshot.exists && pass1Value == _pass.text) {
          Tokens().getToken(_phoneNumController.text, null, false);


          // Future.delayed(const Duration(seconds: 3));

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('logedInNum', _phoneNumController.text);
          Get.offAll(const MainScreenUser(pageNumber: 0,), transition: Transition.upToDown, duration: const Duration(seconds: 1));
          // await FirebaseFirestore.instance
          //     .collection('Plans')
          //     .doc('Basic')
          //     .set({
          //   'token': widget.fullName,
          // });
        } else {
          SnakbarCustom().show('Error', 'User Not Found');
        }
      } on FirebaseAuthException catch (e) {
        SnakbarCustom().show('Firebase Auth Error', e.code);
      } catch (e) {
        SnakbarCustom().show('Firebase Auth Error', e.toString());
      }
    }else{
      SnakbarCustom().show('Empty Field', 'Please enter username and Password',);
    }
    setState(() {
      isButtonEnabled = true;
    });
  }



  forgotPassFun(){
    Get.to(const PhoneNumberAsking() ,transition: Transition.downToUp, duration: const Duration(milliseconds: 500));
  }

  signUpPageFun(){
    Get.off(const SignUpScreen(),transition: Transition.fade, duration: const Duration(seconds: 1));
  }



  @override
  void initState() {
    super.initState();
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
                color: LoginPageTheme().signInTop(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 22),
                  child: Text(
                    'Hello\nSign In!',
                    style: LoginPageTheme().helloSignIn(context),
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
                    padding: const EdgeInsets.only(left: 18.0,right: 18),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 70,),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _phoneNumController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500
                            ),
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.phone_android,
                                  color: Theme.of(context).colorScheme.onSecondary,),
                                hintText: 'ex: 7046746950',
                                hintStyle: TextStyle(
                                    color:Theme.of(context).colorScheme.onSecondary,
                                    fontFamily: 'Roboto'
                                ),
                                label: Text('Phone Number',style: LoginPageTheme().phoneNumPass(context),)
                            ),
                          ),
                          TextField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            obscureText: _obscureText1st,
                            controller: _pass,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText1st ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText1st = !_obscureText1st;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              labelStyle: LoginPageTheme().phoneNumPass(context),
                            ),
                            onChanged: (value) {
                              dontMatch = false;
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: (){
                                forgotPassFun();
                              },
                              child: Text('Forgot Password?',
                                style: LoginPageTheme().forgotSignUp(context),),
                            ),
                          ),
                          const SizedBox(height: 70,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.75,
                                53,
                              ), backgroundColor: LoginPageTheme().signInTop(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0, // Remove elevation (shadow) effect
                            ),
                            onPressed: isButtonEnabled? () {
                              signInFun(context);
                            }:null,
                            child: Center(child: Text('SIGN IN',
                              style: LoginPageTheme().signIn(context),),
                            ),
                          ),
                          const SizedBox(height: 150,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Don't have account?",
                                  style: LoginPageTheme().dontHaveAcc(context),),
                                InkWell(
                                  onTap: (){
                                    signUpPageFun();
                                  },
                                  child: Text("Sign up",
                                    style: LoginPageTheme().forgotSignUp(context),),
                                ),
                              ],
                            ),
                          )
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: false,
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       foregroundColor: Colors.white,
  //       leading: IconButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         icon: Icon(Icons.arrow_back_ios,
  //           size: 20,
  //           color: Colors.black,),
  //         color: Colors.white,
  //
  //       ),
  //     ),
  //     body: Stack(
  //       children: [
  //         SingleChildScrollView(
  //           child: SizedBox(
  //             height: MediaQuery.of(context).size.height,
  //             width: double.infinity,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 Expanded(child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: <Widget>[
  //                     Column(
  //                       children: <Widget>[
  //                         Image.asset('assets/onboarding/login.png', width: 250, height: 250,),
  //                         Text("Login",
  //                           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
  //                         SizedBox(height: 20,),
  //                         Text("Login to your account",
  //                           style: TextStyle(
  //                               fontSize: 15,
  //                               color:Colors.grey[700]),)
  //                       ],
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 40),
  //                       child: Column(
  //                         children: <Widget>[
  //                           inputFile(label: "Email"),
  //                           inputFile(label: "Password", obscureText: true)
  //                         ],
  //                       ),
  //                     ),
  //                     Padding(padding:
  //                     EdgeInsets.symmetric(horizontal: 40),
  //                       child: Container(
  //                         padding: EdgeInsets.only(top: 3, left: 3),
  //                         decoration:
  //                         BoxDecoration(
  //                             borderRadius: BorderRadius.circular(50),
  //                             border: const Border(
  //                               bottom: BorderSide(color: Colors.black),
  //                               top: BorderSide(color: Colors.black),
  //                               left: BorderSide(color: Colors.black),
  //                               right: BorderSide(color: Colors.black),
  //
  //                             )
  //
  //
  //
  //                         ),
  //                         child: MaterialButton(
  //                           minWidth: double.infinity,
  //                           height: 60,
  //                           onPressed: () {},
  //                           color: Color(0xff0095FF),
  //                           elevation: 0,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50),
  //
  //                           ),
  //                           child: Text(
  //                             "Login", style: TextStyle(
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 18,
  //                             color: Colors.white,
  //
  //                           ),
  //                           ),
  //
  //                         ),
  //                       ),
  //                     ),
  //
  //
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Text("Don't have an account?"),
  //                         Text(" Sign up", style: TextStyle(
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 18,
  //
  //                         ),)
  //                       ],
  //                     ),
  //
  //                     Container(
  //                       padding: EdgeInsets.only(top: 100),
  //                       height: 200,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                             image: AssetImage("assets/background.png"),
  //                             fit: BoxFit.fitHeight
  //                         ),
  //
  //                       ),
  //                     )
  //
  //                   ],
  //                 ))
  //               ],
  //             ),
  //           ),
  //         ),
  //         Align(
  //           alignment: Alignment.topCenter,
  //           child: SvgPicture.asset(
  //             'assets/onboarding/wave.svg',
  //             width: MediaQuery.of(context).size.width,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}


// we will be creating a widget for text field
Widget inputFile({label, obscureText = false, required BuildContext context})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),

      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
            )
        ),
      ),
      const SizedBox(height: 10,)
    ],
  );
}

class LoginPageTheme{
  Color background(BuildContext context){
    return Theme.of(context).colorScheme.onPrimary;
  }
  TextStyle helloSignIn(BuildContext context){
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 30,
        color: Theme.of(context).colorScheme.background,
        fontWeight: FontWeight.bold);
  }
  TextStyle phoneNumPass(BuildContext context){
    return TextStyle(
        fontWeight: FontWeight.w700,
        color:Theme.of(context).colorScheme.onPrimary,
        fontFamily: 'Roboto'
    );
  }
  TextStyle dontHaveAcc(BuildContext context){
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondary
    );
  }
  TextStyle forgotSignUp(BuildContext context){
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Theme.of(context).colorScheme.onPrimary
    );
  }
  TextStyle signIn(BuildContext context){
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 25,
        color: Theme.of(context).colorScheme.background,
        fontWeight: FontWeight.bold);
  }
  Color signInTop(BuildContext context){
    return Theme.of(context).colorScheme.primary;
  }
}
