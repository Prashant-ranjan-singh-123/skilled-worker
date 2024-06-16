import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_bhartiya/authantication/login_or_signup_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import 'on_boarding_universal.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast=false;
  bool isFirst=true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primary,
    ));

    List pages;
    pages = [
      OnBoardingSubPageCreate(
        title: 'Login',
        body: 'Welcome to our platform! Simply login with your credentials to access a world of possibilities.',
        pathOfImage: 'assets/onboarding/login.png',),

      OnBoardingSubPageCreate(
        title: 'Profile',
        body: 'Easily customize your personal information, and more through our intuitive Profile feature.',
        pathOfImage: 'assets/onboarding/Profile.png',),

      OnBoardingSubPageCreate(
        title: 'Payment',
        body: 'Explore our diverse range of payment plans, each designed to provide flexibility and cater to your specific needs and preferences.',
        pathOfImage: 'assets/onboarding/Payment.png',),

      OnBoardingSubPageCreate(
        title: 'Notification',
        body: 'Stay informed with personalized notifications tailored to your preferences and never miss important updates or announcements from our platform.',
        pathOfImage: 'assets/onboarding/Management.png',),
      // const PageTwo(),
      // const PageThree(),
      // const PageFour()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 15,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
                onPageChanged: (int val){
                  if(val==0){
                    isLast=false;
                    isFirst=true;
                  }if(val==3){
                    isLast=true;
                    isFirst=false;
                  }if(val!=3&&val!=0){
                    isLast=false;
                    isFirst=false;
                  }
                  setState(() {
                    isLast;
                    isFirst;
                  });
                },
              controller: controller,
                children: List.generate(pages.length, (index) => pages[index]),
            ),
          ),
          Align(
            alignment: const Alignment(0,0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!isFirst) InkWell(
                  onTap: (){
                    controller.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  },
                    child: CircleAvatar(
                      child: Icon(Icons.navigate_before, color: Theme.of(context).colorScheme.background,),
                    )
                )
                else CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  child: Icon(Icons.navigate_before, color: Theme.of(context).colorScheme.background,),
                ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 4,
                  effect: ScrollingDotsEffect(
                    dotColor: Theme.of(context).colorScheme.primary,
                    activeDotColor: Theme.of(context).colorScheme.onPrimary,
                    fixedCenter: true,
                      dotWidth: 7,
                    activeDotScale: 1.1,
                    dotHeight: 7
                  ),
                ),
                if (!isLast) InkWell(
                  onTap: (){
                    controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  },
                    child: CircleAvatar(
                      child: Icon(Icons.navigate_next, color: Theme.of(context).colorScheme.background,),
                    ))
                else InkWell(
                  onTap: (){
                    Get.off(const LoginOrSignUpAsking(), transition: Transition.fade, duration: const Duration(milliseconds: 500));
                  }, child: CircleAvatar(
                  child: Icon(Icons.navigate_next, color: Theme.of(context).colorScheme.background,),
                ))
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: SvgPicture.asset(
          //     'assets/onboarding/wave.svg',
          //     color: Theme.of(context).colorScheme.primary,
          //     width: MediaQuery.of(context).size.width,
          //   ),
          // ),
        ],
      ),
    );
  }
}