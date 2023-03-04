import 'dart:io';
import 'package:findout/Home.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/More.dart';
import 'package:findout/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'main.dart';



class NavigationBottomBarUser extends StatefulWidget {
  @override
  _NavigationBottomBarUserState createState() =>
      _NavigationBottomBarUserState();
}

class _NavigationBottomBarUserState extends State<NavigationBottomBarUser> {
  int currentState = 0;
  PageController _pageController = PageController();
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();

    var androidInitialize = const AndroidInitializationSettings('@drawable/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    
      if (kDebugMode) {
        print("onMessage: ${message.data}");
        print("onMessage####: ${message.data['value_check']}");
      }

      String? _body = message.notification!.body;
      String? _title = message.notification!.title;
      if(Platform.isIOS){
        _showNotificationCustomSound(_body, _title);

      }
    
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     
      if (kDebugMode) {
        print("onMessageOpenedApp: ${message.data}");

      }

      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
    });
       _pageController = PageController();
    _controller = PersistentTabController(initialIndex: 0);



  }
  Future<void> _showNotificationCustomSound(_body, _title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'notification');
    const MacOSNotificationDetails macOSPlatformChannelSpecifics =
    MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      _title,
      _body,
      platformChannelSpecifics,
    );
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  List<Widget> _buildScreens() {
    return [
      Home(),
      More(),
    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10.sp,
            fontWeight: FontWeight.bold
        ),

        icon: const Icon(Icons.home),
      
        title: ('home'.tr()),
        activeColorPrimary: AppColors.orangeColor,
        inactiveColorPrimary: AppColors.blackColor,),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10.sp,
            fontWeight: FontWeight.bold
        ),
        icon: const Icon(Icons.more_horiz_sharp),
       
        title: ('more'.tr()),
        activeColorPrimary: AppColors.orangeColor,
        inactiveColorPrimary: AppColors.blackColor,),


    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentState = index;
              });
            },
            children: [
              Home(),
              More(),

            ],
          ),
        ),
        bottomNavigationBar:

        PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: AppColors.whiteColor, 
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true, 
          hideNavigationBarWhenKeyboardShows: true, 
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: AppColors.whiteColor,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( 
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style6, 
        )








    );
  }


}
