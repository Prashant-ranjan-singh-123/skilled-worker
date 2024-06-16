import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDone extends StatefulWidget {
  final String ?num;
  const PaymentDone({super.key, this.num});

  @override
  State<PaymentDone>  createState() => _ResetDoneState();
}

class _ResetDoneState extends State<PaymentDone> {
  Future<void> setPlan() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.num)
        .update({
      'plan': 'Standard',
    });
  }

  @override
  void initState() {
    setPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 104),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  'Payment completed!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Your payment has been processed successfully and your plan has been upgraded. You will now have access to the benefits of your new plan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 72),
          Container(
            height: 257,
            // color: Colors.green,
            padding: const EdgeInsets.only(left: 50, right: 50),

            child: Image.asset('assets/onboarding/Payment.png'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0,
                shadowColor: Colors.transparent,
                fixedSize: const Size(342, 54),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 88),
        ],
      ),
    );
  }
}
