import 'dart:io';
import 'package:findout/Home.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/More.dart';
import 'package:findout/internet.dart';
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
    // TODO: implement initState
    super.initState();

    var androidInitialize = const AndroidInitializationSettings('@drawable/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().runningOrders != null) {
      //   _orderCount = Get.find<OrderController>().runningOrders.length;
      // }
      if (kDebugMode) {
        print("onMessage: ${message.data}");
        print("onMessage####: ${message.data['value_check']}");
      }

      String? _body = message.notification!.body;
      String? _title = message.notification!.title;
      if(Platform.isIOS){
        _showNotificationCustomSound(_body, _title);

      }
      // String _type = message.notification.bodyLocKey;
      // String _body = message.notification.body;
      // Get.find<OrderController>().getPaginatedOrders(1, true);
      // Get.find<OrderController>().getCurrentOrders();
      // if(_type == 'new_order' || _body == 'New order placed') {
      //   // _orderCount = _orderCount + 1;
      //   Get.dialog(NewRequestDialog());
      // }else {
      // }
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().runningOrders != null) {
      //   _orderCount = Get.find<OrderController>().runningOrders.length;
      // }
      if (kDebugMode) {
        print("onMessageOpenedApp: ${message.data}");

      }

      // String _type = message.notification.bodyLocKey;
      // String _body = message.notification.body;
      // Get.find<OrderController>().getPaginatedOrders(1, true);
      // Get.find<OrderController>().getCurrentOrders();
      // if(_type == 'new_order' || _body == 'New order placed') {
      //   // _orderCount = _orderCount + 1;
      //   Get.dialog(NewRequestDialog());
      // }else {
      // }
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
    // TODO: implement dispose
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
        // const ImageIcon(
        //   AssetImage("assets/images/more.png"),
        // ),
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
        // const ImageIcon(
        //   AssetImage("assets/images/fav.png"),
        // ),
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
          backgroundColor: AppColors.whiteColor, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: AppColors.whiteColor,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
        )








    );
  }


}
