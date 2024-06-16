import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';

import '../utils/snakbar.dart';

class NotificationExpand extends StatefulWidget {
  final String title;
  final String body;
  final String image;
  const NotificationExpand({super.key, required this.title, required this.body, required this.image});
  @override
  State<NotificationExpand> createState() => _NotificationExpandState();
}

class _NotificationExpandState extends State<NotificationExpand> {
  void back_button(){
    Get.back();
  }

  double returnSmall(){
    if(Get.width>Get.height){
      return Get.height;
    }
    return Get.width;
  }

  Future<void> showErrorMessage() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Center(child: Text('Permission Denied', style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600, fontFamily: 'Oswald', fontSize: 30),)),
          content: Text('Please grant storage permission to download the image.', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.primary,
              child: const Text('OK', style: TextStyle(fontFamily: 'Oswald'),),
            ),
          ],
        ),
      );
    }
  }

  void _saveNetworkImage(String path) async {
    await GallerySaver.saveImage(path);
    SnakbarCustom().show('Saved', 'Photo Successfully saved to gallery');
  }


  @override
  void initState() {
    // askPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var image = widget.image.replaceAll('https:/', 'https://');
    print('image is: ');
    print(image);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('User Notification',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              fontSize: 25
          ),),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                        Get.dialog(
                          AlertDialog(
                            content: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.background,
                                          blurStyle: BlurStyle.normal,
                                          spreadRadius: 50,
                                          blurRadius: 150,
                                        )
                                      ]
                              ),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Get.back();
                                },
                                color: Theme.of(context).colorScheme.error,
                                child: const Text('Close'),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  Get.back();
                                  _saveNetworkImage(image);
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: const Text('Download'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.background,
                        elevation: 15,
                        borderOnForeground: true,
                        child: SizedBox(
                          width: returnSmall() * 0.9,
                          height: returnSmall() * 0.7,
                          // decoration: BoxDecoration(
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Theme.of(context).colorScheme.primary,
                          //         blurStyle: BlurStyle.normal,
                          //         spreadRadius: 2,
                          //         blurRadius: 5,
                          //       )
                          //     ]
                          // ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                image,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.9,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  // Display a local image when there's an error loading the network image
                                  return Image.asset(
                                    'assets/onboarding/show_message.png',
                                    width: MediaQuery.of(context).size.width * 0.9,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: SelectableText('Title', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(widget.title, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300,),),
                  ),
                  Divider(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2), thickness: 2,),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: SelectableText('Body', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(widget.body,
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300,),),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
                  Card(
                    elevation: 10,
                    child: ElevatedButton(
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
                        back_button();
                      },
                      child: const Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white,),
                          SizedBox(width: 12,),
                          Text('Back',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto'
                          ),),
                        ],
                      ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.07),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
