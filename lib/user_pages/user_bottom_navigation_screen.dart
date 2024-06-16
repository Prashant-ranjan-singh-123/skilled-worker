import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:v_bhartiya/user_pages/billing_screen.dart';
import 'package:v_bhartiya/user_pages/landingPage.dart';
import 'package:v_bhartiya/user_pages/user_notification_screen.dart';
import 'package:v_bhartiya/user_pages/user_profile_screen.dart';
import '../utils/Internet/CheckInternetConnectionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainScreenUser extends StatefulWidget {
  @override
  final int pageNumber;

  const MainScreenUser({super.key, required this.pageNumber});
  State<MainScreenUser> createState() => _MainScreenUserState();

}

class _MainScreenUserState extends State<MainScreenUser> {
  late int curPage;
  late final PageController _pageController;
  late final NotchBottomBarController _controller;
  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    curPage = widget.pageNumber;
    _pageController = PageController(initialPage: curPage);
    _controller = NotchBottomBarController(index: curPage);
    setState(() {});
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const LandingPage(),
    const UserNotification(),
    BillingScreen(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
        /// Provide NotchBottomBarController
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: false,
        shadowElevation: 5,
        kBottomRadius: 28.0,


        // notchShader: const SweepGradient(
        //   startAngle: 0,
        //   endAngle: pi / 2,
        //   colors: [Colors.red, Colors.green, Colors.orange],
        //   tileMode: TileMode.mirror,
        // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
        notchColor: Colors.black87,

        /// restart app if you change removeMargins
        removeMargins: false,
        bottomBarWidth: 500,
        durationInMilliSeconds: 250,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.add_business_sharp,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.add_business_sharp,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 1',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.notifications,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.notifications_active,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 2',
          ),

          ///svg example
          BottomBarItem(
            inActiveItem: Icon(
              Icons.add_card_sharp,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.credit_card,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 3',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person_pin_outlined,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.person_pin_sharp,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Page 4',
          ),
        ],
        onTap: (index) {
          log('current selected index $index');
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      )
          : null,
    );
  }
}


// class MainScreenUser extends StatefulWidget {
//   const MainScreenUser({super.key});
//
//   @override
//   State<MainScreenUser> createState() => _MainScreenUserState();
// }
//
// class _MainScreenUserState extends State<MainScreenUser> {
//   int index = 2;
//   final screen = [
//     const LandingPage(),
//     const UserNotification(),
//     BillingScreen(),
//     UserProfile(),
//   ];
//   Color bottomNavBarBack= Colors.black;
//   Color bottomNavBarIconActive= Colors.black;
//   Color bottomNavBarIcon= Colors.white30;
//   Color bottomNavBarActiveBox= Colors.white;
//   Color bottomNavBarText = Colors.white;
//   Color tabBackgroundColor = Colors.white54;
//
//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       const Icon(Icons.home, size: 30),
//       const Icon(Icons.notifications, size: 30),
//       const Icon(Icons.payment_rounded, size: 30),
//       const Icon(Icons.face, size: 30)
//     ];
//     return Scaffold(
//       backgroundColor: Colors.purpleAccent,
//       extendBody: true,
//       body: screen[index],
//       // Center(
//       //   child: Text(
//       //     '$index',
//       //     style: const TextStyle(
//       //         fontSize: 110, fontWeight: FontWeight.bold, color: Colors.white),
//       //   ),
//       // ),
//
//       // bottomNavigationBar:
//       // CurvedNavigationBar(
//       //   // navigationBar colors
//       //   color: Theme.of(context).colorScheme.primary,
//       //   //selected times colors
//       //   buttonBackgroundColor: Theme.of(context).colorScheme.background,
//       //   backgroundColor: Colors.transparent,
//       //   animationCurve: Curves.bounceOut,
//       //   animationDuration: Duration(milliseconds: 400),
//       //   items: items,
//       //   height: 60,
//       //   index: index,
//       //   onTap: (index) => setState(
//       //         () => this.index = index,
//       //   ),
//       // ),
//
//
//         bottomNavigationBar: GNav(
//           gap: 8,
//             backgroundColor: Colors.black,
//             tabBackgroundColor: tabBackgroundColor,
//             tabs: [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//                 iconColor: bottomNavBarIcon,
//                 iconActiveColor: bottomNavBarIconActive,
//                 textColor: bottomNavBarText,
//               ),
//               GButton(
//                 icon: Icons.heart_broken,
//                 text: 'Likes',
//                 iconColor: bottomNavBarIcon,
//                 iconActiveColor: bottomNavBarIconActive,
//                 textColor: bottomNavBarText,
//               ),
//               GButton(
//                 icon: Icons.search,
//                 text: 'Search',
//                 iconColor: bottomNavBarIcon,
//                 iconActiveColor: bottomNavBarIconActive,
//                 textColor: bottomNavBarText,
//               ),
//               GButton(
//                 icon: Icons.verified_user,
//                 text: 'Profile',
//                 iconColor: bottomNavBarIcon,
//                 iconActiveColor: bottomNavBarIconActive,
//                 textColor: bottomNavBarText,
//               )
//             ]
//         )
//     );
//   }
// }