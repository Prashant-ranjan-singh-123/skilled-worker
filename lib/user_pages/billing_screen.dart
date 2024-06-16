import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:v_bhartiya/shimmer/payment_done.dart';
import 'package:v_bhartiya/user_pages/user_bottom_navigation_screen.dart';

import '../shimmer/payment_fail.dart';

class Plan {
  final String name;
  final String price;
  final List<String> features;
  Plan({
    required this.name,
    required this.price,
    required this.features,
  });
}

class BillingScreen extends StatefulWidget {
  late Map<String, String> plansIs;
  late Map<String, String> plansPrice;
  late List<Plan> plans;

  BillingScreen() {
    plansIs = {
      'Basic1': 'See Notification',
      'Basic2': 'Edit Profile',
      'Basic3': '',
      'Standard1': 'See Notification',
      'Standard2': 'Create Notification',
      'Standard3': 'Edit Profile',
    };

    plansPrice = {
      'Basic':'Price: Free',
      'Standard':'Price: ₹999',
    };



    plans = [
      Plan(
        name: 'Basic',
        price: "${plansPrice['Basic']}",
        features: [plansIs['Basic1']!, plansIs['Basic2']!],
      ),
      Plan(
        name: 'Standard',
        price: "${plansPrice['Standard']}",
        features: [plansIs['Standard1']!, plansIs['Standard2']!, plansIs['Standard3']!],
      ),
      // Plan(
      //   name: 'Premium',
      //   price: "${plansPrice['Premium']}",
      //   features: [plansIs['Premium1']!, plansIs['Premium2']!, plansIs['Premium3']!],
      // ),
    ];
  }

  @override
  State<BillingScreen> createState() => _BillingScreenState();
  
}

