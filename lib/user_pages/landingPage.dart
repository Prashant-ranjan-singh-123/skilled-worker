import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../utils/Internet/CheckInternetConnectionWidget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  Future<void> chkInternet() async {
    Future<bool> checkInternetConnection() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }
    Timer.periodic(Duration(seconds: 5),(_) async {
      if(await checkInternetConnection()){
      }else{
      print('No internet');
      InternetConnection().showAlertDialog(context);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // chkInternet();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
          body: Column(
            children: [
              // OfflineBanner(),
              SizedBox(height: MediaQuery.of(context).padding.top+10),
              const Expanded(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'SKILLED ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          )
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'WORKER',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          )
      );
  }
}