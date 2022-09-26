import 'dart:async';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/Ads.dart';
import 'package:findout/AddPlace.dart';
import 'package:findout/Events/Events.dart';
import 'package:findout/Favorits.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/PageView/PageView1.dart';
import 'package:findout/api/webpage.dart';
import 'package:findout/internet.dart';
import 'package:findout/provider/findout_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class More extends StatefulWidget {
  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var findprov = Provider.of<FindoutProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            WidgetAppBar().AppBarHome(context, false),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen:  Events(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AvatarGlow(
                              glowColor: AppColors.orangeColor,
                              endRadius: 16.0,
                              animate: true,
                              duration: const Duration(milliseconds: 1000),
                              repeat: true,
                              showTwoGlows: true,
                              child: Image.asset(
                                "assets/images/ic_event.png",
                                width: 16.w,
                                height: 12.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'importantEvents'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen:  Favorits(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/ic_fav.png",
                              width: 16.w,
                              height: 12.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'fav'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                findprov
                    .support(
                  findprov.token,
                  context,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/ic_call.png",
                              width: 16.w,
                              height: 12.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'call'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                findprov
                    .about(
                  findprov.token,
                  context,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/about.png",
                              width: 16.w,
                              height: 12.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'about'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen:  AddPlace(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/add.png",
                              width: 16.w,
                              height: 12.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'add'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                translator.setNewLanguage(
                  context,
                  newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
                  remember: true,
                  restart: true,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                    Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                         const Icon(Icons.language,color: AppColors.orangeColor,),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'selsctLang'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                Share.share('''
                          Find Out
                          Download it from google play on
                          https://play.google.com/store/apps/details?id=vision.findout
                          or from apple store on                          
                          https://apps.apple.com/us/app/find-out/id1641612068''', subject: 'appTitle'.tr());


              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  width: width.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                    Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0d000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                         const Icon(Icons.share,color: AppColors.orangeColor,),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'share'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.string(
                          '<svg viewBox="114.0 335.5 200.0 1.0" ><path transform="translate(114.0, 335.5)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            SvgPicture.string(
              '<svg viewBox="114.0 619.0 200.0 1.0" ><path transform="translate(114.0, 619.0)" d="M 0 0 L 200 0" fill="none" stroke="#e8e8e8" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
            // SizedBox(
            //   height: 20.h,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(
                        context)
                        .push(
                      PageRouteBuilder(
                        transitionDuration:
                        Duration(
                            milliseconds:
                            2000),
                        pageBuilder: (BuildContext context,
                            Animation<
                                double>
                            animation,
                            Animation<
                                double>
                            secondaryAnimation) {
                          return WebPage(
                              findprov.facebook.toString());
                        },
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/facebook.png",
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
                SizedBox(
                  width: 20.h,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(
                        context)
                        .push(
                      PageRouteBuilder(
                        transitionDuration:
                        const Duration(
                            milliseconds:
                            2000),
                        pageBuilder: (BuildContext context,
                            Animation<
                                double>
                            animation,
                            Animation<
                                double>
                            secondaryAnimation) {
                          return WebPage(
                              findprov.instagram.toString());
                        },
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/instagram.png",
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
                SizedBox(
                  width: 20.h,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(
                        context)
                        .push(
                      PageRouteBuilder(
                        transitionDuration:
                        Duration(
                            milliseconds:
                            2000),
                        pageBuilder: (BuildContext context,
                            Animation<
                                double>
                            animation,
                            Animation<
                                double>
                            secondaryAnimation) {
                          return WebPage(
                              findprov.twitter.toString());
                        },
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/twitter.png",
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
