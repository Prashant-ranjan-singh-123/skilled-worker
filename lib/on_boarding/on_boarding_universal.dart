import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:v_bhartiya/on_boarding/style_on_boarding_page.dart';

class OnBoardingSubPageCreate extends StatelessWidget {
  String title;
  String body;
  String pathOfImage;

  OnBoardingSubPageCreate({
    Key? key,
    required this.title,
    required this.body,
    required this.pathOfImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/onboarding/wave.svg',
                color: Theme.of(context).colorScheme.primary,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            pathOfImage
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height*0.01,),
                    Text(title, style: TextStyleIs().heading(context)),
                    const SizedBox(height: 15),
                    Text(
                      body,
                      style: TextStyleIs().subtitle(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
