import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentFail extends StatefulWidget {
  const PaymentFail({Key? key}) : super(key: key);

  @override
  State<PaymentFail>  createState() => _ResetDoneState();
}

class _ResetDoneState extends State<PaymentFail> {
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
                  'Payment Failed!',
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
                  'We encountered an issue processing your payment. Please review your payment information and try again.',
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

            child: Image.asset('assets/onboarding/payment_fail.jpeg'),
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
                fixedSize: Size(342, 54),
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
          SizedBox(height: 88),
        ],
      ),
    );
  }
}