class _BillingScreenState extends State<BillingScreen> {
  String? _num;
  String? _planIs;

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    Get.offAll(MainScreenUser(pageNumber: 0,), transition: Transition.upToDown, duration: const Duration(seconds: 0));
    Get.to(const PaymentFail(),transition: Transition.zoom, duration: const Duration(milliseconds: 500));
  }

  Future<void> handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    await updatePlanDetail('Standard');
    Get.offAll(MainScreenUser(pageNumber: 0,), transition: Transition.upToDown, duration: const Duration(seconds: 0));
    await updatePlanDetail('Standard');
    Get.to(PaymentDone(num: _num),transition: Transition.zoom, duration: const Duration(milliseconds: 500));
    await updatePlanDetail('Standard');

  }

  Future<void> handleExternalWalletSelected(ExternalWalletResponse response) async {
    await updatePlanDetail('Standard');
    Get.offAll(const MainScreenUser(pageNumber: 0,), transition: Transition.upToDown, duration: const Duration(seconds: 0));
    await updatePlanDetail('Standard');
    Get.to(PaymentDone(num: _num),transition: Transition.zoom, duration: const Duration(milliseconds: 500));
    await updatePlanDetail('Standard');
  }



  Future<void> updatePlanDetail(String planIs) async {
    try {
      setGlobalVariables().then((value) => () async {
        print('updating plan');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_num)
            .update({
          'plan': planIs,
        });
      });
    }catch (e){
      print('error updating plan');
      updatePlanDetail(planIs);
    }
  }


  void activateStandardPlan(){
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 99900,
      'name': 'Standard Plan',
      'description': 'Standard Plan Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '7067597028',
        'email': 'prashant.singh.12312345@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
    razorpay.open(options);
  }


  Future<void> payment(int planIs) async {
    String planNameString;
    print('Plan is: $_planIs');
    print('Plan is rr: $planIs');


    if (planIs == 0 && _planIs=='Basic') {
      print('In this blog: 1');
      planNameString = 'Basic';
      Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
          shadowColor: Colors.black,
          title: Text(
            "Your Current Plan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
          ),
          content: Text(
            "Its most basic plan, which was activated by an administrator.",
            style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: (){
                Get.back();
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
    else if (planIs == 0 && _planIs!='Basic') {
      print('In this blog: 2');
      planNameString = 'Basic';
      Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
          shadowColor: Colors.black,
          title: Text(
            "Premium Plan Activated",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
          ),
          content: Text(
            "Its most basic plan, and your current plan offers more features and benefits compared to the basic option.",
            style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: (){
                Get.back();
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
    else if (planIs == 1 && _planIs=='Standard') {
      print('In this blog: 3');
      planNameString = 'Standard';
      Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
          shadowColor: Colors.black,
          title: Text(
            "Plan Activated",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
          ),
          content: Text(
            "Thank you for your payment! It looks like you're already enrolled in our Standard plan. This means your payment ensures continued access to all the great features and benefits this plan offers.",
            style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: (){
                Get.back();
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
    else if(planIs == 1 && _planIs=='Basic'){
      print('In this blog: 4');
      planNameString = 'Standard';
      Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
        shadowColor: Colors.black,
        title: Text(
          "Confirm Purchase",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
        ),
        content: Text(
          "To proceed with your purchase of the ${planNameString} plan, please confirm.",
          style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: (){
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color:Theme.of(context).colorScheme.background, fontWeight: FontWeight.w500),
            ),
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.background,
            onPressed: (){
              Get.back(); // Close the dialog
              activateStandardPlan();
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
    else {
      print('In this blog: 5');
      planNameString = 'Standard';
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
        shadowColor: Colors.black,
        title: Text(
          "Confirm Purchase",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
        ),
        content: Text(
          "To proceed with your purchase of the ${planNameString} plan, please confirm.",
          style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: (){
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color:Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
            ),
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: (){
              Get.back(); // Close the dialog
              activateStandardPlan();
            },
            child: Text(
              "Ok",
              style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    }
  }


  Future<void> setGlobalVariables() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _num = pref.getString('logedInNum');

    if (_num != null) {
      print('Number is: $_num');
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_num)
          .get();
      _planIs = documentSnapshot.data()?['plan'] as String?;
      print('Plan is: $_planIs');
    } else {
      _planIs = 'Basic';
    }
  }
  
  @override
  void initState() {
    setGlobalVariables().then((value) => setState(() {}));
    super.initState();
  }

  double returnSmall(){
    if(Get.width>Get.height){
      return Get.height;
    }
    return Get.width;
  }

  bool isZeroActive=true;
  List<String> freePlan = [
    'Easy Sign-in',
    'Individual Account',
    'No Adds',
    'Get Message Alert.',
    'Craft Your Profile.'
  ];
  List<String> premiumPlan = [
    'No Adds',
    'Broadcast Message to All Users',
    'Broadcast Message To Specific Group',
    'Send Images With Message',
    'Get Message Alert.',
    'Easy Sign-in',
    'Craft Your Profile.',
    'Individual Account',
  ];



  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     body: Container(
  //       width: Get.width,
  //       height: Get.height,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           // colors: [HexColor('#8324FF'),Theme.of(context).colorScheme.background], // Specify your gradient colors here
  //           colors: [HexColor('#03017D'),HexColor('#F065AD'),HexColor('#FFC0CB')], // Specify your gradient colors here
  //           // You can also add stops for more control over the gradient
  //           // stops: [0.0, 0.5, 1.0],
  //         ),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(bottom: 80),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               SizedBox(height: MediaQuery.of(context).padding.top,),
  //               SizedBox(height: 50,),
  //               Padding(
  //                 padding: EdgeInsets.only(left: Get.width*0.15, right: Get.width*0.15),
  //                 child: SizedBox(
  //                     width: Get.width,
  //                     child: const FittedBox(
  //                         fit: BoxFit.contain,
  //                         child: Text('Subscribe to Premium', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w900)))),
  //               ),
  //               const SizedBox(height: 50,),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //
  //                   GestureDetector(
  //                     onTap: (){
  //                       setState(() {
  //                         isZeroActive=true;
  //                       });
  //                     },
  //                     child: Container(
  //                       width: returnSmall()*0.4,
  //                       height: returnSmall()*0.4,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(color: !isZeroActive? Colors.white: Colors.black, width: 2),
  //                         boxShadow: !isZeroActive
  //                             ? null:
  //                         [BoxShadow(
  //                           color: Theme.of(context).colorScheme.background,
  //                           blurStyle: BlurStyle.outer,
  //                           spreadRadius: 3,
  //                           blurRadius: 70,
  //                         )],
  //                         borderRadius: const BorderRadius.all(Radius.circular(15.0)),
  //                         color: !isZeroActive? Colors.transparent: Theme.of(context).colorScheme.background,
  //                       ),
  //                       child: Padding(
  //                         padding: EdgeInsets.all(8.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text('Charges', style: TextStyle(color: isZeroActive? Colors.black: Colors.white, fontSize: 18, fontFamily: 'Oswald', fontWeight: FontWeight.w900),),
  //                                 isZeroActive? Icon(Icons.check_circle, color: isZeroActive? Colors.black: Colors.white,): const SizedBox()
  //                               ],
  //                             ),
  //                             Expanded(
  //                               child: SizedBox(
  //                                 width: double.infinity,
  //                                 child: FittedBox(
  //                                     fit: BoxFit.contain,
  //                                     child: Text('₹0', style: TextStyle(color: isZeroActive? Colors.black: Colors.white, fontFamily: 'Oswald', fontWeight: FontWeight.w900),textAlign: TextAlign.start,)),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       // child: Lottie.asset(lottieAsset, width: double.infinity, height: double.infinity, reverse: true),
  //                     ),
  //                   ),
  //
  //                   GestureDetector(
  //                     onTap: (){
  //                       setState(() {
  //                         isZeroActive=false;
  //                       });
  //                     },
  //                     child: Container(
  //                       width: returnSmall()*0.4,
  //                       height: returnSmall()*0.4,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(color: isZeroActive? Colors.white: Colors.black, width: 2),
  //                         boxShadow: isZeroActive
  //                             ? null:
  //                         [BoxShadow(
  //                           color: Theme.of(context).colorScheme.background,
  //                           blurStyle: BlurStyle.outer,
  //                           spreadRadius: 3,
  //                           blurRadius: 70,
  //                         )],
  //                         borderRadius: const BorderRadius.all(Radius.circular(15.0)),
  //                         color: isZeroActive? Colors.transparent: Theme.of(context).colorScheme.background,
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text('Charges', style: TextStyle(color: !isZeroActive? Colors.black: Colors.white, fontSize: 18, fontFamily: 'Oswald', fontWeight: FontWeight.w900),),
  //                                 !isZeroActive? Icon(Icons.check_circle, color: !isZeroActive? Colors.black: Colors.white,): const SizedBox()
  //                               ],
  //                             ),
  //                             Expanded(
  //                               child: SizedBox(
  //                                 width: double.infinity,
  //                                 child: FittedBox(
  //                                     fit: BoxFit.contain,
  //                                     child: Text('₹999', style: TextStyle(color: !isZeroActive? Colors.black: Colors.white, fontFamily: 'Oswald', fontWeight: FontWeight.w900),textAlign: TextAlign.start,)),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       // child: Lottie.asset(lottieAsset, width: double.infinity, height: double.infinity, reverse: true),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 50,),
  //
  //               isZeroActive? _bulletPoints(Points: freePlan[0]):const SizedBox(),
  //               isZeroActive? _bulletPoints(Points: freePlan[1]):const SizedBox(),
  //               isZeroActive? _bulletPoints(Points: freePlan[2]):const SizedBox(),
  //               isZeroActive? _bulletPoints(Points: freePlan[3]):const SizedBox(),
  //               isZeroActive? _bulletPoints(Points: freePlan[4]):const SizedBox(),
  //
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[0]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[1]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[2]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[3]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[4]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[5]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[6]):const SizedBox(),
  //               !isZeroActive? _bulletPoints(Points: premiumPlan[7]):const SizedBox(),
  //               // const Spacer(),
  //               const SizedBox(height: 50,),
  //
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   fixedSize: Size(
  //                     MediaQuery.of(context).size.width * 0.85,
  //                     53,
  //                   ), backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(1),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   elevation: 0, // Remove elevation (shadow) effect
  //                 ),
  //                 onPressed: () {
  //                   // signUpfun();
  //                 },
  //                 child: const Center(child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.payment_sharp, color: Colors.white,),
  //                     SizedBox(width: 12,),
  //                     Text('Payment',style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                         fontFamily: 'Roboto'
  //                     ),),
  //                   ],
  //                 ),
  //                 ),
  //               )
  //
  //               // _bulletPoints(Points: freePlan[4]),
  //
  //               // Padding(
  //               //   padding: EdgeInsets.only(left: Get.width*0.15, right: Get.width*0.15),
  //               //   child: SizedBox(
  //               //       width: Get.width,
  //               //       child: const FittedBox(
  //               //           fit: BoxFit.contain,
  //               //           child: Text('Subscribe to Premium', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w900)))),
  //               // ),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // _bulletPoints(Points: 'Get a Message alert.'),
  //               // Add your other widgets here
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _bulletPoints({
  //   required String Points
  // }){
  //   return Padding(
  //     padding: EdgeInsets.only(left: Get.width*0.07, right: Get.width*0.07, bottom: 10),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.check_sharp, color: Colors.white,size: 40,),
  //         const SizedBox(width: 8,),
  //         Flexible(child: Text(Points, style: const TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w900),))
  //       ],
  //     ),
  //   );
  // }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
            // colors: [HexColor('#8324FF'),Theme.of(context).colorScheme.background], // Specify your gradient colors here
            // colors: [HexColor('#03017D'),HexColor('#F065AD'),HexColor('#FFC0CB')], // Specify your gradient colors here
            // colors: [HexColor('#03017D'),HexColor('#F065AD'),HexColor('#FFC0CB')], // Specify your gradient colors here
            // You can also add stops for more control over the gradient
            // stops: [0.0, 0.5, 1.0],
          // ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top,),
                SizedBox(height: 50,),
                Padding(
                  padding: EdgeInsets.only(left: Get.width*0.15, right: Get.width*0.15),
                  child: SizedBox(
                      width: Get.width,
                      child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Text('Subscribe to Premium', style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w900)))),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isZeroActive=true;
                        });
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.background,
                        elevation: 40,
                        child: Container(
                          width: returnSmall()*0.4,
                          height: returnSmall()*0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: !isZeroActive? Colors.black: Colors.black, width: 2),
                            boxShadow: !isZeroActive
                                ? null:
                            [BoxShadow(
                              color: Theme.of(context).colorScheme.background,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 3,
                              blurRadius: 70,
                            )],
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color: !isZeroActive? Colors.transparent: Theme.of(context).colorScheme.primary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Charges', style: TextStyle(color: isZeroActive? Colors.white: Colors.black, fontSize: 18, fontFamily: 'Oswald', fontWeight: FontWeight.w900),),
                                    isZeroActive? Icon(Icons.check_circle, color: isZeroActive? Colors.white: Colors.black,): const SizedBox()
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text('₹0', style: TextStyle(color: isZeroActive? Colors.white: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w900),textAlign: TextAlign.start,)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // child: Lottie.asset(lottieAsset, width: double.infinity, height: double.infinity, reverse: true),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isZeroActive=false;
                        });
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.background,
                        elevation: 40,
                        child: Container(
                          width: returnSmall()*0.4,
                          height: returnSmall()*0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: isZeroActive? Colors.black: Colors.black, width: 2),
                            boxShadow: isZeroActive
                                ? null:
                            [BoxShadow(
                              color: Theme.of(context).colorScheme.background,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 1,
                              blurRadius: 70,
                            )],
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color: isZeroActive? Colors.transparent: Theme.of(context).colorScheme.primary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Charges', style: TextStyle(color: !isZeroActive? Colors.white: Colors.black, fontSize: 18, fontFamily: 'Oswald', fontWeight: FontWeight.w900),),
                                    !isZeroActive? Icon(Icons.check_circle, color: !isZeroActive? Colors.white: Colors.black,): const SizedBox()
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text('₹999', style: TextStyle(color: !isZeroActive? Colors.white: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w900),textAlign: TextAlign.start,)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // child: Lottie.asset(lottieAsset, width: double.infinity, height: double.infinity, reverse: true),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),

                isZeroActive? _bulletPoints(Points: freePlan[0]):const SizedBox(),
                isZeroActive? _bulletPoints(Points: freePlan[1]):const SizedBox(),
                isZeroActive? _bulletPoints(Points: freePlan[2]):const SizedBox(),
                isZeroActive? _bulletPoints(Points: freePlan[3]):const SizedBox(),
                isZeroActive? _bulletPoints(Points: freePlan[4]):const SizedBox(),

                !isZeroActive? _bulletPoints(Points: premiumPlan[0]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[1]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[2]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[3]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[4]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[5]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[6]):const SizedBox(),
                !isZeroActive? _bulletPoints(Points: premiumPlan[7]):const SizedBox(),
                // const Spacer(),
                const SizedBox(height: 50,),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.85,
                      53,
                    ), backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0, // Remove elevation (shadow) effect
                  ),
                  onPressed: () {
                    if(isZeroActive) {
                      payment(0);
                    }else {
                      print('Premium is clicked');
                      payment(1);
                    }
                  },
                  child: const Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment_sharp, color: Colors.white,),
                      SizedBox(width: 12,),
                      Text('Payment',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto'
                      ),),
                    ],
                  ),
                  ),
                )

                // _bulletPoints(Points: freePlan[4]),

                // Padding(
                //   padding: EdgeInsets.only(left: Get.width*0.15, right: Get.width*0.15),
                //   child: SizedBox(
                //       width: Get.width,
                //       child: const FittedBox(
                //           fit: BoxFit.contain,
                //           child: Text('Subscribe to Premium', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w900)))),
                // ),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // _bulletPoints(Points: 'Get a Message alert.'),
                // Add your other widgets here
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _bulletPoints({
    required String Points
  }){
    return Padding(
      padding: EdgeInsets.only(left: Get.width*0.07, right: Get.width*0.07, bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_sharp, color: Colors.black,size: 40,),
          const SizedBox(width: 8,),
          Flexible(child: Text(Points, style: const TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Oswald', fontWeight: FontWeight.w500),))
        ],
      ),
    );
  }










  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       width: double.infinity,
  //       height: double.infinity,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             Theme.of(context).colorScheme.background,
  //             Theme.of(context).colorScheme.background
  //           ],
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
  //           Expanded(
  //             child: Container(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(bottom: 120, top: 30),
  //                 child: CarouselSlider(
  //                   options: CarouselOptions(
  //                     // height: MediaQuery.of(context).size.height * 0.5,
  //                     disableCenter: true,
  //                     enableInfiniteScroll: false,
  //                     autoPlayInterval: const Duration(seconds: 2),
  //                     autoPlay: true,
  //                     enlargeCenterPage: true,
  //                     viewportFraction: 0.8,
  //                     pageSnapping: true,
  //                   ),
  //                   items: widget.plans.asMap().entries.map((entry) {
  //                     final index = entry.key;
  //                     final plan = entry.value;
  //                     return Builder(
  //                       builder: (BuildContext context1) {
  //                         return Card(
  //                           elevation: 10,
  //                           shadowColor: Theme.of(context).colorScheme.onBackground,
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(13),
  //                               border: Border.all(width: 0.8),
  //                               image: DecorationImage(
  //                                 image: const AssetImage('assets/onboarding/billing_card_background.png'),
  //                                 fit: BoxFit.cover,
  //                                 colorFilter: ColorFilter.mode(
  //                                   Colors.white.withOpacity(0.7),
  //                                   BlendMode.dstATop,
  //                                 ),
  //                               ),
  //                             ),
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(top: 10, right: 8, left: 8, bottom: 8),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     plan.name,
  //                                     style: TextStyle(
  //                                       fontSize: 40,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Theme.of(context).colorScheme.onPrimary,
  //                                       fontFamily: 'Roboto',
  //                                     ),
  //                                   ),
  //                                   Text(
  //                                     plan.price,
  //                                     style: TextStyle(
  //                                       fontSize: 25,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Theme.of(context).colorScheme.onPrimary,
  //                                       fontFamily: 'Roboto',
  //                                     ),
  //                                   ),
  //                                   const SizedBox(height: 40),
  //                                   Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: plan.features.map((feature) {
  //                                       return Padding(
  //                                         padding: const EdgeInsets.symmetric(vertical: 4),
  //                                         child: Row(
  //                                           children: [
  //                                             Icon(
  //                                               Icons.star,
  //                                               color: Theme.of(context).colorScheme.primary,
  //                                               size: 20,
  //                                             ),
  //                                             const SizedBox(width: 8),
  //                                             Text(
  //                                               feature,
  //                                               style: TextStyle(
  //                                                 fontSize: 20,
  //                                                 fontFamily: 'Roboto',
  //                                                 color: Theme.of(context).colorScheme.onPrimary,
  //                                                 fontWeight: FontWeight.bold,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       );
  //                                     }).toList(),
  //                                   ),
  //                                   const Spacer(),
  //                                   TextButton(
  //                                     onPressed: () {
  //                                       payment(index);
  //                                     },
  //                                     style: TextButton.styleFrom(
  //                                       backgroundColor: Theme.of(context).colorScheme.primary,
  //                                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(30),
  //                                       ),
  //                                     ),
  //                                     child: Row(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Icon(
  //                                           Icons.payment,
  //                                           color: Theme.of(context).colorScheme.background,
  //                                         ),
  //                                         const SizedBox(width: 10),
  //                                         Text(
  //                                           'Make Payment',
  //                                           style: TextStyle(
  //                                             color: Theme.of(context).colorScheme.background,
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //             )
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }








// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         centerTitle: false,
  //         elevation: 0,
  //         backgroundColor: Theme.of(context).colorScheme.background,
  //         foregroundColor: Theme.of(context).colorScheme.background,
  //         automaticallyImplyLeading: false,
  //         title: const Center(child: Text("Users Plans")),
  //         titleTextStyle: const TextStyle(
  //           color: Colors.black,
  //           fontSize: 24,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       body: Container(
  //         width: double.infinity,
  //         height: double.infinity,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: [
  //               Theme.of(context).colorScheme.background,
  //               Theme.of(context).colorScheme.background
  //             ],
  //
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
  //             CarouselSlider(
  //               options: CarouselOptions(
  //                 height: MediaQuery.of(context).size.height * 0.7,
  //                 enableInfiniteScroll: false,
  //                 autoPlayInterval: const Duration(seconds: 2),
  //                 autoPlay: true,
  //                 enlargeCenterPage: true,
  //                 viewportFraction: 0.8,
  //                 pageSnapping: true,
  //               ),
  //               items: widget.plans.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final plan = entry.value;
  //                 return Builder(
  //                   builder: (BuildContext context1) {
  //                     return Card(
  //                       elevation: 10,
  //                       shadowColor: Theme.of(context).colorScheme.onBackground,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(13),
  //                           border: Border.all(
  //                               width: 0.8
  //                           ),
  //                           image: DecorationImage(
  //                             image: const AssetImage('assets/onboarding/billing_card_background.png'), // Example image path
  //                             fit: BoxFit.cover,
  //                             colorFilter: ColorFilter.mode(
  //                               Colors.white.withOpacity(0.7), // Example opacity value (0.5 for 50% opacity)
  //                               BlendMode.dstATop,
  //                             ),
  //                           ),
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(
  //                             top: 10,
  //                               right: 8, left: 8, bottom: 8),
  //                           child: Expanded(
  //                             child: Container(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     plan.name,
  //                                     style: TextStyle(
  //                                       fontSize: 40,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Theme.of(context)
  //                                           .colorScheme
  //                                           .onPrimary,
  //                                       fontFamily: 'Roboto',
  //                                     ),
  //                                   ),
  //                                   // const SizedBox(height: 30),
  //                                   Text(
  //                                     plan.price,
  //                                     style: TextStyle(
  //                                       fontSize: 25,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Theme.of(context)
  //                                           .colorScheme
  //                                           .onPrimary,
  //                                       fontFamily: 'Roboto',
  //                                     ),
  //                                   ),
  //                                   const SizedBox(height: 40),
  //                                   Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: plan.features.map((feature) {
  //                                       return Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 4),
  //                                         child: Row(
  //                                           children: [
  //                                             Icon(
  //                                               Icons.star,
  //                                               color: Theme.of(context)
  //                                                   .colorScheme
  //                                                   .primary,
  //                                               size: 20,
  //                                             ),
  //                                             const SizedBox(width: 8),
  //                                             Text(
  //                                               feature,
  //                                               style: TextStyle(
  //                                                 fontSize: 20,
  //                                                 fontFamily: 'Roboto',
  //                                                 color: Theme.of(context)
  //                                                     .colorScheme
  //                                                     .onPrimary,
  //                                                 fontWeight: FontWeight.bold,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       );
  //                                     }).toList(),
  //                                   ),
  //                                   const Spacer(),
  //                                   TextButton(
  //                                     onPressed: () {
  //                                       payment(index);
  //                                     },
  //                                     style: TextButton.styleFrom(
  //                                       backgroundColor: Theme.of(context)
  //                                           .colorScheme
  //                                           .primary,
  //                                       padding: const EdgeInsets.symmetric(
  //                                           horizontal: 20, vertical: 12),
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(30),
  //                                       ),
  //                                     ),
  //                                     child: Row(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Icon(
  //                                             Icons.payment,
  //                                             color: Theme.of(context)
  //                                                 .colorScheme
  //                                                 .background
  //                                         ),
  //                                         const SizedBox(width: 10),
  //                                         Text(
  //                                           'Make Payment',
  //                                           style: TextStyle(
  //                                             color: Theme.of(context)
  //                                                 .colorScheme
  //                                                 .background,
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  // }
}